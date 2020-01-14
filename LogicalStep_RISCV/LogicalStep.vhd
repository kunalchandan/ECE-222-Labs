library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;



entity LogicalStep is
  port(
    clkin_50 : in std_logic;
	 rst_n 	 : in std_logic;
	 sw       : in std_logic_vector(7 downto 0);
	 pb       : in std_logic_vector(3 downto 0);
	 leds     : out std_logic_vector(7 downto 0);

    sdram_a  : out   std_logic_vector(11 downto 0);
    sdram_ba    : out   std_logic_vector(1 downto 0);
    sdram_cas_n : out   std_logic;
    sdram_cke   : out   std_logic;
    sdram_clk   : out   std_logic;
    sdram_cs_n  : out   std_logic;
    sdram_dq    : inout std_logic_vector(15 downto 0);
    sdram_dqm   : out   std_logic_vector(1 downto 0);
    sdram_ras_n : out   std_logic;
    sdram_we_n  : out   std_logic;
	 
	 seg7_char1  : out   std_logic;
	 seg7_char2  : out   std_logic
	 
    );
end entity LogicalStep;

architecture rtl of LogicalStep is
	component QD1 is
		port (
			button_pio_export           : in    std_logic_vector(3 downto 0)  := (others => '0'); --           button_pio.export
			clk_clk                     : in    std_logic                     := '0';             --                  clk.clk
			clk_sdram_clk               : out   std_logic;                                        --            clk_sdram.clk
			led_pio_export              : out   std_logic_vector(7 downto 0);                     --              led_pio.export
			reset_reset_n               : in    std_logic                     := '0';             --                reset.reset_n
			sdram_wire_addr             : out   std_logic_vector(11 downto 0);                    --           sdram_wire.addr
			sdram_wire_ba               : out   std_logic_vector(1 downto 0);                     --                     .ba
			sdram_wire_cas_n            : out   std_logic;                                        --                     .cas_n
			sdram_wire_cke              : out   std_logic;                                        --                     .cke
			sdram_wire_cs_n             : out   std_logic;                                        --                     .cs_n
			sdram_wire_dq               : inout std_logic_vector(15 downto 0) := (others => '0'); --                     .dq
			sdram_wire_dqm              : out   std_logic_vector(1 downto 0);                     --                     .dqm
			sdram_wire_ras_n            : out   std_logic;                                        --                     .ras_n
			sdram_wire_we_n             : out   std_logic;                                        --                     .we_n
			switch_pio_export           : in    std_logic_vector(7 downto 0)  := (others => '0'); --           switch_pio.export
			the_altpll_areset_export    : in    std_logic                     := '0';             --    the_altpll_areset.export
			the_altpll_locked_export    : out   std_logic;                                        --    the_altpll_locked.export
			the_altpll_phasedone_export : out   std_logic                                         -- the_altpll_phasedone.export
		);
	end component QD1;

  
  signal rst         : std_logic;


begin
  rst  <= not rst_n;
  
  rv : component QD1
    port map (
      clk_clk                  => clkin_50,
      reset_reset_n            => rst_n,  	--rst_n
      the_altpll_areset_export => rst,			--rst
      sdram_wire_addr          => sdram_a,
      sdram_wire_ba            => sdram_ba,
      sdram_wire_cas_n         => sdram_cas_n,
      sdram_wire_cke           => sdram_cke,
      sdram_wire_cs_n          => sdram_cs_n,
      sdram_wire_dq            => sdram_dq,
      sdram_wire_dqm           => sdram_dqm,
      sdram_wire_ras_n         => sdram_ras_n,
      sdram_wire_we_n          => sdram_we_n,
      clk_sdram_clk            => sdram_clk,
		button_pio_export        => pb,
		led_pio_export        	 => leds,
		switch_pio_export        => sw
      );
	
	
	seg7_char1 <= '0';
	seg7_char2 <= '0';
	
	
end;
