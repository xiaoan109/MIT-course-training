/*
 * Generated by Bluespec Compiler, version 2023.01 (build 52adafa5)
 * 
 * On Thu Sep 26 04:27:20 UTC 2024
 * 
 */

/* Generation options: keep-fires */
#ifndef __model_mkTbConflictFunctional_h__
#define __model_mkTbConflictFunctional_h__

#include "bluesim_types.h"
#include "bs_module.h"
#include "bluesim_primitives.h"
#include "bs_vcd.h"

#include "bs_model.h"
#include "mkTbConflictFunctional.h"

/* Class declaration for a model of mkTbConflictFunctional */
class MODEL_mkTbConflictFunctional : public Model {
 
 /* Top-level module instance */
 private:
  MOD_mkTbConflictFunctional *mkTbConflictFunctional_instance;
 
 /* Handle to the simulation kernel */
 private:
  tSimStateHdl sim_hdl;
 
 /* Constructor */
 public:
  MODEL_mkTbConflictFunctional();
 
 /* Functions required by the kernel */
 public:
  void create_model(tSimStateHdl simHdl, bool master);
  void destroy_model();
  void reset_model(bool asserted);
  void get_version(char const **name, char const **build);
  time_t get_creation_time();
  void * get_instance();
  void dump_state();
  void dump_VCD_defs();
  void dump_VCD(tVCDDumpType dt);
};

/* Function for creating a new model */
extern "C" {
  void * new_MODEL_mkTbConflictFunctional();
}

#endif /* ifndef __model_mkTbConflictFunctional_h__ */
