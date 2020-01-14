	QD1 u0 (
		.button_pio_export           (<connected-to-button_pio_export>),           //           button_pio.export
		.clk_clk                     (<connected-to-clk_clk>),                     //                  clk.clk
		.clk_sdram_clk               (<connected-to-clk_sdram_clk>),               //            clk_sdram.clk
		.led_pio_export              (<connected-to-led_pio_export>),              //              led_pio.export
		.reset_reset_n               (<connected-to-reset_reset_n>),               //                reset.reset_n
		.sdram_wire_addr             (<connected-to-sdram_wire_addr>),             //           sdram_wire.addr
		.sdram_wire_ba               (<connected-to-sdram_wire_ba>),               //                     .ba
		.sdram_wire_cas_n            (<connected-to-sdram_wire_cas_n>),            //                     .cas_n
		.sdram_wire_cke              (<connected-to-sdram_wire_cke>),              //                     .cke
		.sdram_wire_cs_n             (<connected-to-sdram_wire_cs_n>),             //                     .cs_n
		.sdram_wire_dq               (<connected-to-sdram_wire_dq>),               //                     .dq
		.sdram_wire_dqm              (<connected-to-sdram_wire_dqm>),              //                     .dqm
		.sdram_wire_ras_n            (<connected-to-sdram_wire_ras_n>),            //                     .ras_n
		.sdram_wire_we_n             (<connected-to-sdram_wire_we_n>),             //                     .we_n
		.switch_pio_export           (<connected-to-switch_pio_export>),           //           switch_pio.export
		.the_altpll_areset_export    (<connected-to-the_altpll_areset_export>),    //    the_altpll_areset.export
		.the_altpll_locked_export    (<connected-to-the_altpll_locked_export>),    //    the_altpll_locked.export
		.the_altpll_phasedone_export (<connected-to-the_altpll_phasedone_export>)  // the_altpll_phasedone.export
	);

