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

module wb_openram_wrapper1
#(
    parameter BASE_ADDR = 32'h3000_0000,
    parameter ADDR_WIDTH = 9
)
(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    input             wb_clk_i,
    input             wb_rst_i,
    input             wbs_stb_i,
    input             wbs_cyc_i,
    input             wbs_we_i,
    input   [3:0]     wbs_sel_i,
    input   [31:0]    wbs_dat_i,
    input   [31:0]    wbs_adr_i,
    output reg        wbs_ack_o,
    output reg [31:0] wbs_dat_o,

    // OpenRAM interface - RW
    output                      ram_csb0,
    output                      ram_web0,
    output  [3:0]              	ram_wmask0,
    output  [ADDR_WIDTH-1:0]    ram_addr0,
    input   [31:0]              ram_dout0,
    output reg [31:0]           ram_din0
);

always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
        wbs_ack_o <= 1'b0;
    end else begin
        wbs_ack_o <= 1'b0;
        if (wbs_cyc_i & wbs_stb_i & ~wbs_ack_o) begin
            wbs_ack_o <= 1'b1;
            wbs_dat_o <= ram_dout0;
            if (wbs_we_i) begin
                ram_din0 <= wbs_dat_i;
            end
        end
    end
end

assign ram_csb0 = ~wbs_stb_i;
assign ram_web0 = ~wbs_we_i;
assign ram_wmask0 = wbs_sel_i;
assign ram_addr0 = wbs_adr_i[ADDR_WIDTH-1:0];

endmodule	// wb_openram_wrapper

module wb_openram_wrapper
#(
    parameter BASE_ADDR = 32'h3000_0000,
    parameter ADDR_WIDTH = 9
)
(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    input wb_clk_i,
    input wb_rst_i,

    input [31:0] wbs_adr_i,
    input [31:0] wbs_dat_i,
    input [3:0] wbs_sel_i,
    input wbs_we_i,
    input wbs_cyc_i,
    input wbs_stb_i,

    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // OpenRAM interface - RW
    output                      ram_csb0,
    output                      ram_web0,
    output  [3:0]              	ram_wmask0,
    output  [ADDR_WIDTH-1:0]    ram_addr0,
    input   [31:0]              ram_dout0,
    output  [31:0]              ram_din0
);

    wire valid;
    wire ram_wen;
    wire [3:0] wen; // write enable

    assign valid = wbs_cyc_i & wbs_stb_i;
    assign ram_wen = wbs_we_i && valid;

    assign wen = wbs_sel_i & {4{ram_wen}} ;

    /*
        Ack Generation
            - write transaction: asserted upon receiving adr_i & dat_i 
            - read transaction : asserted one clock cycle after receiving the adr_i & dat_i
    */

    reg wb_ack_read;
    reg wbs_ack_o;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i == 1'b 1) begin
            wb_ack_read <= 1'b0;
            wbs_ack_o <= 1'b0;
        end else begin
            wb_ack_read <= (valid & !wbs_ack_o) & !wb_ack_read;
            wbs_ack_o    <= wbs_we_i? (valid & !wbs_ack_o): wb_ack_read;
        end
    end

    assign ram_csb0 = ~valid;
    assign ram_web0 = ~|wen;
    assign ram_wmask0 = wen;
    assign ram_addr0 = wbs_adr_i[ADDR_WIDTH-1:0];
    assign wbs_dat_o = ram_dout0;
    assign ram_din0 = wbs_dat_i;

endmodule	// wb_openram_wrapper

`default_nettype wire
