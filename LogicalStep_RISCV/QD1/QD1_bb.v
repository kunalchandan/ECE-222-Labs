
module QD1 (
	button_pio_export,
	clk_clk,
	clk_sdram_clk,
	led_pio_export,
	reset_reset_n,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	switch_pio_export,
	the_altpll_areset_export,
	the_altpll_locked_export,
	the_altpll_phasedone_export);	

	input	[3:0]	button_pio_export;
	input		clk_clk;
	output		clk_sdram_clk;
	output	[7:0]	led_pio_export;
	input		reset_reset_n;
	output	[11:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input	[7:0]	switch_pio_export;
	input		the_altpll_areset_export;
	output		the_altpll_locked_export;
	output		the_altpll_phasedone_export;
endmodule
