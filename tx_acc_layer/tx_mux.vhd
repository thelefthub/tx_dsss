-- multiplexer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity mux is
    Port (
        i1: in  std_logic;               
        i2: in  std_logic;
        i3: in  std_logic;
        i4: in  std_logic;
        sel: in  std_logic_vector(1 downto 0);
        result: out std_logic
    );
end mux;

architecture behav of mux is

begin
    process(i1, i2, i3, i4, sel)
    begin
        case sel is
            when "00" => result <= i1;
            when "01" => result <= i2;
            when "10" => result <= i3;
            when "11" => result <= i4;
            when others => result <= '0';
        end case;
    end process;
end behav;