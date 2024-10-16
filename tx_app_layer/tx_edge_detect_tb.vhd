library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity edge_detector_tb is
end edge_detector_tb;

architecture structural of edge_detector_tb is

-- Component Declaration
component edge_detector is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        db_input: in std_logic;
        pos_edge: out std_logic
        );
    end component edge_detector;

for uut : edge_detector use entity work.edge_detector(behav);

constant period : time := 100 ns;
-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal db_input, pos_edge:  std_logic;

BEGIN
    uut: edge_detector PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      db_input => db_input,
      pos_edge => pos_edge
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
        db_input <= stimvect(1);
        

        wait for period;
    end tbvector;
    
    BEGIN
        --reset 2H, 2L
        tbvector("01");
        tbvector("01");
        tbvector("00");
        tbvector("00");

        --input high
        tbvector("10");
        wait for period*10;

        --input low
        tbvector("00");
        wait for period*10;

        --single reset low
        tbvector("01");
        wait for period;

        --input high
        tbvector("10");
        wait for period*10;


        end_of_sim <= true;
        wait;
    END PROCESS;

  END;
  
