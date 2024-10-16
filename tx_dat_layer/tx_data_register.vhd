-- Data register with preamble and count data
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity data_register is
    port (
     clk, rst: in std_logic;
     ld, sh: in std_logic;
     clk_enable: in std_logic;
     data: in std_logic_vector(3 downto 0);
     sdo_posenc: out std_logic -- shift out
     );
end data_register;

architecture behav of data_register is

-- Preamble is used for detecting data sequences (hence shift preamble out first)
constant preamble: std_logic_vector(6 downto 0) := "0111110";
signal pres_data, next_data: std_logic_vector(10 downto 0) := preamble&"0000";

begin

-- signal out (shift out preamble + data)
sdo_posenc <= pres_data(10);

-- sequential process: (Flip-flop behavior)
syn_shift: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_data <= preamble&"0000";
        else
            pres_data <= next_data;
        end if;
    end if;
end process syn_shift;

-- Combinational process (Next-state logic)
com_shift: process(pres_data, ld, sh) 
begin
    if (ld = '1') then
        next_data <= preamble & data;
    elsif (sh = '1') then
        next_data <= pres_data(9 downto 0) & sh; --concat with random bit (i.e. shift)?
    else -- each if minimally needs an unconditional else!
        next_data <= pres_data;
    end if; 
end process com_shift; 

end behav;

