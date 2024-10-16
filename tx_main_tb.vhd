-- test bench for main application
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity main_tb is
end main_tb;

architecture structural of main_tb is

component main is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        btn_up, btn_down: in std_logic;
        seg_display: out std_logic_vector(7 downto 0);
        dip_sw: in std_logic_vector(1 downto 0);
        sdo_spread: out std_logic
        -- test_out: out std_logic_vector(3 downto 0)--test
        );
end component main;

for uut : main use entity work.main(behav);

constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal clk, rst: std_logic;
signal btn_up, btn_down, sdo_spread: std_logic;
signal seg_display: std_logic_vector(7 downto 0);
signal dip_sw: std_logic_vector(1 downto 0);
-- signal test_out: std_logic_vector(3 downto 0); --test

BEGIN
    uut: main PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      btn_up => btn_up,
      btn_down => btn_down,
      seg_display => seg_display,
      dip_sw => dip_sw,
      sdo_spread => sdo_spread
    --   test_out => test_out --test
      );

	clock : process

    begin
        clk <= '0';
        wait for period/2;
        loop
        clk <= '0';
        wait for period/2;
        clk <= '1';
        wait for period/2;
        exit when end_of_sim;
        end loop;
        wait;
    end process clock;
	
    tb : PROCESS
    procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
        begin
        rst <= stimvect(0);
        btn_up <= stimvect(1);
        btn_down <= stimvect(2);
        -- dip_sw <= "11";
        wait for period;
    end tbvector;
    
    BEGIN
        -- reset
        tbvector("110");
        tbvector("110");
        wait for period;
        
        -- dip selection (unencrypted):
        dip_sw <= "11";
        -- start debounce btn up
        tbvector("101");
        tbvector("101");
        tbvector("111");
        tbvector("111");
        tbvector("101");
        tbvector("101");
        tbvector("111");
        tbvector("111");

        --keep high (1 up)
        tbvector("101");
        wait for period*10;
        -- no btn push
        tbvector("111");
        wait for period*10;

        --start debounce btn up
        tbvector("101");
        tbvector("101");
        tbvector("111");
        tbvector("111");
        
        --keep high (1 up)
        tbvector("101");
        wait for period*10;
        -- no btn push
        tbvector("111");
        wait for period*10;

        -- wait to verify spread?
        wait for period*1000;
        
        -- dip selection (unencrypted):
        -- dip_sw <= "01";
        -- wait for period*50;

        -- reset
        -- tbvector("110");
        -- wait for period*10;
                            
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;