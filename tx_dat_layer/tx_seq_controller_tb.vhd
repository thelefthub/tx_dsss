-- test bench for seven segment display
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity seq_controller_tb is
end seq_controller_tb;

architecture structural of seq_controller_tb is

component seq_controller is
    port (
        clk, rst: in std_logic;
        ld, sh: out std_logic;
        clk_enable: in std_logic;
        -- count_test: out std_logic_vector(3 downto 0); --test
        pn_start: in std_logic
        );
end component seq_controller;

for uut : seq_controller use entity work.seq_controller(behav);

constant period : time := 100 ns;
-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal ld, sh:  std_logic;
signal pn_start:  std_logic;
-- signal count_test: std_logic_vector(3 downto 0); --test

BEGIN
    uut: seq_controller PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      pn_start => pn_start,
      ld => ld,
    --   count_test => count_test, --test
      sh => sh
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
        rst <= stimvect(0);
        pn_start <= stimvect(1);
                
        wait for period;
    end tbvector;
    
    BEGIN
        --reset 2H, 2L
        tbvector("01");
        tbvector("01");
        tbvector("00");
        tbvector("00");

        -- normal sequence
        for i in 0 to 50 loop
            tbvector("10");
            for i in 0 to 30 loop
                tbvector("00");
            end loop;
        end loop;
        
        -- broken sequence (test reset)
        tbvector("10");
        for i in 0 to 5 loop
            tbvector("00");
        end loop;
        tbvector("01");
        tbvector("10");
        for i in 0 to 9 loop
            tbvector("00");
        end loop;
                            
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;
