`default_nettype none

module wb_led(
`ifdef USE_POWER_PINS
  inout vccd1,	// User area 1 1.8V supply
  inout vssd1,	// User area 1 digital ground
`endif
    // RCC
    input wire i_clk,
    input wire i_reset,
    // Output
    output reg o_led,
    // Wishbone
    input  wire [31:0] i_wb_adr,
    input  wire [31:0] i_wb_dat,
    input  wire  [3:0] i_wb_sel,
    input  wire        i_wb_we,
    input  wire        i_wb_cyc,
    input  wire        i_wb_stb,
    output reg  [31:0] o_wb_dat,
    output reg         o_wb_ack
);

// Wishbone register addresses
localparam
    wb_r_DATA  = 1'b0,
    wb_r_SHIFT = 1'b1,
    wb_r_MAX   = 1'b1;

// register
reg [31:0] data;
reg [5:0] shift;

// output generation
always @(posedge i_clk) begin
    o_led <= data[shift];
end

// Since the incoming wishbone address from the CPU increments by 4 bytes, we
// need to right shift it by 2 to get our actual register index
localparam reg_sel_bits = $clog2(wb_r_MAX + 1);
wire [reg_sel_bits-1:0] register_index = i_wb_adr[reg_sel_bits+1:2];

always @(posedge i_clk) begin
    if (i_reset) begin
        o_wb_ack <= 0;
        data <= 0;
        shift <= 0;
    end else begin
        // Wishbone interface logic
        o_wb_ack <= 1'b0;
        if (i_wb_cyc && i_wb_stb && !o_wb_ack) begin
            o_wb_ack <= 1'b1;

            // Register read
            case (register_index)
                wb_r_DATA: o_wb_dat <= data;
                wb_r_SHIFT:o_wb_dat <= shift;
            endcase

            // Register write
            if (i_wb_we) begin
                case (register_index)
                    wb_r_DATA: data <= i_wb_dat;
                    wb_r_SHIFT: shift <= i_wb_dat;
                endcase
            end
        end
    end
end

endmodule
