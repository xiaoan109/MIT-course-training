#! /bin/bash
cd $HOME/MIT-course-training/yosys-sta
make sta DESIGN=mkFFT SDC_FILE=../lab2-harness/audio/fft/FFT.sdc \
     RTL_FILES="/opt/bsc/lib/Verilog/FIFO2.v /opt/bsc/lib/Verilog/RevertReg.v ../lab2-harness/audio/fft/bscdir/mkFFT.v" \
     CLK_FREQ_MHZ=100
cd -