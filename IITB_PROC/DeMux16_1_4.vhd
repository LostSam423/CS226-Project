library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 


entity DeMux16_1_4 is 
	port(
		A: in std_logic_vector(15 downto 0);
		S1, S0: in std_logic;
		O0, O1, O2, O3: out std_logic_vector(15 downto 0)
	);
end entity;

architecture struc of DeMux16_1_4 is
	component DeMux1_1_4 is 
		port(
			A: in std_logic;
			S1, S0: in std_logic;
			O0, O1, O2, O3: out std_logic
		);
	end component;
	
	begin
	
	demuxg4: for i in 15 downto 0 generate
		mx: DeMux1_1_4 port map(A => A(i), S0 => S0, S1 => S1,O0 => O0(i), O1=>O1(i), O2=>O2(i), O3=>O3(i));
	end generate demuxg4;
	
end architecture;
