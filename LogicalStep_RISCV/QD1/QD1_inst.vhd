	component QD1 is
		port (
			button_pio_export           : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			clk_clk                     : in    std_logic                     := 'X';             -- clk
			clk_sdram_clk               : out   std_logic;                                        -- clk
			led_pio_export              : out   std_logic_vector(7 downto 0);                     -- export
			reset_reset_n               : in    std_logic                     := 'X';             -- reset_n
			sdram_wire_addr             : out   std_logic_vector(11 downto 0);                    -- addr
			sdram_wire_ba               : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n            : out   std_logic;                                        -- cas_n
			sdram_wire_cke              : out   std_logic;                                        -- cke
			sdram_wire_cs_n             : out   std_logic;                                        -- cs_n
			sdram_wire_dq               : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm              : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n            : out   std_logic;                                        -- ras_n
			sdram_wire_we_n             : out   std_logic;                                        -- we_n
			switch_pio_export           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			the_altpll_areset_export    : in    std_logic                     := 'X';             -- export
			the_altpll_locked_export    : out   std_logic;                                        -- export
			the_altpll_phasedone_export : out   std_logic                                         -- export
		);
	end component QD1;

	u0 : component QD1
		port map (
			button_pio_export           => CONNECTED_TO_button_pio_export,           --           button_pio.export
			clk_clk                     => CONNECTED_TO_clk_clk,                     --                  clk.clk
			clk_sdram_clk               => CONNECTED_TO_clk_sdram_clk,               --            clk_sdram.clk
			led_pio_export              => CONNECTED_TO_led_pio_export,              --              led_pio.export
			reset_reset_n               => CONNECTED_TO_reset_reset_n,               --                reset.reset_n
			sdram_wire_addr             => CONNECTED_TO_sdram_wire_addr,             --           sdram_wire.addr
			sdram_wire_ba               => CONNECTED_TO_sdram_wire_ba,               --                     .ba
			sdram_wire_cas_n            => CONNECTED_TO_sdram_wire_cas_n,            --                     .cas_n
			sdram_wire_cke              => CONNECTED_TO_sdram_wire_cke,              --                     .cke
			sdram_wire_cs_n             => CONNECTED_TO_sdram_wire_cs_n,             --                     .cs_n
			sdram_wire_dq               => CONNECTED_TO_sdram_wire_dq,               --                     .dq
			sdram_wire_dqm              => CONNECTED_TO_sdram_wire_dqm,              --                     .dqm
			sdram_wire_ras_n            => CONNECTED_TO_sdram_wire_ras_n,            --                     .ras_n
			sdram_wire_we_n             => CONNECTED_TO_sdram_wire_we_n,             --                     .we_n
			switch_pio_export           => CONNECTED_TO_switch_pio_export,           --           switch_pio.export
			the_altpll_areset_export    => CONNECTED_TO_the_altpll_areset_export,    --    the_altpll_areset.export
			the_altpll_locked_export    => CONNECTED_TO_the_altpll_locked_export,    --    the_altpll_locked.export
			the_altpll_phasedone_export => CONNECTED_TO_the_altpll_phasedone_export  -- the_altpll_phasedone.export
		);

