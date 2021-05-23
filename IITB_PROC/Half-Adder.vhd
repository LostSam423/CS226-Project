library work;
use work.all;

library IEEE;
use ieee.std_logic_1164.all;

entity Half_Adder is
	port(a,b: in std_logic;
		sum,carry: out std_logic);
end entity;

architecture arch of Half_Adder is
	signal p: std_logic_vector(2 downto 0);
	
	component Mux1_2_1
		port(
			A, B, S0: in std_logic;
			y : out std_logic
		);
	end component;
	
	begin 
	-- And a and b to get carry
	mux1: Mux1_2_1 port map( A => '0', B => a, S0 => b, y => carry);
--	mux2: Mux1_2_1 port map( A => '0', I(1) => p(0), SEL => a, y => carry);
	
	-- xor a and b to get sum
	mux3: Mux1_2_1 port map( A => '0', B => '1', S0 => b, y => p(1));
	mux4: Mux1_2_1 port map( A => '1', B => '0', S0 => b, y => p(2));
	mux5: Mux1_2_1 port map( A => p(1), B => p(2), S0 => a, y => sum);
	
end arch;