library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity FSM is 
	port(
		clk, rst: in std_logic;
		--ins from datapath
		instruction: in std_logic_vector(15 downto 0);
		C_val, Z_val: in std_logic;
		
		--outs to datapath
		cz_assign, rf_wr, alu_op, c_m6, c_m8, c_sext9: out std_logic;
		c_m1, c_m4, c_m5, c_m7, c_m8, c_m9: out std_logic_vector(1 downto 0);-- c_m2, c_m3 are not available as those muxes are not present as of now
		c_d1, c_d2, c_d3, c_d4: out std_logic;
		
		--outs to memory
		mem_wr, mem_rd: out std_logic
	);
end entity;

architecture struc of FSM is 
-------components------------


end struc;