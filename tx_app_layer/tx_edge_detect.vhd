-- Edge detector
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity edge_detector is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     db_input: in std_logic;
     pos_edge: out std_logic
     );
 end edge_detector;

architecture behav OF edge_detector IS

type state_type is (NO_PULSE, PULSE, PULSED, RESET);
signal pres_edge, next_edge: state_type := NO_PULSE;


begin

syn_edge: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_edge <= NO_PULSE;
        else
            pres_edge <= next_edge;
        end if;
    end if;
end process syn_edge;

com_shift: process(db_input, pres_edge) 
begin
    -- state machine for pulse handling
    case pres_edge is
        when NO_PULSE => -- present state does not require sending out pulse signal
            pos_edge <= '0';
            if db_input = '1' then 
                next_edge <= PULSE;
            else 	
                next_edge <= NO_PULSE;
            end if;	
        when PULSE => -- present state requires sending out pulse signal
            pos_edge <= '1';
            next_edge <= PULSED;
        when PULSED => -- present state has sent out pulse signal
            pos_edge <= '0';
            if db_input = '0' then
                next_edge <= RESET;
            else	
                next_edge <= PULSED;
            end if;
        when RESET => -- present state requires reset
            pos_edge <= '0';
            next_edge <= NO_PULSE;
        when others => -- default: reset
            pos_edge <= '0';
            next_edge <= NO_PULSE;
    end case;
end process com_shift;


end behav;