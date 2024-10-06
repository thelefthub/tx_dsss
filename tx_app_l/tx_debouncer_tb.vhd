-- test bench of debouncer
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity debouncer_tb is
end debouncer_tb;

architecture structural of debouncer_tb is 

-- Component Declaration
component debouncer is
    port (
     clk, rst: in std_logic;
     btn_input: in std_logic;
     clk_enable: in std_logic;
     btn_input_sync: out std_logic
     );
 end component debouncer;

for uut : debouncer use entity work.debouncer(behav);
 
constant period : time := 100 ns;

constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal rst:  std_logic;
-- signal clk_enable:  std_logic;
signal btn_input, btn_input_sync:  std_logic;

BEGIN
    uut: debouncer PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      btn_input => btn_input,
      btn_input_sync => btn_input_sync
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
    procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
        begin
            btn_input <= stimvect(1);
        rst <= stimvect(0);

        wait for period;
    end tbvector;
    
    BEGIN
        --reset signaal 2 hoog, 2 laag
        tbvector("01");
        tbvector("01");
        tbvector("00");
        tbvector("00");

        --start debounce 0=>1
        tbvector("10");
        tbvector("10");
        tbvector("10");
        tbvector("00");
        tbvector("00");
        tbvector("10");
        tbvector("10");
        tbvector("00");

        --keep high
        tbvector("10");
        wait for period*50;

        -- start debounce to 0
        tbvector("10");
        tbvector("10");
        tbvector("10");
        tbvector("00");
        tbvector("00");
        tbvector("10");
        tbvector("00");
        tbvector("01");
        tbvector("01");
        tbvector("10");
        tbvector("00");

        --keep low
        tbvector("00");
        wait for period*50;

        -- test reset
        tbvector("01");
        tbvector("01");
        wait for period*50;
                            
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;


