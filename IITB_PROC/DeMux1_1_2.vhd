library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity DeMux1_1_2 is
	port(
		A, S: in std_logic;
		O0, O1: out std_logic
	);
end entity;

architecture struc of DeMux1_1_2 is
	
	begin
	O0 <= (not S) and A;
	O1 <= S and A;
	
end struc;
