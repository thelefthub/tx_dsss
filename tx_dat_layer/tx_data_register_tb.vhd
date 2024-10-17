-- test bench for data register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_register_tb is
end data_register_tb;

architecture structural of data_register_tb is
    
component data_register is
    port (
        clk, rst: in std_logic;
        ld, sh: in std_logic;
        clk_enable: in std_logic;
        data: in std_logic_vector(3 downto 0);
        sdo_posenc: out std_logic -- shift out
        );
end component data_register;

for uut : data_register use entity work.data_register(behav);
 
constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
-- signal clk_enable:  std_logic;
signal ld, sh, sdo_posenc:  std_logic;
signal data: std_logic_vector(3 downto 0);

BEGIN
    uut: data_register PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      ld => ld,
      sh => sh,
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
    procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
        begin
        rst <= stimvect(0);
        ld <= stimvect(1);
        sh <= stimvect(2);
        data <= "0001"; -- some mock data
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset 2H, 2L
        tbvector("001");
        tbvector("001");
        tbvector("000");
        tbvector("000");

        wait for period;
        
        -- load
        tbvector("010");

        --shift 10 times (cf. expected)
        for i in 0 to 9 loop
            tbvector("100");
        end loop;

        -- load
        tbvector("010");

        --shift 10 times (cf. expected)
        for i in 0 to 9 loop
            tbvector("100");
        end loop;

        -- test reset
        tbvector("010");
        tbvector("001");

        -- load
        tbvector("010");

        --shift 10 times (cf. expected)
        for i in 0 to 9 loop
            tbvector("100");
        end loop;
                            
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;