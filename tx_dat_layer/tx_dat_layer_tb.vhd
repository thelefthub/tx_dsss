-- test bench for data layer
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_layer_tb is
end data_layer_tb;

architecture structural of data_layer_tb is
    
component data_layer is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     pn_start: in std_logic;
     data: in std_logic_vector(3 downto 0);
     sdo_posenc: out std_logic
     );
end component data_layer;

for uut : data_layer use entity work.data_layer(behav);

constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
-- signal clk_enable:  std_logic;
signal pn_start, sdo_posenc:  std_logic;
signal data: std_logic_vector(3 downto 0);

BEGIN
    uut: data_layer PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      pn_start => pn_start,
      data => data,
      sdo_posenc => sdo_posenc
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
        data <= "0001"; -- some mock data
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset 2H, 2L
        tbvector("01");
        tbvector("01");
        tbvector("00");
        tbvector("00");

        wait for period;

        -- normal sequence
        tbvector("10");

        for i in 0 to 9 loop
            tbvector("00");
        end loop;

        tbvector("10");
        for i in 0 to 9 loop
            tbvector("00");
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