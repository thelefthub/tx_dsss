-- dsss main application
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity top is
    port (
     clk, rst: in std_logic;
     btn_up, btn_down: in std_logic;
     seg_display: out std_logic_vector(7 downto 0);
     dip_sw: in std_logic_vector(1 downto 0);
     sdo_spread: out std_logic
    );
end top;

architecture behav of top is

component main is
    port (
    clk, rst: in std_logic;
    clk_enable: in std_logic;
    btn_up, btn_down: in std_logic;
    seg_display: out std_logic_vector(7 downto 0);
    dip_sw: in std_logic_vector(1 downto 0);
    sdo_spread: out std_logic
    );
end component main;

component clk_counter is
    port (
    clk: in std_logic;
    clk_out: out std_logic
     );
end component clk_counter;

-- Internal signals for connecting components
signal clk_send: std_logic;

begin
    -- instances of layer components
    tx_main: main PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_send,
        btn_up => btn_up,
        btn_down => btn_down,
        seg_display => seg_display,
        dip_sw => dip_sw,
        sdo_spread => sdo_spread
    );

    tx_clk_counter: clk_counter PORT MAP(
        clk => clk,
        clk_out => clk_send
    );

    
end behav;
