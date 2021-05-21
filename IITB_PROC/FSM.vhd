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
		
		--outs to datapath
		cz_assign, rf_wr, alu_op, c_m6, c_m8, c_sext9: in std_logic;
		c_m1, c_m4, c_m5, c_m7, c_m8, c_m9: in std_logic_vector(1 downto 0);
		
		--outs to memory
		mem_wr, mem_rd: out std_logic
	);
end entity;

architecture struc of FSM is 
-------components------------


end struc;