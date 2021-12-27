`default_nettype none

`ifndef CLOCK_HZ
`define CLOCK_HZ 100_000_000
`endif

module soc(
`ifdef USE_POWER_PINS
  inout vccd1,	// User area 1 1.8V supply
  inout vssd1,	// User area 1 digital ground
`endif
  input clk_i,
  input rst_i,

  output LED,
  input MCU_UART_TX,
  output MCU_UART_RX,

  input jtag_trst,
  input jtag_tms,
  input jtag_tdi,
  output jtag_tdo,
  input jtag_tck,

  input mprj_ack_i,
	input [31:0] mprj_dat_i,
  output mprj_cyc_o,
	output mprj_stb_o,
	output mprj_we_o,
	output [3:0] mprj_sel_o,
	output [31:0] mprj_adr_o,
	output [31:0] mprj_dat_o,

  output [3:0] o_wmask0,
  output [8:0] o_waddr0,
  output [31:0] o_din0,
  input [31:0] i_dout0,
  output o_web0,
  output o_csb0,
  output [8:0] o_addr1,
  input [31:0] i_dout1,
  output o_csb1,

  output [3:0] o_wmask0_1,
  output [8:0] o_waddr0_1,
  output [31:0] o_din0_1,
  input [31:0] i_dout0_1,
  output o_web0_1,
  output o_csb0_1,
  output [8:0] o_addr1_1,
  input [31:0] i_dout1_1,
  output o_csb1_1
);

`include "wb_interconnect.vh"
parameter ROM_BASE_ADDRESS =    32'h3000_0000;
parameter RAM_BASE_ADDRESS =    32'h3000_1000;
parameter TIMER_BASE_ADDRESS =  32'h3fff_ff00;
parameter UART_BASE_ADR =       32'h3fff_fe00;
parameter LED_BASE_ADR =        32'h3fff_fd00;

assign mprj_adr_o = wb_m2s_mgmt_adr;
assign mprj_dat_o = wb_m2s_mgmt_dat;
assign mprj_sel_o = wb_m2s_mgmt_sel;
assign mprj_we_o = wb_m2s_mgmt_we;
assign mprj_cyc_o = wb_m2s_mgmt_cyc;
assign mprj_stb_o = wb_m2s_mgmt_stb;
assign wb_s2m_mgmt_dat = mprj_dat_i;
assign wb_s2m_mgmt_ack = mprj_ack_i;

wire wb_rst = rst_i;
wire wb_clk = clk_i;

`ifdef USE_MEMRAM
wb_ram cpu0_ram (
`ifdef USE_POWER_PINS
  .vccd1(vccd1),	// User area 1 1.8V power
  .vssd1(vssd1),	// User area 1 digital ground
`endif
  .i_clk(wb_clk),
  .i_reset(wb_rst),
  .i_wb_adr(wb_m2s_cpu0_ram_adr),
  .i_wb_dat(wb_m2s_cpu0_ram_dat),
  .i_wb_sel(wb_m2s_cpu0_ram_sel),
  .i_wb_we (wb_m2s_cpu0_ram_we),
  .i_wb_cyc(wb_m2s_cpu0_ram_cyc),
  .i_wb_stb(wb_m2s_cpu0_ram_stb),
  .o_wb_dat(wb_s2m_cpu0_ram_dat),
  .o_wb_ack(wb_s2m_cpu0_ram_ack)
);
wb_ram #(
`ifdef CODE_IN_ROM
  .INITIAL_HEX("firmware/ice40_soc_fw.hex")
`endif
) cpu0_rom (
`ifdef USE_POWER_PINS
  .vccd1(vccd1),	// User area 1 1.8V power
  .vssd1(vssd1),	// User area 1 digital ground
`endif
  .i_clk(wb_clk),
  .i_reset(wb_rst),
  .i_wb_adr(wb_m2s_cpu0_rom_adr),
  .i_wb_dat(wb_m2s_cpu0_rom_dat),
  .i_wb_sel(wb_m2s_cpu0_rom_sel),
  .i_wb_we (wb_m2s_cpu0_rom_we),
  .i_wb_cyc(wb_m2s_cpu0_rom_cyc),
  .i_wb_stb(wb_m2s_cpu0_rom_stb),
  .o_wb_dat(wb_s2m_cpu0_rom_dat),
  .o_wb_ack(wb_s2m_cpu0_rom_ack)
);
`else //USE_MEMRAM
wb_openram_wrapper #(
  .BASE_ADDR(RAM_BASE_ADDRESS),
  .ADDR_WIDTH(9) //log2(512)
) wb_openram0 (
`ifdef USE_POWER_PINS
  .vccd1(vccd1),	// User area 1 1.8V power
  .vssd1(vssd1),	// User area 1 digital ground
`endif
  .wb_clk_i(wb_clk),
  .wb_rst_i(wb_rst),
  .wbs_adr_i(wb_m2s_cpu0_ram_adr),
  .wbs_dat_i(wb_m2s_cpu0_ram_dat),
  .wbs_sel_i(wb_m2s_cpu0_ram_sel),
  .wbs_we_i(wb_m2s_cpu0_ram_we),
  .wbs_cyc_i(wb_m2s_cpu0_ram_cyc),
  .wbs_stb_i(wb_m2s_cpu0_ram_stb),
  .wbs_dat_o(wb_s2m_cpu0_ram_dat),
  .wbs_ack_o(wb_s2m_cpu0_ram_ack),
  .ram_clk0(wb_clk),
  .ram_csb0(o_csb0),
  .ram_web0(o_web0),
  .ram_wmask0(o_wmask0),
  .ram_addr0(o_waddr0),
  .ram_din0(o_din0),
  .ram_dout0(i_dout0),
  .ram_clk1(wb_clk),
  .ram_csb1(o_csb1),
  .ram_addr1(o_addr1),
  .ram_dout1(i_dout1)
);
wb_openram_wrapper #(
  .BASE_ADDR(ROM_BASE_ADDRESS),
  .ADDR_WIDTH(9) //log2(512)
) wb_openram1 (
`ifdef USE_POWER_PINS
  .vccd1(vccd1),	// User area 1 1.8V power
  .vssd1(vssd1),	// User area 1 digital ground
`endif
  .wb_clk_i(wb_clk),
  .wb_rst_i(wb_rst),
  .wbs_adr_i(wb_m2s_cpu0_rom_adr),
  .wbs_dat_i(wb_m2s_cpu0_rom_dat),
  .wbs_sel_i(wb_m2s_cpu0_rom_sel),
  .wbs_we_i(wb_m2s_cpu0_rom_we),
  .wbs_cyc_i(wb_m2s_cpu0_rom_cyc),
  .wbs_stb_i(wb_m2s_cpu0_rom_stb),
  .wbs_dat_o(wb_s2m_cpu0_rom_dat),
  .wbs_ack_o(wb_s2m_cpu0_rom_ack),
  .ram_clk0(wb_clk),
  .ram_csb0(o_csb0_1),
  .ram_web0(o_web0_1),
  .ram_wmask0(o_wmask0_1),
  .ram_addr0(o_waddr0_1),
  .ram_din0(o_din0_1),
  .ram_dout0(i_dout0_1),
  .ram_clk1(wb_clk),
  .ram_csb1(o_csb1_1),
  .ram_addr1(o_addr1_1),
  .ram_dout1(i_dout1_1)
);
`endif //USE_MEMRAM

// Timer for generating the timer interrupt
wire timer_interrupt;
timer_wb #(
  .DEFAULT_PRESCALER(`CLOCK_HZ / 1000 - 1)
) timer0 (
`ifdef USE_POWER_PINS
  .vccd1(vccd1),	// User area 1 1.8V power
  .vssd1(vssd1),	// User area 1 digital ground
`endif
  .i_clk(wb_clk),
  .i_reset(wb_rst),
  .o_timer_trigger(timer_interrupt),
  .i_wb_adr(wb_m2s_timer0_adr),
  .i_wb_dat(wb_m2s_timer0_dat),
  .i_wb_sel(wb_m2s_timer0_sel),
  .i_wb_we (wb_m2s_timer0_we),
  .i_wb_cyc(wb_m2s_timer0_cyc),
  .i_wb_stb(wb_m2s_timer0_stb),
  .o_wb_dat(wb_s2m_timer0_dat),
  .o_wb_ack(wb_s2m_timer0_ack)
);

// Uart for console logging
`ifndef USE_OBSOLETE_UART
simpleuartA_wb #(
  .BASE_ADR(UART_BASE_ADR)
) simpleuartA0 (
  .wb_clk_i(wb_clk),
  .wb_rst_i(wb_rst),
  .wb_adr_i(wb_m2s_uart0_adr),      
  .wb_dat_i(wb_m2s_uart0_dat),
  .wb_sel_i(wb_m2s_uart0_sel),
  .wb_we_i(wb_m2s_uart0_we),
  .wb_cyc_i(wb_m2s_uart0_cyc),
  .wb_stb_i(wb_m2s_uart0_stb),
  .wb_ack_o(wb_s2m_uart0_ack),
  .wb_dat_o(wb_s2m_uart0_dat),

  .ser_tx(MCU_UART_RX),
  .ser_rx(MCU_UART_TX)
);
`else
uart_wb #(
  .TX_BUFSIZE(32),
  .RX_BUFSIZE(32),
  .DATA_WIDTH(8)
) uart0 (
`ifdef USE_POWER_PINS
  .vccd1(vccd1),	// User area 1 1.8V power
  .vssd1(vssd1),	// User area 1 digital ground
`endif
  .i_clk(wb_clk),
  .i_reset(wb_rst),
  .i_uart_rx(MCU_UART_TX),
  .o_uart_tx(MCU_UART_RX),
  .i_wb_adr(wb_m2s_uart0_adr),
  .i_wb_dat(wb_m2s_uart0_dat),
  .i_wb_sel(wb_m2s_uart0_sel),
  .i_wb_we (wb_m2s_uart0_we),
  .i_wb_cyc(wb_m2s_uart0_cyc),
  .i_wb_stb(wb_m2s_uart0_stb),
  .o_wb_dat(wb_s2m_uart0_dat),
  .o_wb_ack(wb_s2m_uart0_ack)
);
`endif

// LED
wb_led led (
`ifdef USE_POWER_PINS
  .vccd1(vccd1),	// User area 1 1.8V power
  .vssd1(vssd1),	// User area 1 digital ground
`endif
  .i_clk(wb_clk),
  .i_reset(wb_rst),
  .o_led(LED),
  .i_wb_adr(wb_m2s_led0_adr),
  .i_wb_dat(wb_m2s_led0_dat),
  .i_wb_sel(wb_m2s_led0_sel),
  .i_wb_we (wb_m2s_led0_we),
  .i_wb_cyc(wb_m2s_led0_cyc),
  .i_wb_stb(wb_m2s_led0_stb),
  .o_wb_dat(wb_s2m_led0_dat),
  .o_wb_ack(wb_s2m_led0_ack)
);

/*
# CPU
cd riscv/SpinalHDL
sbt clean
sbt compile
sbt tasks
sbt publishLocal
cd riscv/VexRiscv
sbt "show discoveredMainClasses"
sbt "runMain vexriscv.demo.GenVexRiscv"
sbt "runMain vexriscv.demo.GenRB"
*/

VexRiscv cpu0 (
/*
`ifdef USE_POWER_PINS
  .vccd1(vccd1),	// User area 1 1.8V power
  .vssd1(vssd1),	// User area 1 digital ground
`endif
*/
  .clk(wb_clk),
  .reset(wb_rst),

  .timerInterrupt(timer_interrupt),
  .externalInterrupt(1'b0),
  .softwareInterrupt(1'b0),

  .iBusWishbone_CYC(wb_m2s_cpu0_ibus_cyc),
  .iBusWishbone_STB(wb_m2s_cpu0_ibus_stb),
  .iBusWishbone_ACK(wb_s2m_cpu0_ibus_ack),
  .iBusWishbone_WE(wb_m2s_cpu0_ibus_we),
  .iBusWishbone_ADR(wb_m2s_cpu0_ibus_adr[31:2]), // Low 2 bits are always zero
  .iBusWishbone_DAT_MISO(wb_s2m_cpu0_ibus_dat),
  .iBusWishbone_DAT_MOSI(wb_m2s_cpu0_ibus_dat),
  .iBusWishbone_SEL(wb_m2s_cpu0_ibus_sel),
  .iBusWishbone_ERR(wb_s2m_cpu0_ibus_err),
  .iBusWishbone_BTE(wb_m2s_cpu0_ibus_bte),
  .iBusWishbone_CTI(wb_m2s_cpu0_ibus_cti),

  .dBusWishbone_CYC(wb_m2s_cpu0_dbus_cyc),
  .dBusWishbone_STB(wb_m2s_cpu0_dbus_stb),
  .dBusWishbone_ACK(wb_s2m_cpu0_dbus_ack),
  .dBusWishbone_WE(wb_m2s_cpu0_dbus_we),
  .dBusWishbone_ADR(wb_m2s_cpu0_dbus_adr[31:2]), // Low 2 bits are always zero
  .dBusWishbone_DAT_MISO(wb_s2m_cpu0_dbus_dat),
  .dBusWishbone_DAT_MOSI(wb_m2s_cpu0_dbus_dat),
  .dBusWishbone_SEL(wb_m2s_cpu0_dbus_sel),
  .dBusWishbone_ERR(wb_s2m_cpu0_dbus_err),
  .dBusWishbone_BTE(wb_m2s_cpu0_dbus_bte),
  .dBusWishbone_CTI(wb_m2s_cpu0_dbus_cti),

  .jtag_rst(jtag_trst),
  .jtag_tms(jtag_tms),
  .jtag_tdi(jtag_tdi),
  .jtag_tdo(jtag_tdo),
  .jtag_tck(jtag_tck)
);

endmodule
