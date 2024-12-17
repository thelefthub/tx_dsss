
-- separation of concerns: 2-process logic!!! memory vs combi logica
-- A "2-process" logic in VHDL refers to an architecture that splits the design into two distinct processes:
--  typically one for combinational logic and the other for sequential logic (such as flip-flops or registers).
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity debouncer is
   port (
	clk, rst: in std_logic;
	btn_input: in std_logic;
	clk_enable: in std_logic;
	btn_input_sync: out std_logic
	);
end debouncer;

architecture behav of debouncer is
    
signal pres_shift, next_shift: std_logic_vector(3 downto 0);
signal load_shift: std_logic := '0';

begin
    
btn_input_sync <= pres_shift(0); -- signal out
load_shift   <= pres_shift(0) xor btn_input;

-- sequential process: (Flip-flop behavior)
syn_shift: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_shift <= (others => '0');
        else --instantiate flip flops memory!
            pres_shift <= next_shift;
        end if;
    end if;
end process syn_shift;

-- Combinational process (Next-state logic)
-- each if minimally needs an unconditional else!!!!
com_shift: process(pres_shift, load_shift) 
begin
    if load_shift ='1' then 
        -- Shift right, bit concatenation of input at the MSB and 3 present shift bits
        next_shift <= btn_input & pres_shift(3 downto 1); --bit concat
    else --parallel load
        next_shift <= (others => pres_shift(0));--others: all unset bits to LSB of present shift
    end if; 
end process com_shift; 
    
end behav;
    