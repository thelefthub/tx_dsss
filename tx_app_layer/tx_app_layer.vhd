-- Layered architecture: application layer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity app_layer is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     btn_up, btn_down: in std_logic;
     seg_display: out std_logic_vector(7 downto 0);
     count_out: out std_logic_vector(3 downto 0)
     );
end app_layer;

architecture behav of app_layer is

component debouncer is
    port (
        clk, rst: in std_logic;
        btn_input: in std_logic;
        clk_enable: in std_logic;
        btn_input_sync: out std_logic
    );
end component debouncer;

component edge_detector is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        db_input: in std_logic;
        pos_edge: out std_logic
        );
end component edge_detector;

component counter is
    port (
        clk, rst: in std_logic;
        up, down: in std_logic;
        clk_enable: in std_logic;
        count_out: out std_logic_vector(3 downto 0)
        );
end component counter;

component decoder is
    Port (
        digit : in  std_logic_vector(3 downto 0);
        segments : out std_logic_vector(7 downto 0)  -- 8-segment output (abcdefg + dp)
    );
end component decoder;

-- Internal signals for connecting components
signal btn_input_sync_up, btn_input_sync_down, pos_edge_up, pos_edge_down: std_logic;
signal count_data: std_logic_vector(3 downto 0);

begin
    count_out <= count_data;

    -- instances of layer components
    tx_debouncer_up: debouncer PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        btn_input => btn_up,
        btn_input_sync => btn_input_sync_up
      );

    tx_debouncer_down: debouncer PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        btn_input => btn_down,
        btn_input_sync => btn_input_sync_down
    );

    tx_edge_detector_up: edge_detector PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        db_input => btn_input_sync_up,
        pos_edge => pos_edge_up
    );

    tx_edge_detector_down: edge_detector PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        db_input => btn_input_sync_down,
        pos_edge => pos_edge_down
    );

    tx_counter: counter PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        up => pos_edge_up,
        down => pos_edge_down,
        count_out => count_data
    );

    tx_decoder: decoder PORT MAP(
        digit => count_data,
        segments => seg_display
    );

    

end behav;
