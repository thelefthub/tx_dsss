
-- Counter with up and down input
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity counter is
   port (
    clk, rst: in std_logic;
	up, down: in std_logic;
	clk_enable: in std_logic;
	count_out: out std_logic_vector(3 downto 0)
	);
end counter;

architecture behav of counter is
    
signal pres_count, next_count: std_logic_vector(3 downto 0);

begin
    
count_out <= pres_count;

syn_count: process(clk)
begin
    
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_count <= (others => '0');
        else
            pres_count <= next_count;
        end if;
    end if;

end process syn_count;

com_count: process(pres_count, up, down) 
begin
    if up = '1' then
        next_count <= pres_count + "0001";
    elsif down = '1' then
        next_count <= pres_count - "0001";
    else -- each if minimally needs an unconditional else!
        next_count <= pres_count;
    end if;
end process com_count; 
    
end behav;
    