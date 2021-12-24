# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_proj
set ::env(DESIGN_IS_CORE) 0

######################################################
# User Configurations

#puts $TARGET_PATH

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/src/user_proj.v \
        $script_dir/src/soc.v \
        $script_dir/src/vexriscv.v \
        $script_dir/src/arbiter.v \
        $script_dir/src/fifo.v \
        $script_dir/src/wb_arbiter.v \
        $script_dir/src/wb_mux.v \
        $script_dir/src/wb_interconnect.v \
        $script_dir/src/simpleuart.v \
        $script_dir/src/wb_openram_wrapper.v \
        $script_dir/src/wb_led.v \
        $script_dir/src/timer_wb.v"

#set ::env(VERILOG_INCLUDE_DIRS) [glob $script_dir/../../verilog/rtl/includes]

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_PERIOD) 20

set ::env(DIE_AREA) "0 0 1000 1000"
#set ::env(DIE_AREA) "0 0 2800 3500"
#set ::env(DIE_AREA) "80 80 2840 3440"

set ::env(DIODE_INSERTION_STRATEGY) 4 

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
#set ::env(FP_SIZING) relative
set ::env(FP_CORE_UTIL) 35
#set ::env(FP_ASPECT_RATIO) 1
#set ::env(FP_IO_VEXTEND) 4
#set ::env(FP_IO_HEXTEND) 4
#set ::env(FP_PDN_CHECK_NODES) 0
set ::env(FP_PDN_CORE_RING) 0
set ::env(FP_PDN_IRDROP) 0
#set ::env(FP_PDN_VPITCH) 180
#set ::env(FP_PDN_HPITCH) $::env(FP_PDN_VPITCH)
#set ::env(FP_PDN_VOFFSET) 0
#set ::env(FP_PDN_HOFFSET) $::env(FP_PDN_VOFFSET)
#set ::env(FP_PDN_VWIDTH) 3
#set ::env(FP_PDN_HWIDTH) $::env(FP_PDN_VWIDTH)

set ::env(GLB_RT_MAXLAYER) 5
set ::env(GLB_RT_ADJUSTMENT) 0.3
set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 10
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 0

#set ::env(LEC_ENABLE) 0

#set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]
set ::env(PL_TIME_DRIVEN) 1
#set ::env(PL_ROUTABILITY_DRIVEN) 1
#set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
#set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0

set ::env(QUIT_ON_HOLD_VIOLATIONS) 0
set ::env(QUIT_ON_TIMING_VIOLATIONS) 0
#set ::env(QUIT_ON_MAGIC_DRC) 0
set ::env(QUIT_ON_LVS_ERROR) 0
set ::env(QUIT_ON_SLEW_VIOLATIONS) 0
#set ::env(QUIT_ON_TR_DRC) 0

set ::env(ROUTING_CORES) 8
#set ::env(ROUTING_OPT_ITERS) 64

set ::env(RT_MAX_LAYER) "met4"

# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1
set ::env(RUN_KLAYOUT_DRC) 0
set ::env(RUN_MAGIC_DRC) 0

set ::env(SYNTH_MAX_FANOUT) 4
#set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"
set ::env(SYNTH_DRIVING_CELL) "sky130_fd_sc_hd__inv_8"
#set ::env(SYNTH_READ_BLACKBOX_LIB) 1

#set ::env(USE_ARC_ANTENNA_CHECK) 0

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]
#set ::env(VDD_PINS) [list {vccd1}]
#set ::env(GND_PINS) [list {vssd1}]
