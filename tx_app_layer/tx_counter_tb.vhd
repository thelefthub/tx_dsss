-- test bench for counter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter_tb is
end counter_tb;

architecture structural of counter_tb is 

-- Component Declaration
component counter is
    port (
        clk, rst: in std_logic;
        up, down: in std_logic;
        clk_enable: in std_logic;
        count_out: out std_logic_vector(3 downto 0)
     );
 end component counter;

for uut : counter use entity work.counter(behav);
 
constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
-- signal clk_enable:  std_logic;
signal up, down:  std_logic;
signal count_out: std_logic_vector(3 downto 0);

BEGIN
    uut: counter PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      up => up,
      down => down,
      count_out => count_out
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
        up <= stimvect(1);
        down <= stimvect(2);
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset 2H, 2L
        tbvector("001");
        tbvector("001");
        tbvector("000");
        tbvector("000");

        --start count: 0-5-0
        tbvector("010");
        tbvector("010");
        tbvector("010");
        tbvector("010");
        tbvector("010");
        tbvector("100");
        tbvector("100");
        tbvector("100");
        tbvector("100");
        tbvector("100");
        
        -- test reset
        tbvector("010");
        tbvector("010");
        tbvector("001");
                            
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;


