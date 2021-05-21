library ieee;
use ieee.std_logic_1164.all;

entity ff_register is
	port(
		clk, rst: in std_logic;
		d: in std_logic_vector(15 downto 0);
		s: out std_logic_vector(15 downto 0)
	);
end entity;

architecture struc of ff_register is 
	component DFlipFlop is
		port(
			port (clk, rst, d: in std_logic; q: out std_logic);
		);
	end component;
	
	begin
	
	ff16: for i in 15 downto 0 generate
		ff: port map(clk => clk, rst => rst, d=>d(i), s=> s(i));		
	end generate;
	
end struc;