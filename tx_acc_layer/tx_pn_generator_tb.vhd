-- test bench for pn_generator
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pn_generator_tb is
end pn_generator_tb;

architecture structural of pn_generator_tb is 

-- Component Declaration
component pn_generator is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        pn_start: out std_logic; 
        pn_ml1: out std_logic;
        pn_ml2: out std_logic;
        pn_gold: out std_logic
        );
    end component pn_generator;

for uut : pn_generator use entity work.pn_generator(behav);

constant period : time := 100 ns;

constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal rst:  std_logic;
signal pn_start, pn_ml1, pn_ml2, pn_gold:  std_logic;

BEGIN
    uut: pn_generator PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      pn_start => pn_start,
      pn_ml1 => pn_ml1,
      pn_ml2 => pn_ml2,
      pn_gold => pn_gold
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
    BEGIN
        -- Test normal pattern
        rst <='0';
        wait for period*100;

        -- Test reset
        rst <='1';
        wait for period*10;

        -- Test normal pattern
        rst <='0';
        wait for period*100;
                            
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;
