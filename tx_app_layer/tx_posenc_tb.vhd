-- Testbench for rotary encoder with edge detector
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity posenc_tb is
end posenc_tb;

architecture structural of posenc_tb is

component posenc is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        syncha: in std_logic;
        synchb: in std_logic;
        up, down: out std_logic
        
        );
end component posenc;

for uut : posenc use entity work.posenc(behav);

constant period : time := 100 ns;

constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst: std_logic;
signal syncha, synchb,up, down : std_logic;

BEGIN
    uut: posenc PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      syncha => syncha,
      synchb => synchb,
      up => up,
      down => down
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
	
    tb : process 
BEGIN
    rst       <='0';
    syncha    <='0';
    synchb    <='0';
    wait for period * 5;

    -- clockwise
    for i in 0 to 10 loop
        syncha <= '1';
        wait for period * 5;
        synchb <= '1';
        wait for period * 5;
        syncha <= '0';
        wait for period * 5;
        synchb <= '0';
    end loop;

    -- counterclockwise
    for i in 0 to 10 loop
        synchb <= '1';
        wait for period * 5;
        syncha <= '1';
        wait for period * 5;
        synchb <= '0';
        wait for period * 5;
        syncha <= '0';
    end loop;
    
    -- test reset 
    rst	<= '1';
    wait for period * 5;
    rst	<= '0';
    -- clockwise
    for i in 0 to 10 loop
        syncha <= '1';
        wait for period * 5;
        synchb <= '1';
        wait for period * 5;
        syncha <= '0';
        wait for period * 5;
        synchb <= '0';
    end loop;

    end_of_sim <= true;
    wait;
end process tb;
    

end;