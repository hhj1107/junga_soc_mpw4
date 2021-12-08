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

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/user_proj.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/soc.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/arbiter.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/fifo.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/rgb_led_wb.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/timer_wb.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/uart_rx.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/uart_tx.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/uart_wb.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/vexriscv.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/wb_arbiter.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/wb_interconnect.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/wb_mux.v \
        $::env(CARAVEL_ROOT)/../verilog/rtl/openlane_test/wb_ram.v"

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_PERIOD) 10

set ::env(DIE_AREA) "0 0 2800 3500"

set ::env(DIODE_INSERTION_STRATEGY) 4 

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(FP_PDN_CORE_RING) 0
set ::env(FP_PDN_CHECK_NODES) 0
set ::env(FP_SIZING) absolute

# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper) 
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.  
set ::env(GLB_RT_MAXLAYER) 5
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(GLB_RT_ADJUSTMENT) 0.30

set ::env(LEC_ENABLE) 0

set ::env(PL_TARGET_DENSITY) 0.2

set ::env(QUIT_ON_HOLD_VIOLATIONS) 0
set ::env(QUIT_ON_TIMING_VIOLATIONS) 0
set ::env(QUIT_ON_MAGIC_DRC) 1
set ::env(QUIT_ON_LVS_ERROR) 0
set ::env(QUIT_ON_SLEW_VIOLATIONS) 0
set ::env(QUIT_ON_TR_DRC) 1

set ::env(ROUTING_CORES) 8

# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1

set ::env(SYNTH_MAX_FANOUT) 4
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(USE_ARC_ANTENNA_CHECK) 0

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]
