BSVBASEDIR=$(abspath ..)
BASEDIR=$(abspath .)
CONNECTALDIR=/opt/connectal

# Define HW->SW / SW->HW interfaces
S2H_INTERFACES = MyDutRequest:MyDut.request
H2S_INTERFACES = MyDut:MyDutIndication

# FILES
BSVFILES = MyDut.bsv
CPPFILES = connectal_test.cpp
BSVDIR = $(BSVBASEDIR)/common:$(BSVBASEDIR)/fft:$(BSVBASEDIR)/fir:$(BSVBASEDIR)/pitch

# Connectal Flags
CONNECTALFLAGS += --mainclockperiod 15
CONNECTALFLAGS += --bsvpath $(BSVDIR) --bscflags " -u --keep-fires "

include $(CONNECTALDIR)/Makefile.connectal

.PHONY: simulation fpga fpgaUpdateSW run_simulation run_fpga program_fpga run_fpgaSW


simulation:
	rm -rf $(BASEDIR)/bluesim
	$(MAKE) build.bluesim

fpga:
	rm -rf $(BASEDIR)/vc707g2
	$(MAKE) build.vc707g2

fpgaUpdateSW:
	rm -f $(BASEDIR)/vc707g2/bin/ubuntu.exe $(BASEDIR)/vc707g2/jni/ubuntu.exe
	make -C $(BASEDIR)/vc707g2 ubuntu.exe

run_simulation:
	$(BASEDIR)/bluesim/bin/ubuntu.exe ${ARG1}

run_fpga:
	lockfile -5 -r 3 -l 120 -s 2 /tmplock/fpgalock
	$(BASEDIR)/vc707g2/bin/ubuntu.exe ${ARG1}
	rm -f /tmplock/fpgalock

program_fpga:
	lockfile -5 -r 3 -l 120 -s 2 /tmplock/fpgalock
	fpgajtag $(BASEDIR)/vc707g2/bin/mkTop.bin.gz
	rm -f /tmplock/fpgalock

run_fpgaSW:
	lockfile -5 -r 3 -l 120 -s 2 /tmplock/fpgalock
	NOPROGRAM=1 $(BASEDIR)/vc707g2/bin/ubuntu.exe ${ARG1}
	rm -f /tmplock/fpgalock


# BSV synthesize and sim
bscflags = -keep-fires -aggressive-conditions
src = $(wildcard ../common/*.bsv) $(wildcard ../fft/*.bsv) $(wildcard ../fir/*.bsv) $(wildcard ../pitch/*.bsv)
bsvdir = ../common:../fir:../fft:../pitch
build_dir = bscdir
synth_dir = /tmp/6375-lab4

simAudioPipeline: $(src)
	mkdir -p bscdir
	bsc -u -sim -simdir $(build_dir) -bdir $(build_dir) -info-dir $(build_dir) $(bscflags) -p +:$(bsvdir) -g mkTestDriver ../common/TestDriver.bsv
	bsc -e mkTestDriver -sim -o $@ -simdir $(build_dir) -bdir $(build_dir) -info-dir $(build_dir) $(bscflags)

synthAudioPipeline: $(src)
	mkdir -p $(synth_dir)
	synth ../common/AudioPipeline.bsv mkAudioPipeline -p $(bsvdir) -s $(synth_dir) -l multisize

clean:
	rm -rf bscdir simAudioPipeline *.so