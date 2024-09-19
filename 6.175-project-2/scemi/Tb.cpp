
#include <iostream>
#include <unistd.h>
#include <cmath>
#include <cstdio>
#include <cstdlib>

#include "bsv_scemi.h"
#include "SceMiHeaders.h"
#include "ResetXactor.h"


// Initialize the memories from the given vmh file.
bool mem_init(const char *filename, InportProxyT<MemInit>& mem)
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

    uint32_t addr = 0;
    while ((read = getline(&line, &len, file)) != -1) {
        if (read != 0) {
            if (line[0] == '@') {
                addr = strtoul(&line[1], NULL, 16);
            } else {
                uint32_t data = strtoul(line, NULL, 16);

                MemInit msg;
                msg.the_tag = MemInit::tag_InitLoad;
                msg.m_InitLoad.m_addr = addr;
                msg.m_InitLoad.m_data = data;
                mem.sendMessage(msg);

                addr++;
            }
        }
    }

    free(line);
    fclose(file);

    MemInit msg;
    msg.the_tag = MemInit::tag_InitDone;
    mem.sendMessage(msg);
    return true;
}

int main(int argc, char* argv[])
{
    if (argc < 2) {
        fprintf(stderr, "usage: TestDriver [num-cores] <vmh-file>\n");
        return 1;
    }

    // number of cores to use
    int num_cores = 1;
    FromHost dummyfromhost;
    int num_cores_available = dummyfromhost.m_tpl_1.getBitSize();

    int sceMiVersion = SceMi::Version( SCEMI_VERSION_STRING );
    SceMiParameters params("scemi.params");
    SceMi *sceMi = SceMi::Init(sceMiVersion, &params);

    // Initialize the SceMi ports
    InportProxyT<MemInit> mem("", "scemi_mem_inport", sceMi);
    OutportQueueT<ToHost> tohost("", "scemi_tohost_outport", sceMi);
    InportProxyT<FromHost> fromhost("", "scemi_fromhost_inport", sceMi);
    OutportProxyT< BitT<1> > isrunning("", "scemi_isrunning_outport", sceMi);
    ResetXactor reset("", "scemi", sceMi);
    ShutdownXactor shutdown("", "scemi_shutdown", sceMi);

    // Service SceMi requests
    SceMiServiceThread *scemi_service_thread = new SceMiServiceThread(sceMi);

    // Loop through command line arguments
    for( int arg_num = 1 ; arg_num < argc ; arg_num++ ) {
        // Check if the arg_num corresponds to the number of processors to use
        int new_num_cores = 0;
        int char_index = 0;
        while( argv[arg_num][char_index] != '\0' ) {
            if( argv[arg_num][char_index] >= '0' && argv[arg_num][char_index] <= '9' ) {
                new_num_cores *= 10;
                new_num_cores += (int) (argv[arg_num][char_index] - '0');
            } else {
                // keep the same number of cores
                break;
            }
            char_index++;
        }
        if( num_cores <= 0 || num_cores > num_cores_available ) {
            std::cerr << "ERROR: Invalid number of cores requested! (" << num_cores << " cores requested, only " << num_cores_available << " available)" << std::endl;
            // exit with error status 1
            return 1;
        } else if( argv[arg_num][char_index]  == '\0' ) {
            num_cores = new_num_cores;
            if( arg_num == 1 ) {
                std::cerr << "Using " << num_cores << " core" << ((num_cores > 1) ? "s" : "" ) << std::endl;
            } else {
                std::cerr << "Switching to " << num_cores << " core" << ((num_cores > 1) ? "s" : "" ) << std::endl;
            }
            // go to the next for loop iteration
            continue;
        } else if( arg_num == 1 ) {
            std::cerr << "Assuming " << num_cores << " core(s)" << std::endl;
            // continue current loop iteration
        }

        char* vmh = argv[arg_num];

        fprintf(stderr, "%s\n", vmh);

        // Reset the dut.
        reset.reset();

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

        // Start cores
        FromHost startmessage;
        startmessage.m_tpl_1 = (1 << num_cores) - 1;
        startmessage.m_tpl_2 = 0x1000;
        fromhost.sendMessage( startmessage );

        // Handle tohost requests.
        int last_core_id = -1;
        int returns = 0;
        while (true) {
            ToHost msg = tohost.getMessage();
            uint32_t core_id = msg.m_tpl_1;
            uint32_t idx = msg.m_tpl_2;
            uint32_t data = msg.m_tpl_3;

            if( num_cores > 1 ) {
                if( last_core_id == -1 ) {
                    fprintf(stderr, "core%d: ", core_id);
                } else if( core_id != last_core_id ) {
                    fprintf(stderr, "\ncore%d: ", core_id);
                }
                last_core_id = core_id;
            }

            if (idx == 18) {
                fprintf(stderr, "%i", data);
            } else if (idx == 19) {
                fprintf(stderr, "%c", data);
            } else if (idx == 21) {
                if(data == 0) {
                  fprintf(stderr, "\e[0;32mPASSED\e[00m");
                } else {
                  fprintf(stderr, "\e[01;31mFAILED %d\e[00m", data);
                }
                returns++;
                if( returns == num_cores ) {
                    fprintf(stderr, "\n");
                    break;
                }
            }
        }
    }

    shutdown.blocking_send_finish();
    scemi_service_thread->stop();
    scemi_service_thread->join();
    SceMi::Shutdown(sceMi);

    return 0;
}

