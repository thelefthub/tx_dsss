-- Data layer of the sender
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity data_layer is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     pn_start: in std_logic;
     data: in std_logic_vector(3 downto 0);
     sdo_posenc: out std_logic
     );
end data_layer;

architecture behav of data_layer is

component seq_controller is
    port (
        clk, rst: in std_logic;
        ld, sh: out std_logic;
        clk_enable: in std_logic;
        pn_start: in std_logic
        );
end component seq_controller;

component data_register is
    port (
     clk, rst: in std_logic;
     ld, sh: in std_logic;
     clk_enable: in std_logic;
     data: in std_logic_vector(3 downto 0);
     sdo_posenc: out std_logic -- shift out
     );
end component data_register;

-- Internal signals for connecting components
signal int_ld, int_sh:  std_logic;

begin

    tx_seq_controller: seq_controller PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      pn_start => pn_start,
      ld => int_ld,
      sh => int_sh
      );

    tx_data_register: data_register PORT MAP(
    clk => clk,
    rst => rst,
    clk_enable => clk_enable,
    ld => int_ld,
    sh => int_sh,
    data => data,
    sdo_posenc => sdo_posenc
    );

end behav;