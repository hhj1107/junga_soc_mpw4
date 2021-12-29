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

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    input clk_i,
    input rst_i,

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,
/*
    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,
*/
    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq,

    // SRAM
    output [3:0] o_wmask0,
    output [8:0] o_waddr0,
    output [31:0] o_din0,
    input [31:0] i_dout0,
    output o_web0,
    output o_csb0,

    // SRAM1
    output [3:0] o_wmask0_1,
    output [8:0] o_waddr0_1,
    output [31:0] o_din0_1,
    input [31:0] i_dout0_1,
    output o_web0_1,
    output o_csb0_1
);

//assign io_oeb = 0;
//assign io_out = 0;
/*
assign la_oenb = 128'b0;
assign la_data_out = 128'b0;
*/
assign irq = 3'b0;

// ser_rx;in
assign io_oeb[12] = 1'b1;

// ser_tx;out
assign io_oeb[13] = 1'b0;

// srst;in
assign io_oeb[19] = 1'b1;

// jtag_trstb;in
assign io_oeb[20] = 1'b1;

// jtag_tms;in
assign io_oeb[21] = 1'b1;

// jtag_tdo;out
assign io_oeb[22] = 1'b0;

// jtag_tdi;in
assign io_oeb[23] = 1'b1;

//  jtag_tck;in
assign io_oeb[24] = 1'b1;

// led;out
assign io_oeb[25] = 1'b0;

soc soc(
`ifdef USE_POWER_PINS
    .vccd1(vccd1),	// User area 1 1.8V power
    .vssd1(vssd1),	// User area 1 digital ground
`endif
    .clk(clk_i),
    .rst(rst_i | ~io_oeb[19]),

    .wb_clk(wb_clk_i),
    .wb_rst(wb_rst_i),

    .LED(io_out[25]),
    .MCU_UART_TX(io_out[13]),
    .MCU_UART_RX(io_in[12]),

    .jtag_trst(~io_in[20]),
    .jtag_tms(io_in[21]),
    .jtag_tdi(io_in[23]),
    .jtag_tdo(io_out[22]),
    .jtag_tck(io_in[24]),

    // User Project Slave ports (WB MI A)
    .mprj_cyc_i(wbs_cyc_i),
    .mprj_stb_i(wbs_stb_i),
    .mprj_we_i(wbs_we_i),
    .mprj_sel_i(wbs_sel_i),
    .mprj_adr_i(wbs_adr_i),
    .mprj_dat_i(wbs_dat_i),
    .mprj_ack_o(wbs_ack_o),
    .mprj_dat_o(wbs_dat_o),

    // SRAM
    .o_wmask0(o_wmask0),
    .o_waddr0(o_waddr0),
    .o_din0(o_din0),
    .i_dout0(i_dout0),
    .o_web0(o_web0),
    .o_csb0(o_csb0),

    // SRAM1
    .o_wmask0_1(o_wmask0_1),
    .o_waddr0_1(o_waddr0_1),
    .o_din0_1(o_din0_1),
    .i_dout0_1(i_dout0_1),
    .o_web0_1(o_web0_1),
    .o_csb0_1(o_csb0_1)
);

endmodule

`default_nettype wire
