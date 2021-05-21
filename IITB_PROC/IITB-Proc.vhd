library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 
library work;
use work.Gates.all;

entity IITB_Proc is 
	port(
		clk, rst: in std_logic;
		op: out std_logic_vector(3 downto 0)
	);
end entity;

architecture behave of IITB_Proc is
------------ components ------------------

-- 1. Datapath
component Datapath is 
	port(
		clk, rst: in std_logic;
		
		--controls from FSM
		cz_assign, rf_wr, alu_op, c_m6, c_m8, c_sext9: in std_logic;
		c_m1, c_m4, c_m5, c_m7, c_m8, c_m9: in std_logic_vector(1 downto 0);
		
		-- ins from memory
		mem_dataout: instd_logic_vector(15 downto 0);
		
		--outs to memory
		mem_addr, mem_datain: out std_logic_vector(15 downto 0);
		
		--outs to FSM
		instruction: out std_logic_vector(15 downto 0)
	);
end component;

-- 2. FSM
component FSM is 
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
end component;

--3. Memory 
component Memory is 
	port(
		clk: std_logic; 
		wr, rd: in std_logic;
		A_in, D_in: in std_logic_vector(15 downto 0);
		Dout: out std_logic_vector(15 downto 0)
	);
end component;



end behave;