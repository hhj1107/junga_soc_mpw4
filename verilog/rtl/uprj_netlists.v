// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

// Include caravel global defines for the number of the user project IO pads 
`include "defines.v"
`define USE_POWER_PINS

`ifdef GL
    // Assume default net type to be wire because GL netlists don't have the wire definitions
    `default_nettype wire
    `include "gl/user_project_wrapper.v"
    `include "gl/user_proj.v"
    `include "../../../openlane/user_project_wrapper/src/sky130_sram_2kbyte_1rw1r_32x512_8.v"
`else
    `include "../../../openlane/user_project_wrapper/src/user_project_wrapper.v"
    `include "../../../openlane/user_project_wrapper/src/sky130_sram_2kbyte_1rw1r_32x512_8.v"
    `include "../../../openlane/user_proj/src/user_proj.v"
    `include "../../../openlane/user_proj/src/soc.v"
    `include "../../../openlane/user_proj/src/vexriscv.v"
    `include "../../../openlane/user_proj/src/arbiter.v"
    `include "../../../openlane/user_proj/src/fifo.v"
    `include "../../../openlane/user_proj/src/wb_arbiter.v"
    `include "../../../openlane/user_proj/src/wb_mux.v"
    `include "../../../openlane/user_proj/src/wb_interconnect.v"
    `include "../../../openlane/user_proj/src/wb_openram_wrapper.v"
    `include "../../../openlane/user_proj/src/wb_led.v"
    `include "../../../openlane/user_proj/src/timer_wb.v"
    `include "../../../openlane/user_proj/src/simpleuart.v"
`endif
