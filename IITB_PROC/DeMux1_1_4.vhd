library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 


entity DeMux1_1_4 is 
	port(
		A: in std_logic;
		S1, S0: in std_logic;
		O0, O1, O2, O3: out std_logic
	);
end entity;

architecture struc of DeMux1_1_4 is

begin
	O0 <= A and (not S1) and (not S0);
	O1	<= A and (not S1) and S0;
	O2 <= A and S1 and (not S0);
	O3 <= A and S1 and S0;
end struc;
