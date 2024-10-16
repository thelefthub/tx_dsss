-- Layered architecture: Access layer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity access_layer is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     sdo_posenc: in std_logic;
     dip_sw: in std_logic_vector(1 downto 0);
     pn_start: out std_logic;
     sdo_spread: out std_logic
     );
end access_layer;

architecture behav of access_layer is

component pn_generator is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        pn_start: out std_logic; 
        pn_ml1: out std_logic;
        pn_ml2: out std_logic;
        pn_gold: out std_logic
        );
end component pn_generator;

-- Use mux to select pseudo noise option for encryption
component mux is
    Port (
        i1: in std_logic;               
        i2: in std_logic;
        i3: in std_logic;
        i4: in std_logic;
        sel: in std_logic_vector(1 downto 0);
        result: out std_logic
    );
end component mux;

-- Internal signals for connecting components
signal int_pn_ml1, int_pn_ml2, int_pn_gold: std_logic;
signal enc_pn_ml1, enc_pn_ml2, enc_pn_gold: std_logic;

begin

    enc_pn_ml1	<= int_pn_ml1 xor sdo_posenc;
    enc_pn_ml2	<= int_pn_ml2 xor sdo_posenc;
    enc_pn_gold <= int_pn_gold xor sdo_posenc;

    -- instances of layer components
    tx_pn_generator: pn_generator PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      pn_start => pn_start,
      pn_ml1 => int_pn_ml1,
      pn_ml2 => int_pn_ml2,
      pn_gold => int_pn_gold
      );

    tx_acc_mux: mux PORT MAP(
      i1 => sdo_posenc,               
      i2 => enc_pn_ml1,
      i3 => enc_pn_ml2,
      i4 => enc_pn_gold,
      sel => dip_sw,
      result => sdo_spread
    );

    

end behav;

