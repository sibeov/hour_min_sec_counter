library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.digital_clock_common.all;

entity hms_count_tb is
end entity hms_count_tb;

architecture sim of hms_count_tb is

    -- Generics
    constant TBC_CLK_FRQ : integer               := 10;
    constant TBC_CLK_PRD : time                  := (1 sec / TBC_CLK_FRQ);

    -- Signals
    signal clk_tb        : std_logic             := '0';
    signal clk_ena       : boolean               := false;
    signal rst_n_tb      : std_logic             := '1';

    signal sec_o_tb      : unsigned (6 downto 0) := (others => '0');
    signal min_o_tb      : unsigned (6 downto 0) := (others => '0');
    signal hour_o_tb     : unsigned (6 downto 0) := (others => '0');

begin

    -- Device und test
    DUT : entity work.hms_count(rtl)
        generic map(
            C_CLK_FRQ => TBC_CLK_FRQ
        )
        port map(
            clk    => clk_tb,
            rst_n  => rst_n_tb,
            sec_o  => sec_o_tb,
            min_o  => min_o_tb,
            hour_o => hour_o_tb
        );

    -- Clock enerator
    clk_tb <= not clk_tb after (TBC_CLK_PRD / 2) when clk_ena = true else '0';

    p_stimuli : process
    begin
        clk_ena <= false;
        wait for 1 min;

        clk_ena  <= true;
        rst_n_tb <= '0';
        wait for 1 min;
        rst_n_tb <= '1';
        wait for 3700 min;

        rst_n_tb <= '0';
        clk_ena  <= false;
        wait for 1 min;
        wait;
    end process p_stimuli;

end architecture;