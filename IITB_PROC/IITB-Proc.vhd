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
		c_d1, c_d2, c_d3, c_d4: in std_logic;
		
		-- ins from memory
		mem_dataout: instd_logic_vector(15 downto 0);
		
		--outs to memory
		mem_addr, mem_datain: out std_logic_vector(15 downto 0);
		
		--outs to FSM
		instruction: out std_logic_vector(15 downto 0)
		C_val, Z_val: out std_logic;
	);
end component;

-- 2. FSM
component FSM is 
	port(
		clk, rst: in std_logic;
		--ins from datapath
		instruction: in std_logic_vector(15 downto 0);
		C_val, Z_val: in std_logic;
		
		--outs to datapath
		cz_assign, rf_wr, alu_op, c_m6, c_m8, c_sext9: out std_logic;
		c_m1, c_m4, c_m5, c_m7, c_m8, c_m9: out std_logic_vector(1 downto 0); -- c_m2, c_m3 are not available as those muxes are not present as of now
		c_d1, c_d2, c_d3, c_d4: out std_logic;
		
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

-- signals to connect the inputs to the outputs of components

begin

datapath_main: Datapath port map(clk => clk, rst => rst
											cz_assign => sig_cz_assign, z_assign => sig_z_assign, rf_wr => sig_rf_wr, 
											alu_op => sig_alu_op, c_m6 => sig_c_m6, c_m8 => sig_c_m8, c_sext9 => sig_c_sext9,
											c_m1 => sig_c_m1, c_m4 => sig_c_m4, c_m5 => sig_c_m5, c_m7 => sig_c_m7, c_m8 => sig_c_m8,
											c_m9 => sig_c_m9,
											);
FSM_main: Datapath port map();
memory_main: Datapath port map();


end behave;