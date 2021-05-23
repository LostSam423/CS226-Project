library ieee;
use ieee.std_logic_1164.all;

entity DFlipFlop is
	port (clk, rst, wr, i: in std_logic; o: out std_logic);
end entity;

architecture behave of DFlipFlop is
begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1' ) then
				o <= '0';
			elsif (wr = '1') then
				o <= i;
			end if;
		end if;
	end process;
end architecture;