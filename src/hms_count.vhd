library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.digital_clock_common.all;

entity hms_count is
    generic (
        C_CLK_FRQ : integer := GC_CLK_FRQ -- GC_CLK_FRQ def in digital_clock_common
    );
    port (
        clk    : in std_logic;
        rst_n  : in std_logic;

        sec_o  : out unsigned(6 downto 0);
        min_o  : out unsigned(6 downto 0);
        hour_o : out unsigned(6 downto 0)
    );
end entity hms_count;

architecture rtl of hms_count is

    signal s_tick      : integer range 0 to C_CLK_FRQ           := 0;
    signal s_sec       : integer range 0 to GC_TIME_COUNT_MAX   := 0;
    signal s_min       : integer range 0 to GC_TIME_COUNT_MAX   := 0;
    signal s_hour      : integer range 0 to GC_ONE_DAY_IN_HOURS := 0;

    signal s_sec_prev  : integer range 0 to GC_TIME_COUNT_MAX   := 0;
    signal s_min_prev  : integer range 0 to GC_TIME_COUNT_MAX   := 0;
    signal s_hour_prev : integer range 0 to GC_TIME_COUNT_MAX   := 0;

begin

    hms_count : process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst_n = '0') then
                s_tick      <= 0;
                s_sec       <= 0;
                s_min       <= 0;
                s_hour      <= 0;
                s_sec_prev  <= 0;
                s_min_prev  <= 0;
                s_hour_prev <= 0;
            else
                if (s_tick = C_CLK_FRQ - 1) then
                    s_tick <= 0;
                    if (s_sec = GC_TIME_COUNT_MAX - 1) then
                        s_sec <= 0;
                        if (s_min = GC_TIME_COUNT_MAX - 1) then
                            s_min <= 0;
                            if (s_hour = GC_ONE_DAY_IN_HOURS - 1) then
                                s_hour <= 0;
                            else
                                s_hour <= s_hour + 1;
                            end if;
                        else
                            s_min <= s_min + 1;
                        end if;
                    else
                        s_sec <= s_sec + 1;
                    end if;
                else
                    s_tick <= s_tick + 1;
                end if;
            end if;
            s_sec_prev  <= s_sec;
            s_min_prev  <= s_min;
            s_hour_prev <= s_hour;
        end if;
    end process hms_count;

    sec_o  <= to_unsigned(s_sec, sec_o'length);
    min_o  <= to_unsigned(s_min, min_o'length);
    hour_o <= to_unsigned(s_hour, hour_o'length);

end architecture;