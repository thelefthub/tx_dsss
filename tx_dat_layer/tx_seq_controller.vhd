-- Sequence controller state machine
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity seq_controller is
    port (
     clk, rst: in std_logic;
     ld, sh: out std_logic;
     clk_enable: in std_logic;
    --  count_test: out std_logic_vector(3 downto 0); --test
     pn_start: in std_logic
     );
end seq_controller;

architecture behav of seq_controller is

type seq_type is (RESET, LOAD, SHIFT);
signal pres_count, next_count: std_logic_vector(3 downto 0);
signal pres_seq, next_seq: seq_type := RESET;


begin

-- count_test <= pres_count; --test

syn_sequence: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_count <= (others => '0');
            pres_seq <= RESET;
        else
            pres_count <= next_count;
            pres_seq <= next_seq;
        end if;
    end if;
end process syn_sequence;

-- state machine for data handling
-- sync data output (load/schift on a new pn sequence): 1 load - 10 shift
com_sequence: process(pres_seq, pres_count, pn_start) 
begin
    -- Default assignments to avoid latches??
    -- next_count <= pres_count;
    -- next_seq <= pres_seq;
    -- ld <= '0';
    -- sh <= '0';
    if pn_start ='1' then
        case pres_seq is
            when RESET => 
                ld <= '1';
                sh <= '0';
                next_count	<= pres_count + "0001";
                next_seq <= LOAD;	
            when LOAD => 
                ld <= '0';
                sh <= '1';
                next_count	<= pres_count + "0001";
                next_seq <= SHIFT;
            when SHIFT =>
                if pres_count = "1010" then -- 1 load - 10 shift
                    ld <= '0';
                    sh <= '1';
                    next_count	<= (others => '0'); --"0000";
                    next_seq <= RESET;
                else
                    ld <= '0';
                    sh <= '1';
                    next_count	<= pres_count + "0001";
                    next_seq <= SHIFT;
                end if;
            when others =>
                ld <= '0';
                sh <= '0';
                next_seq <= RESET;
        end case;
    else
        next_seq <= pres_seq;
        next_count	<= pres_count;
        ld <= '0';
        sh <= '0';
    end if;
    
end process com_sequence; 
    
end behav;

