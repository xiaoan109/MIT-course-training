
#include <iostream>
#include <unistd.h>
#include <cmath>
#include <cstdio>
#include <cstdlib>

#include "bsv_scemi.h"
#include "SceMiHeaders.h"
#include "ResetXactor.h"


// Initialize the memories from the given vmh file.
bool mem_init(const char *filename, InportProxyT<WideMemInit>& mem)
{
    char *line;
    size_t len = 0;
    int read;

    FILE *file = fopen(filename, "r");

    if (file == NULL)
    {
        fprintf(stderr, "could not open VMH file %s.\n", filename);
        return false;
    }

    bool line_to_write = false;
    uint32_t ddr3_addr = 0;
    uint32_t word_index = 0;
    BitT<512> wide_data;
    for( int i = 0 ; i < 16 ; i++ ) {
        wide_data.setWord( i, 0 );
    }

    // this loader assumes the file comes in order

    while ((read = getline(&line, &len, file)) != -1) {
        if (read != 0) {
            if (line[0] == '@') {
                // word address
                uint32_t addr = strtoul(&line[1], NULL, 16);
                // compute the ddr3 address and word index
                uint32_t next_ddr3_addr = addr / 16;
                uint32_t next_word_index = addr % 16;
                // switching to a new line, but we need to send the old line to the FPGA/Simulator
                if( next_ddr3_addr != ddr3_addr && line_to_write == true ) {
                    WideMemInit msg;
                    msg.the_tag = WideMemInit::tag_InitLoad;
                    msg.m_InitLoad.m_addr = ddr3_addr;
                    msg.m_InitLoad.m_data = wide_data;
                    mem.sendMessage(msg);
                    // std::cout << "writing line at ddr3_addr: " << std::hex << ddr3_addr << std::endl;
                    line_to_write = false;
                    for( int i = 0 ; i < 16 ; i++ ) {
                        wide_data.setWord( i, 0 );
                    }
                }
                // update the address and word index
                ddr3_addr = next_ddr3_addr;
                word_index = next_word_index;
                // std::cout << "addr: " << std::hex << addr << ", ddr3_addr: " << ddr3_addr << ", word_index: " << std::dec << word_index << std::endl;
            } else if ( (line[0] >= '0' && line[0] <= '9') || (line[0] >= 'a' && line[0] <= 'f') || (line[0] >= 'A' && line[0] <= 'F') ) {
                uint32_t word = strtoul(line, NULL, 16);
                wide_data.setWord(word_index, word);
                line_to_write = true;

                // if we just got to the end of a line, send it to the FPGA/Simulator
                if( word_index == 15 && line_to_write == true ) {
                    WideMemInit msg;
                    msg.the_tag = WideMemInit::tag_InitLoad;
                    msg.m_InitLoad.m_addr = ddr3_addr;
                    msg.m_InitLoad.m_data = wide_data;
                    mem.sendMessage(msg);
                    // std::cout << "writing line at ddr3_addr: " << std::hex << ddr3_addr << std::endl;
                    line_to_write = false;
                    for( int i = 0 ; i < 16 ; i++ ) {
                        wide_data.setWord( i, 0 );
                    }
                }

                // increment the counter
                if( word_index == 15 ) {
                    word_index = 0;
                    ddr3_addr++;
                } else {
                    word_index++;
                }
            }
        }
    }
    // write the last line if there is a line to write
    if( line_to_write == true ) {
        WideMemInit msg;
        msg.the_tag = WideMemInit::tag_InitLoad;
        msg.m_InitLoad.m_addr = ddr3_addr;
        msg.m_InitLoad.m_data = wide_data;
        mem.sendMessage(msg);
        // std::cout << "writing line at ddr3_addr: " << std::hex << ddr3_addr << std::endl;
        line_to_write = false;
        for( int i = 0 ; i < 16 ; i++ ) {
            wide_data.setWord( i, 0 );
        }
    }

    free(line);
    fclose(file);

    WideMemInit msg;
    msg.the_tag = WideMemInit::tag_InitDone;
    mem.sendMessage(msg);
    return true;
}

int main(int argc, char* argv[])
{
    if (argc < 2) {
        fprintf(stderr, "usage: TestDriver <vmh-file>\n");
        return 1;
    }

    int sceMiVersion = SceMi::Version( SCEMI_VERSION_STRING );
    SceMiParameters params("scemi.params");
    SceMi *sceMi = SceMi::Init(sceMiVersion, &params);

    // Initialize the SceMi ports
    InportProxyT<WideMemInit> mem("", "scemi_mem_inport", sceMi);
    OutportQueueT<ToHost> tohost("", "scemi_tohost_outport", sceMi);
    InportProxyT<FromHost> fromhost("", "scemi_fromhost_inport", sceMi);
    ResetXactor reset("", "scemi", sceMi);
    ShutdownXactor shutdown("", "scemi_shutdown", sceMi);

    // Service SceMi requests
    SceMiServiceThread *scemi_service_thread = new SceMiServiceThread(sceMi);

    // loop through all of the files in the command line
    for( int file_number = 1 ; file_number < argc ; file_number++ ) {
        // Reset the dut.
        reset.reset();

        // Get the VMH file to load.
        char* vmh = argv[file_number];
        std::cout << vmh << std::endl;

        // Initialize the memories.
        if (!mem_init(vmh, mem)) {
            fprintf(stderr, "Failed to load memory\n");
            std::cout << "shutting down..." << std::endl;
            shutdown.blocking_send_finish();
            scemi_service_thread->stop();
            scemi_service_thread->join();
            SceMi::Shutdown(sceMi);
            std::cout << "finished" << std::endl;
            return 1;
        }

        // Start the core
        fromhost.sendMessage(0x1000);

        // Handle tohost requests.
        while (true) {
            ToHost msg = tohost.getMessage();
            uint32_t idx = msg.m_tpl_1;
            uint32_t data = msg.m_tpl_2;

            if (idx == 18) {
                fprintf(stderr, "%i", data);
            } else if (idx == 19) {
                fprintf(stderr, "%c", data);
            } else if (idx == 21) {
                if(data == 0) {
                  fprintf(stderr, "PASSED\n");
                } else {
                  fprintf(stderr, "FAILED %d\n", data);
                }
                break;
            }
        }
    }

    shutdown.blocking_send_finish();
    scemi_service_thread->stop();
    scemi_service_thread->join();
    SceMi::Shutdown(sceMi);

    return 0;
}

