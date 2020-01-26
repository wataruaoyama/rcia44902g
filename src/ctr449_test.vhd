Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY ctr449_test IS
END ctr449_test;

ARCHITECTURE ctr449_test_bench OF ctr449_test IS

COMPONENT ctr449
	PORT(RESET,XDSD,DIF0,DIF1,DIF2,SMUTE,DEM0,DEM1 : IN std_logic;
			SD,SLOW,MONO,DSDSEL0,DSDSEL1,DSDF : IN std_logic;
			SSLOW,DSDD,SC0,SC1,SC2,AK4490,AK4499 : IN std_logic;
			CLK_10M : IN std_logic;
			DATA_DSDL,LRCK_DSDR,CLK_SEL,BCK_DSDCLK,LRCK0 : IN std_logic;
			CLK_22M,CLK_24M,CPOK : IN std_logic;
			PHA : IN std_logic;
			PHB : IN std_logic;
			MUTE_IN : std_logic;
			DISPSW : IN std_logic;
			CSN,CCLK,CDTI : OUT std_logic;
			MCLK,SCK,BCLK,DATA,LRCK,ENCLK_22M,ENCLK_24M : OUT std_logic;
			LED_DSD : OUT std_logic;
			LED_PCM : OUT std_logic;
			LED_96K : OUT std_logic;
			MUTE : OUT std_logic;
			LED_DSD_P : OUT std_logic;
			LED_PCM_P : OUT std_logic;
			COMSEL : OUT std_logic_vector(3 downto 0);
			LED : OUT std_logic_vector(7 downto 0));
END COMPONENT;
	
constant cycle	: Time := 100ns;
constant	half_cycle : Time := 50ns;

constant stb	: Time := 2ns;

signal reset,clk,xdsd,dem0,dem1,clk_msec :std_logic;
signal sd,slow : std_logic;
signal sslow,dsdd,sc0,sc1,sc2 : std_logic;
signal csn,cclk,cdti : std_logic;
signal data_dsdl,lrck_dsdr,clk_sel,bck_dsdclk,lrck0 : std_logic;
signal clk_22m,clk_24m,cpok,dzfr,pha,phb,mute_in : std_logic;
signal dif0,dif1,dif2,smute,mono,dsdsel0,dsdsel1,dsdf,ak4490,dispsw : std_logic;
signal ak4499,clk_10m : std_logic;

constant hires : integer := 1;

BEGIN

	U1: ctr449 port map (RESET=>reset,XDSD=>xdsd,DIF0=>dif0,DIF1=>dif1,DIF2=>dif2,SMUTE=>smute,
	DEM0=>dem0,DEM1=>dem1,SD=>sd,SLOW=>slow,MONO=>mono,DSDSEL0=>dsdsel0,DSDSEL1=>dsdsel1,
	DSDF=>dsdf,SSLOW=>sslow,DSDD=>dsdd,SC0=>sc0,SC1=>sc1,SC2=>sc2,AK4490=>ak4490,AK4499=>ak4499,
	CLK_10M=>clk_10m,
	DATA_DSDL=>data_dsdl,LRCK_DSDR=>lrck_dsdr,CLK_SEL=>clk_sel,BCK_DSDCLK=>bck_dsdclk,LRCK0=>lrck0,
	CLK_22M=>clk_22m,CLK_24M=>clk_24m,CPOK=>cpok,PHA=>pha,PHB=>phb,MUTE_IN=>mute_in,DISPSW=>dispsw);

	-- 10MHz clk
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;
	
	--20MHz clk
	process begin
		clk_22m <= '0';
		wait for half_cycle/2;
		clk_22m <= '1';
		wait for half_cycle/2;
	end process;
	
	--39.0625KHz clk
FS : if hires /= 1 generate
	process begin
		lrck0 <= '0';
		wait for half_cycle*256;
		lrck0 <= '1';
		wait for half_cycle*256;
	end process;
end generate;
	
	--156.25KHz clk
QUADRUPLE_FS : if hires = 1 generate
	process begin
		lrck0 <= '0';
		wait for half_cycle*64;
		lrck0 <= '1';
		wait for half_cycle*64;
	end process;
end generate;

--	process begin
--		clk_msec <= '0';
--		wait for cycle*5000;
--		clk_msec <= '1';
--		wait for cycle*5000;
--	end process;

	PROCESS BEGIN
		reset <= '0';
		xdsd <= '0';
		dem0 <= '1';
		dem1 <= '0';
		sd <= '1';
		slow <= '0';
		sslow <= '0';
		dsdd <= '1';
		sc0 <= '0';
		sc1 <= '1';
		sc2 <= '1';
		clk_sel <= '0';
		cpok <= '1';
		mono <= '0';
		smute <= '1';
		
		wait for cycle*10;
		wait for stb;
		reset <= '1';
		
		wait for cycle*100;
		wait for stb;
		xdsd <= '1';
		
		wait for cycle*1500;
		
		wait for cycle*100;
--		xdsd <= '0';
		
		wait for cycle*900;
--		xdsd <= '1';

		wait for cycle*300;
--		xdsd <= '0';

		wait for cycle*680;
--		xdsd <= '1';

		wait for cycle*1500;
--		xdsd <= '0';
		
		wait for cycle*1500;

		wait;
	end PROCESS;
end ctr449_test_bench;

CONFIGURATION cfg_test of ctr449_test IS
	for ctr449_test_bench
	end for;
end cfg_test;