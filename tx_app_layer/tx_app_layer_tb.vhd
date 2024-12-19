-- test bench for application layer
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity app_layer_tb is
end app_layer_tb;

architecture structural of app_layer_tb is
    
component app_layer is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        btn_up, btn_down: in std_logic;
        syncha, synchb:	in std_logic:='0';
        seg_display: out std_logic_vector(7 downto 0);
        count_out: out std_logic_vector(3 downto 0)
     );
end component app_layer;

for uut : app_layer use entity work.app_layer(behav);

constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal clk, rst: std_logic;
signal btn_up, btn_down: std_logic;
signal seg_display: std_logic_vector(7 downto 0);
signal count_out: std_logic_vector(3 downto 0);

BEGIN
    uut: app_layer PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      btn_up => btn_up,
      btn_down => btn_down,
      seg_display => seg_display,
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
        btn_up <= stimvect(1);
        btn_down <= stimvect(2);
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset 2H, 2L
        tbvector("001");
        tbvector("001");
        tbvector("000");
        tbvector("000");

        --start debounce btn up
        tbvector("010");
        tbvector("010");
        tbvector("010");
        tbvector("000");
        tbvector("000");
        tbvector("010");
        tbvector("010");
        tbvector("000");

        --keep high (1 up)
        tbvector("010");
        wait for period*20;
        
        -- no btn push
        tbvector("000");
        wait for period*20;

        --start debounce btn up
        tbvector("010");
        tbvector("010");
        tbvector("010");
        tbvector("000");
        tbvector("000");
        tbvector("010");
        tbvector("010");
        tbvector("000");

        --keep high (2 up)
        tbvector("010");
        wait for period*20;

        -- no btn push
        tbvector("000");
        wait for period*20;

        --start debounce btn down
        tbvector("100");
        tbvector("100");
        tbvector("100");
        tbvector("000");
        tbvector("000");
        tbvector("100");
        tbvector("100");
        tbvector("000");

        --keep high (1 up)
        tbvector("100");
        wait for period*20;

        -- no btn push
        tbvector("000");
        wait for period*20;

        --start debounce btn down
        tbvector("100");
        tbvector("100");
        tbvector("100");
        tbvector("000");
        tbvector("000");
        tbvector("100");
        tbvector("100");
        tbvector("000");

        --keep high (0 up)
        tbvector("100");
        wait for period*20;

        -- no btn push
        tbvector("000");
        wait for period*20;

        -- test reset
        tbvector("010");
        wait for period*20;
        tbvector("001");
                            
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;