library ieee;
use ieee.std_logic_1164.all;

entity dff_register is
	port(
		clk, rst, wr: in std_logic;
		i: in std_logic_vector(15 downto 0);
		o: out std_logic_vector(15 downto 0)
	);
end entity;

architecture struc of dff_register is 
	component DFlipFlop is
		port(
			clk, rst, wr, i: in std_logic; 
			o: out std_logic
		);
	end component;
	
	begin
	
	ff16: for index in 15 downto 0 generate
		ff: DFlipFlop port map(clk => clk, rst => rst, wr => wr, i => i(index), o => o(index));		
	end generate;
	
end struc;