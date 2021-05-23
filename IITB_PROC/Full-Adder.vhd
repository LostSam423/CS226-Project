library work;
use work.all;

library IEEE;
use ieee.std_logic_1164.all;

entity Full_Adder is
	port(
		a, b, cin: in std_logic;
		sum, carry: out std_logic
	);
end entity;

architecture arch of Full_Adder is
	component Mux1_2_1
		port(
			A, B, S0: in std_logic;
			y : out std_logic
		);
	end component;
	
	component Half_Adder
		port (
			a,b: in std_logic;
			sum, carry: out std_logic);
	end component;
	
	signal flow: std_logic_vector(2 downto 0);
	
	begin
	
	-- suming sequentially first a and b then sum of a and b with cin
	-- using sum = a^b^cin where ^ represents xor
	
	onha0: Half_Adder port map(a => a, b => b, sum => flow(0), carry => flow(1));
	onha1: Half_Adder port map(a => flow(0), b => cin, sum => sum, carry => flow(2));
	
	-- using carry= (a&b)|(sum(a,b)&cin), these both terms individually from the 2 instances of Half-Adder above and are xored in the
	-- following line using ROBDD implementation
	tbo0: Mux1_2_1 port map(A => flow(1), B => '1', S0 => flow(2), y => carry);
	
end arch;