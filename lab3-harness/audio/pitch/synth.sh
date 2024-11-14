#! /bin/bash
cd $HOME/MIT-course-training/yosys-sta
make sta DESIGN=mkAudioPipeline SDC_FILE=../lab3-harness/audio/pitch/AudioPipeline.sdc \
     RTL_FILES="/opt/bsc/lib/Verilog/FIFO2.v /opt/bsc/lib/Verilog/RevertReg.v ../lab3-harness/audio/pitch/bscdir/mkAudioPipeline.v ../lab3-harness/audio/pitch/bscdir/mkMultiplier.v" \
     CLK_FREQ_MHZ=100
cd -