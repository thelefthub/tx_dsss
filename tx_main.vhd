-- dsss main application
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity main is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     btn_up, btn_down: in std_logic;
     seg_display: out std_logic_vector(7 downto 0);
     dip_sw: in std_logic_vector(1 downto 0);
    -- test_out: out std_logic_vector(3 downto 0); --test
     sdo_spread: out std_logic
    
     );
end main;

architecture behav of main is

component app_layer is
port (
    clk, rst: in std_logic;
    clk_enable: in std_logic;
    btn_up, btn_down: in std_logic;
    seg_display: out std_logic_vector(7 downto 0);
    count_out: out std_logic_vector(3 downto 0)
    );
end component app_layer;

component data_layer is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     pn_start: in std_logic;
     data: in std_logic_vector(3 downto 0);
     sdo_posenc: out std_logic
     );
end component data_layer;

component access_layer is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     sdo_posenc: in std_logic;
     dip_sw: in std_logic_vector(1 downto 0);
     pn_start: out std_logic;
     sdo_spread: out std_logic
     );
end component access_layer;

-- Internal signals for connecting components
signal count_data, test: std_logic_vector(3 downto 0);
signal sdo_posenc, pn_start: std_logic;
-- Inverted signals
signal rst_inv, btn_up_inv,btn_down_inv : std_logic;
signal dip_sw_inv: std_logic_vector(1 downto 0);

begin
    -- All I/O active low!!!!! => invert I/O
    rst_inv <= not rst;
    btn_up_inv <= not btn_up;
    btn_down_inv <= not btn_down;
    dip_sw_inv <= not dip_sw;
    
    -- test_out <= count_data; --test
    
    -- instances of layer components
    tx_app_layer: app_layer PORT MAP(
        clk => clk,
        rst => rst_inv,
        clk_enable => clk_enable,
        btn_up => btn_up_inv,
        btn_down => btn_down_inv,
        seg_display => seg_display,
        count_out => count_data
    );

    tx_data_layer: data_layer PORT MAP(
        clk => clk,
        rst => rst_inv,
        clk_enable => clk_enable,
        pn_start => pn_start,
        data => count_data, --count_data, --"0001"
        sdo_posenc => sdo_posenc
    );

    tx_access_layer: access_layer PORT MAP(
        clk => clk,
        rst => rst_inv,
        clk_enable => clk_enable,
        sdo_posenc => sdo_posenc,
        dip_sw => dip_sw_inv,
        pn_start => pn_start,
        sdo_spread => sdo_spread
    );

end behav;
