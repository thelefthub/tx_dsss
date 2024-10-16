-- test bench for data layer
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity access_layer_tb is
end access_layer_tb;

architecture structural of access_layer_tb is
    
component access_layer is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        sdo_posenc: in std_logic;
        dip_sw: in std_logic_vector(1 downto 0);
        pn_start: out std_logic;
        sdo_spread: out std_logic
     );
end component access_layer;

for uut : access_layer use entity work.access_layer(behav);

constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
-- signal clk_enable:  std_logic;
signal pn_start, sdo_posenc, sdo_spread:  std_logic;
signal dip_sw: std_logic_vector(1 downto 0);

BEGIN
    uut: access_layer PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      sdo_posenc => sdo_posenc,
      dip_sw => dip_sw,
      pn_start => pn_start,
      sdo_spread => sdo_spread
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
        -- normal sequence (test bit: 1)
        sdo_posenc <= '1';
        rst <='0';
        -- dip selection at sdo_posenc (unencrypted):exepected output is 1 (high)
        dip_sw <= "00";
        wait for period*100;

        -- dip selection at pn_ml1 (encrypted):exepected output is a specific repeating pattern
        dip_sw <= "01";
        wait for period*100;

        -- dip selection at pn_ml2 (encrypted):exepected output is a specific repeating pattern
        dip_sw <= "10";
        wait for period*100;

        -- dip selection at pn_gold (encrypted):exepected output is a specific repeating pattern
        dip_sw <= "11";
        wait for period*100;

        -- -- Test reset pattern
        rst <='1';
        wait for period*50;
                            
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;