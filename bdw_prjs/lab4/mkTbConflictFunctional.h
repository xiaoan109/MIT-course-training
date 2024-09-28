/*
 * Generated by Bluespec Compiler, version 2023.01 (build 52adafa5)
 * 
 * On Thu Sep 26 04:27:20 UTC 2024
 * 
 */

/* Generation options: keep-fires */
#ifndef __mkTbConflictFunctional_h__
#define __mkTbConflictFunctional_h__

#include "bluesim_types.h"
#include "bs_module.h"
#include "bluesim_primitives.h"
#include "bs_vcd.h"


/* Class declaration for the mkTbConflictFunctional module */
class MOD_mkTbConflictFunctional : public Module {
 
 /* Clock handles */
 private:
  tClock __clk_handle_0;
 
 /* Clock gate handles */
 public:
  tUInt8 *clk_gate[0];
 
 /* Instantiation parameters */
 public:
 
 /* Module state */
 public:
  MOD_Reg<tUInt8> INST_fifo_data_0;
  MOD_Reg<tUInt8> INST_fifo_data_1;
  MOD_Reg<tUInt8> INST_fifo_data_2;
  MOD_Reg<tUInt8> INST_fifo_deqP;
  MOD_Reg<tUInt8> INST_fifo_empty;
  MOD_Reg<tUInt8> INST_fifo_enqP;
  MOD_Reg<tUInt8> INST_fifo_full;
  MOD_Reg<tUInt32> INST_m_cycle;
  MOD_Reg<tUInt32> INST_m_input_count;
  MOD_Reg<tUInt32> INST_m_output_count;
  MOD_Wire<tUInt8> INST_m_randomA_ignore;
  MOD_Reg<tUInt8> INST_m_randomA_initialized;
  MOD_Wire<tUInt8> INST_m_randomA_zaz;
  MOD_Wire<tUInt8> INST_m_randomB_ignore;
  MOD_Reg<tUInt8> INST_m_randomB_initialized;
  MOD_Wire<tUInt8> INST_m_randomB_zaz;
  MOD_Wire<tUInt8> INST_m_randomC_ignore;
  MOD_Reg<tUInt8> INST_m_randomC_initialized;
  MOD_Wire<tUInt8> INST_m_randomC_zaz;
  MOD_Wire<tUInt8> INST_m_randomData_ignore;
  MOD_Reg<tUInt8> INST_m_randomData_initialized;
  MOD_Wire<tUInt8> INST_m_randomData_zaz;
  MOD_Reg<tUInt32> INST_m_ref_fifo_ehrReg;
  MOD_Reg<tUInt8> INST_m_ref_fifo_ehrReg_1;
  MOD_Reg<tUInt8> INST_m_ref_fifo_ehrReg_2;
  MOD_Reg<tUInt8> INST_m_ref_fifo_ehrReg_3;
  MOD_Reg<tUInt8> INST_m_ref_fifo_ehrReg_4;
  MOD_Wire<tUInt32> INST_m_ref_fifo_ignored_wires_0;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_0_1;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_0_2;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_0_3;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_0_4;
  MOD_Wire<tUInt32> INST_m_ref_fifo_ignored_wires_1;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_1_1;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_1_2;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_1_3;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_1_4;
  MOD_Wire<tUInt32> INST_m_ref_fifo_ignored_wires_2;
  MOD_Wire<tUInt8> INST_m_ref_fifo_ignored_wires_2_1;
  MOD_Fifo<tUInt8> INST_m_ref_fifo_ref_noncf_fifo;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_0;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_0_1;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_0_2;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_0_3;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_0_4;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_1;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_1_1;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_1_2;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_1_3;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_1_4;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_2;
  MOD_Reg<tUInt8> INST_m_ref_fifo_virtual_reg_2_1;
  MOD_Wire<tUInt32> INST_m_ref_fifo_wires_0;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_0_1;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_0_2;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_0_3;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_0_4;
  MOD_Wire<tUInt32> INST_m_ref_fifo_wires_1;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_1_1;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_1_2;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_1_3;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_1_4;
  MOD_Wire<tUInt32> INST_m_ref_fifo_wires_2;
  MOD_Wire<tUInt8> INST_m_ref_fifo_wires_2_1;
 
 /* Constructor */
 public:
  MOD_mkTbConflictFunctional(tSimStateHdl simHdl, char const *name, Module *parent);
 
 /* Symbol init methods */
 private:
  void init_symbols_0();
 
 /* Reset signal definitions */
 private:
  tUInt8 PORT_RST_N;
 
 /* Port definitions */
 public:
 
 /* Publicly accessible definitions */
 public:
  tUInt8 DEF_WILL_FIRE_RL_m_cycle_inc;
  tUInt8 DEF_CAN_FIRE_RL_m_cycle_inc;
  tUInt8 DEF_WILL_FIRE_RL_m_stop_tb;
  tUInt8 DEF_CAN_FIRE_RL_m_stop_tb;
  tUInt8 DEF_WILL_FIRE_RL_m_check_fifos_first;
  tUInt8 DEF_CAN_FIRE_RL_m_check_fifos_first;
  tUInt8 DEF_WILL_FIRE_RL_m_check_fifos_not_empty;
  tUInt8 DEF_CAN_FIRE_RL_m_check_fifos_not_empty;
  tUInt8 DEF_WILL_FIRE_RL_m_check_fifos_not_full;
  tUInt8 DEF_CAN_FIRE_RL_m_check_fifos_not_full;
  tUInt8 DEF_WILL_FIRE_RL_m_maybe_clear;
  tUInt8 DEF_CAN_FIRE_RL_m_maybe_clear;
  tUInt8 DEF_WILL_FIRE_RL_m_check_outputs;
  tUInt8 DEF_CAN_FIRE_RL_m_check_outputs;
  tUInt8 DEF_WILL_FIRE_RL_m_feed_inputs;
  tUInt8 DEF_CAN_FIRE_RL_m_feed_inputs;
  tUInt8 DEF_WILL_FIRE_RL_m_init;
  tUInt8 DEF_CAN_FIRE_RL_m_init;
  tUInt8 DEF_WILL_FIRE_RL_m_cycle_print;
  tUInt8 DEF_CAN_FIRE_RL_m_cycle_print;
  tUInt8 DEF_WILL_FIRE_RL_m_randomData_every_1;
  tUInt8 DEF_CAN_FIRE_RL_m_randomData_every_1;
  tUInt8 DEF_WILL_FIRE_RL_m_randomData_every;
  tUInt8 DEF_CAN_FIRE_RL_m_randomData_every;
  tUInt8 DEF_WILL_FIRE_RL_m_randomC_every_1;
  tUInt8 DEF_CAN_FIRE_RL_m_randomC_every_1;
  tUInt8 DEF_WILL_FIRE_RL_m_randomC_every;
  tUInt8 DEF_CAN_FIRE_RL_m_randomC_every;
  tUInt8 DEF_WILL_FIRE_RL_m_randomB_every_1;
  tUInt8 DEF_CAN_FIRE_RL_m_randomB_every_1;
  tUInt8 DEF_WILL_FIRE_RL_m_randomB_every;
  tUInt8 DEF_CAN_FIRE_RL_m_randomB_every;
  tUInt8 DEF_WILL_FIRE_RL_m_randomA_every_1;
  tUInt8 DEF_CAN_FIRE_RL_m_randomA_every_1;
  tUInt8 DEF_WILL_FIRE_RL_m_randomA_every;
  tUInt8 DEF_CAN_FIRE_RL_m_randomA_every;
  tUInt8 DEF_WILL_FIRE_RL_m_ref_fifo_post_canonicalize;
  tUInt8 DEF_CAN_FIRE_RL_m_ref_fifo_post_canonicalize;
  tUInt8 DEF_WILL_FIRE_RL_m_ref_fifo_pre_canonicalize_two;
  tUInt8 DEF_CAN_FIRE_RL_m_ref_fifo_pre_canonicalize_two;
  tUInt8 DEF_WILL_FIRE_RL_m_ref_fifo_pre_canonicalize_one;
  tUInt8 DEF_CAN_FIRE_RL_m_ref_fifo_pre_canonicalize_one;
  tUInt8 DEF_WILL_FIRE_RL_m_ref_fifo_canonicalize_4;
  tUInt8 DEF_CAN_FIRE_RL_m_ref_fifo_canonicalize_4;
  tUInt8 DEF_WILL_FIRE_RL_m_ref_fifo_canonicalize_3;
  tUInt8 DEF_CAN_FIRE_RL_m_ref_fifo_canonicalize_3;
  tUInt8 DEF_WILL_FIRE_RL_m_ref_fifo_canonicalize_2;
  tUInt8 DEF_CAN_FIRE_RL_m_ref_fifo_canonicalize_2;
  tUInt8 DEF_WILL_FIRE_RL_m_ref_fifo_canonicalize_1;
  tUInt8 DEF_CAN_FIRE_RL_m_ref_fifo_canonicalize_1;
  tUInt8 DEF_WILL_FIRE_RL_m_ref_fifo_canonicalize;
  tUInt8 DEF_CAN_FIRE_RL_m_ref_fifo_canonicalize;
  tUInt8 DEF_fifo_empty__h10550;
  tUInt8 DEF_fifo_full__h9897;
  tUInt8 DEF_m_ref_fifo_virtual_reg_1_read____d47;
  tUInt8 DEF_m_ref_fifo_virtual_reg_2_read____d46;
  tUInt32 DEF_x__h11659;
  tUInt32 DEF_x__h11806;
  tUInt32 DEF_m_ref_fifo_wires_0_wget____d6;
  tUInt32 DEF_m_ref_fifo_ehrReg___d7;
  tUInt8 DEF_x_wget__h8708;
  tUInt8 DEF_x_wget__h8332;
  tUInt8 DEF_m_ref_fifo_wires_0_1_wget____d16;
  tUInt8 DEF_m_ref_fifo_ehrReg_1___d17;
  tUInt8 DEF_m_ref_fifo_ehrReg_4__h5487;
  tUInt8 DEF_m_ref_fifo_ehrReg_3__h4658;
  tUInt8 DEF_m_ref_fifo_virtual_reg_2_1_read____d57;
  tUInt8 DEF_m_ref_fifo_virtual_reg_1_1_read____d58;
  tUInt8 DEF_m_ref_fifo_wires_0_1_whas____d15;
  tUInt8 DEF_m_ref_fifo_wires_0_whas____d5;
  tUInt8 DEF_m_ref_fifo_wires_0_wget_BIT_8___d48;
  tUInt8 DEF_m_ref_fifo_ehrReg_BIT_8___d50;
  tUInt8 DEF_m_ref_fifo_ehrReg_1_7_BIT_1___d61;
  tUInt8 DEF_m_ref_fifo_wires_0_1_wget__6_BIT_1___d59;
  tUInt8 DEF_v__h8838;
  tUInt8 DEF_v__h8462;
  tUInt8 DEF_IF_m_ref_fifo_wires_0_4_whas__7_THEN_m_ref_fif_ETC___d40;
  tUInt8 DEF_IF_m_ref_fifo_wires_0_3_whas__0_THEN_m_ref_fif_ETC___d33;
  tUInt8 DEF_m_input_count_27_EQ_1024___d185;
  tUInt8 DEF_IF_m_randomB_zaz_whas__8_THEN_m_randomB_zaz_wg_ETC___d145;
  tUInt8 DEF_IF_m_randomA_zaz_whas__1_THEN_m_randomA_zaz_wg_ETC___d117;
  tUInt8 DEF_NOT_m_ref_fifo_virtual_reg_1_4_read__48_49_AND_ETC___d150;
  tUInt8 DEF_NOT_fifo_empty_46___d147;
  tUInt8 DEF_NOT_m_ref_fifo_virtual_reg_1_3_read__20_21_AND_ETC___d122;
  tUInt8 DEF_NOT_fifo_full_18___d119;
 
 /* Local definitions */
 private:
  tUInt8 DEF_x__h9908;
  tUInt32 DEF_v__h9516;
  tUInt32 DEF_v__h9139;
  tUInt32 DEF_v__h8765;
  tUInt32 DEF_v__h8389;
  tUInt32 DEF_x__h11131;
  tUInt8 DEF_x_wget__h9459;
  tUInt8 DEF_x_wget__h3246;
  tUInt8 DEF_def__h11014;
  tUInt8 DEF__read__h226;
  tUInt8 DEF__read__h200;
  tUInt8 DEF__read__h174;
  tUInt8 DEF_x_wget__h9082;
  tUInt8 DEF_x__h10681;
  tUInt8 DEF_y__h11576;
  tUInt32 DEF_IF_m_ref_fifo_wires_0_whas_THEN_m_ref_fifo_wir_ETC___d8;
  tUInt8 DEF_x_first__h8031;
  tUInt8 DEF_def__h3734;
  tUInt8 DEF_v__h9589;
  tUInt8 DEF_v__h9212;
  tUInt8 DEF_IF_m_ref_fifo_wires_0_1_whas__5_THEN_m_ref_fif_ETC___d18;
 
 /* Rules */
 public:
  void RL_m_ref_fifo_canonicalize();
  void RL_m_ref_fifo_canonicalize_1();
  void RL_m_ref_fifo_canonicalize_2();
  void RL_m_ref_fifo_canonicalize_3();
  void RL_m_ref_fifo_canonicalize_4();
  void RL_m_ref_fifo_pre_canonicalize_one();
  void RL_m_ref_fifo_pre_canonicalize_two();
  void RL_m_ref_fifo_post_canonicalize();
  void RL_m_randomA_every();
  void RL_m_randomA_every_1();
  void RL_m_randomB_every();
  void RL_m_randomB_every_1();
  void RL_m_randomC_every();
  void RL_m_randomC_every_1();
  void RL_m_randomData_every();
  void RL_m_randomData_every_1();
  void RL_m_cycle_print();
  void RL_m_init();
  void RL_m_feed_inputs();
  void RL_m_check_outputs();
  void RL_m_maybe_clear();
  void RL_m_check_fifos_not_full();
  void RL_m_check_fifos_not_empty();
  void RL_m_check_fifos_first();
  void RL_m_stop_tb();
  void RL_m_cycle_inc();
 
 /* Methods */
 public:
 
 /* Reset routines */
 public:
  void reset_RST_N(tUInt8 ARG_rst_in);
 
 /* Static handles to reset routines */
 public:
 
 /* Pointers to reset fns in parent module for asserting output resets */
 private:
 
 /* Functions for the parent module to register its reset fns */
 public:
 
 /* Functions to set the elaborated clock id */
 public:
  void set_clk_0(char const *s);
 
 /* State dumping routine */
 public:
  void dump_state(unsigned int indent);
 
 /* VCD dumping routines */
 public:
  unsigned int dump_VCD_defs(unsigned int levels);
  void dump_VCD(tVCDDumpType dt, unsigned int levels, MOD_mkTbConflictFunctional &backing);
  void vcd_defs(tVCDDumpType dt, MOD_mkTbConflictFunctional &backing);
  void vcd_prims(tVCDDumpType dt, MOD_mkTbConflictFunctional &backing);
};

#endif /* ifndef __mkTbConflictFunctional_h__ */