
#=======================================================================
# UCB VLSI FLOW: Makefile for riscv-bmarks
#-----------------------------------------------------------------------
# Yunsup Lee (yunsup@cs.berkeley.edu)
#
SHELL := /bin/bash

default: all

bmarkdir := $(CURDIR)
build_dir := $(bmarkdir)/../build/smallbenchmarks
bin_dir := $(build_dir)/bin
obj_dir := $(build_dir)/obj
dump_dir := $(build_dir)/dump
vmh_dir := $(build_dir)/vmh

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

bmarks = \
	median \
	qsort \
	towers \
	vvadd \
	multiply \

bmarks_host = \

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

HOST_OPTS := -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=1 -I$(commondir)
HOST_COMP := gcc $(HOST_OPTS)

RISCV_TOOL_DIR := /mit/6.375/rv32-gcc/bin
RISCV_PREFIX := $(RISCV_TOOL_DIR)/riscv32-unknown-elf
# gcc
RISCV_GCC := $(RISCV_PREFIX)-gcc
RISCV_GCC_OPTS := -static -Wa,-march=RVI -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf
incs := -I$(bmarkdir)/../env -I$(bmarkdir)/common
bmarks_defs := -DPREALLOCATE=0 -DHOST_DEBUG=0
# link
RISCV_LINK := $(RISCV_GCC) -T$(bmarkdir)/common/test.ld $(incs)
RISCV_LINK_OPTS := -nostdlib -nostartfiles -ffast-math -lc -lgcc
# objdump
RISCV_OBJDUMP := $(RISCV_PREFIX)-objdump --disassemble --disassemble-zeroes --section=.text --section=.text.startup --section=.data
# convert to VMH: 64KB memory
RISCV_ELF2HEX := $(RISCV_TOOL_DIR)/elf2hex
VMH_WIDTH := 8
VMH_DEPTH := 65536

# files
c_srcs := $(foreach bench,$(bmarks),$(wildcard $(bmarkdir)/$(bench)/*.c))
c_srcs += $(bmarkdir)/common/syscalls.c
c_objs := $(patsubst $(bmarkdir)/%.c,$(obj_dir)/%.o,$(c_srcs))

asm_srcs := $(bmarkdir)/common/crt.S
asm_objs := $(patsubst $(bmarkdir)/%.S,$(obj_dir)/%.o,$(asm_srcs))

#------------------------------------------------------------
# Build and run benchmarks on riscv simulator

bmarks_riscv_bin  := $(patsubst %,$(bin_dir)/%.riscv,$(bmarks))
bmarks_riscv_dump := $(patsubst %,$(dump_dir)/%.riscv.dump,$(bmarks))
bmarks_riscv_vmh  := $(patsubst %,$(vmh_dir)/%.riscv.vmh,$(bmarks))

$(bmarks_riscv_vmh): $(vmh_dir)/%.riscv.vmh: $(bin_dir)/%.riscv
	@echo "@0" > $(vmh_dir)/temp
	$(RISCV_ELF2HEX) $(VMH_WIDTH) $(VMH_DEPTH) $< >> $(vmh_dir)/temp
	python $(bmarkdir)/../trans_vmh.py $(vmh_dir)/temp $@

$(bmarks_riscv_dump): $(dump_dir)/%.riscv.dump: $(bin_dir)/%.riscv
	$(RISCV_OBJDUMP) $< > $@

.SECONDEXPANSION:

PERCENT := % # escape % using secondary expansion

# we must be in the same folder of crt.o
# and crt.o cannot have directory prefix in the gcc link command
$(bmarks_riscv_bin): $(bin_dir)/%.riscv: $$(filter $(obj_dir)/$$(basename $$(notdir $$@))/$$(PERCENT).o $(obj_dir)/common/$$(PERCENT).o,$(c_objs) $(asm_objs))
	cd $(obj_dir)/common; \
	$(RISCV_LINK) $(wildcard $(obj_dir)/$(basename $(notdir $@))/*.o) $(notdir $(wildcard $(obj_dir)/common/*.o)) -o $@ $(RISCV_LINK_OPTS)

$(c_objs): $(obj_dir)/%.o: $(bmarkdir)/%.c
	mkdir -p $(dir $@)
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $(bmarks_defs) -c $(incs) -I$(dir $<) $< -o $@

$(asm_objs): $(obj_dir)/%.o: $(bmarkdir)/%.S
	mkdir -p $(dir $@)
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $(bmarks_defs) -D__ASSEMBLY__=1 -c $(incs) $< -o $@

riscv: $(bin_dir) $(obj_dir) $(dump_dir) $(bmarks_riscv_dump) # $(bmarks_riscv_vmh)


#------------------------------------------------------------
# Build and run benchmarks on host machine

bmarks_host_bin = $(addsuffix .host, $(bmarks_host))

host: $(bin_dir) $(bmarks_host_bin)


#------------------------------------------------------------
# Default
$(bin_dir):
	mkdir -p $@

$(obj_dir):
	mkdir -p $@

$(dump_dir):
	mkdir -p $@

$(vmh_dir):
	mkdir -p $@

all: riscv

# Clean up

clean:
	rm -rf $(build_dir)

.PHONY: all clean riscv host


