library ieee;
use ieee.std_logic_1164.all;
--library work;
--use work.Gates.all;

entity sext_9bit is
	port (
	X: in std_logic_vector(8 downto 0);
	s_type: in std_logic;
	Y: out std_logic_vector(15 downto 0));
end entity sext_9bit;

architecture Easy of sext_9bit is

component Mux16_2_1 is
	port( 
		A, B : in std_logic_vector(15 downto 0);
		S0 : in std_logic;
		y : out std_logic_vector(15 downto 0) 
	);
end component;

signal temp1, temp2 : std_logic_vector(15 downto 0);
	
begin

temp1 <= X(8)&X(7)&X(6)&X(5)&X(4)&X(3)&X(2)&X(1)&X(0)&'0'&'0'&'0'&'0'&'0'&'0'&'0';
temp2(8 downto 0) <= X(8 downto 0); 
		temp2(15) <= X(8);
		temp2(14) <= X(8); 
		temp2(13) <= X(8);
		temp2(12) <= X(8); 
		temp2(11) <= X(8);
		temp2(10) <= X(8);
		temp2(9) <= X(8);

mux: Mux16_2_1 port map(A => temp1, B => temp2, S0 => s_type, y => Y);

end Easy;