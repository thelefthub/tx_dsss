
-- pn generator
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity pn_generator is
   port (
	clk, rst: in std_logic;
	clk_enable: in std_logic;
    pn_start: out std_logic; 
  	pn_ml1: out std_logic;
  	pn_ml2: out std_logic;
  	pn_gold: out std_logic
	);
end pn_generator;

architecture behav of pn_generator is
    
signal pres_shift_1, next_shift_1: std_logic_vector(4 downto 0) := "00010";
signal pres_shift_2, next_shift_2: std_logic_vector(4 downto 0) := "00111";

begin

-- signals out
pn_ml1   <= pres_shift_1(0);
pn_ml2   <= pres_shift_2(0);
pn_gold  <= pres_shift_1(0) xor pres_shift_2(0);


syn_shift: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_shift_1 <= "00010";
            pres_shift_2 <= "00111";
        else
            pres_shift_1 <= next_shift_1;
            pres_shift_2 <= next_shift_2;
        end if;
    end if;

end process syn_shift;

com_shift: process(pres_shift_1,pres_shift_2) 
begin
    -- Shift right and consecutive xor ops for the MSB
    next_shift_1 <= (pres_shift_1(0) xor pres_shift_1(3)) & pres_shift_1(4 downto 1);
    next_shift_2 <= ((((pres_shift_2(0) xor pres_shift_2(1)) xor pres_shift_2(3)) xor pres_shift_2(4))) & pres_shift_2(4 downto 1);

    -- output for sequence controller (load or shift op)
    if next_shift_1 = "00010"
    then 
        pn_start <='1';
    else
        pn_start <='0';
    end if;

end process com_shift; 
    
end behav;
    