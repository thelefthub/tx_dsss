-- Rotary encoder with edge detector
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity posenc is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     syncha: in std_logic;
     synchb: in std_logic;
     up, down: out std_logic
     );
 end posenc;

architecture behav of posenc is

type state_type is (S00, S01, S11, S10);
signal pres_state, next_state : state_type:= S00;
signal up_internal, down_internal : std_logic;

-- signal direction_internal : std_logic;

begin

-- signals out
up <= up_internal;
down <= down_internal;

-- transition state detection machine and feed changes to correlator
syn_state: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_state <= S00;
        else
            pres_state <= next_state;
        end if;
    end if;
end process syn_state;

-- Combinational process for next state logic and outputs
com_state: process(pres_state, syncha, synchb)
begin
    -- Default state
    next_state <= pres_state;
    up_internal <= '0';
    down_internal <= '0';
    -- Determine the next state and outputs based on syncha and synchb
    case pres_state is
        when S00 =>
            if syncha = '0' and synchb = '1' then
                next_state <= S01;  -- Clockwise
                up_internal <= '1';
            elsif syncha = '1' and synchb = '0' then
                next_state <= S10;  -- Counterclockwise
                down_internal <= '1';
            end if;
        when S01 =>
            if syncha = '1' and synchb = '1' then
                next_state <= S11;  -- Clockwise
                up_internal <= '1';
            elsif syncha = '0' and synchb = '0' then
                next_state <= S00;  -- Counterclockwise
                down_internal <= '1';
            end if;
        when S11 =>
            if syncha = '1' and synchb = '0' then
                next_state <= S10;  -- Clockwise
                up_internal <= '1';
            elsif syncha = '0' and synchb = '1' then
                next_state <= S01;  -- Counterclockwise
                down_internal <= '1';
            end if;
        when S10 =>
            if syncha = '0' and synchb = '0' then
                next_state <= S00;  -- Clockwise
                up_internal <= '1';
            elsif syncha = '1' and synchb = '1' then
                next_state <= S11;  -- Counterclockwise
                down_internal <= '1';
            end if;
        when others =>
            next_state <= S00;  -- Default state
    end case;

end process com_state;


-- to do: implement logica for more consistent rotary behaviour
-- direct_count: Process(up_internal,down_internal,syncha)
-- begin
--     if down_internal = '1' and syncha = '0' then
--         up	<= '0';
--         down <= down_internal;
--     elsif down_internal = '1' and syncha = '1' then
--         up	<= up_internal;
-- 	    down <= '0';
--     elsif up_internal = '1' and syncha = '0' then
--         up	<= up_internal;
--         down <= '0';
--     elsif up_internal = '1' and syncha = '1' then
--         up	<= '0';
--         down <= down_internal;
--     else
--         up	<= '0';
--         down <= '0';
--     end if;
-- end process direct_count;

 


end behav;