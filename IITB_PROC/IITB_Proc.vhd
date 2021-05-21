library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

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
		c_assign, z_assign , rf_wr, alu_op, c_m6, c_m8, c_sext9: in std_logic;
		c_m1, c_m4, c_m5, c_m7, c_m9: in std_logic_vector(1 downto 0);
		c_d1, c_d2, c_d3, c_d4: in std_logic_vector(1 downto 0);
		
		-- ins from memory
		mem_dataout: in std_logic_vector(15 downto 0);
		
		--outs to memory
		mem_addr, mem_datain: out std_logic_vector(15 downto 0);
		
		--outs to FSM
		instruction, ra, rb, t_reg: out std_logic_vector(15 downto 0);
		C_val, Z_val: out std_logic
	);
end component;

-- 2. FSM
component FSM is 
	port(
		clk, rst: in std_logic;
		--ins from datapath
		instruction, ra, rb, t_reg: in std_logic_vector(15 downto 0);
		C_val, Z_val: in std_logic;
		
		--outs to datapath
		c_assign, z_assign, rf_wr, alu_op, c_m6, c_m8, c_sext9: out std_logic;
		c_m1, c_m4, c_m5, c_m7, c_m9: out std_logic_vector(1 downto 0); -- c_m2, c_m3 are not available as those muxes are not present as of now
		c_d1, c_d2, c_d3, c_d4: out std_logic_vector(1 downto 0);
		
		--outs to memory
		mem_wr, mem_rd: out std_logic	
	);
end component;

--3. Memory 
component Memory is 
	port(
		clk: std_logic; 
		wr, rd: in std_logic;
		Addr_in, D_in: in std_logic_vector(15 downto 0);
		D_out: out std_logic_vector(15 downto 0)
	);
end component;

-- signals to connect the inputs to the outputs of components
signal sig_c_assign, sig_z_assign, sig_rf_wr, sig_alu_op, sig_c_m6, sig_c_m8, sig_c_sext9 :std_logic;
signal sig_c_m1, sig_c_m4, sig_c_m5, sig_c_m7, sig_c_m9, sig_c_d1, sig_c_d2, sig_c_d3, sig_c_d4: std_logic_vector(1 downto 0);
signal sig_mem_dataout, sig_mem_addr, sig_mem_datain, sig_instr, sig_ra, sig_rb, sig_t_reg: std_logic_vector(15 downto 0);
signal sig_C, sig_Z, sig_mem_wr, sig_mem_rd: std_logic;


begin

datapath_main: Datapath port map(clk => clk, rst => rst,
											c_assign => sig_c_assign, z_assign => sig_z_assign, rf_wr => sig_rf_wr, 
											alu_op => sig_alu_op, c_m6 => sig_c_m6, c_m8 => sig_c_m8, c_sext9 => sig_c_sext9,
											c_m1 => sig_c_m1, c_m4 => sig_c_m4, c_m5 => sig_c_m5, c_m7 => sig_c_m7, c_m9 => sig_c_m9,
											c_d1 => sig_c_d1, c_d2 => sig_c_d2, c_d3 => sig_c_d3, c_d4 => sig_c_d4,
											
											mem_dataout => sig_mem_dataout,
											mem_addr => sig_mem_addr,
											mem_datain => sig_mem_datain,
											instruction => sig_instr,
											ra => sig_ra,
											rb => sig_rb,
											t_reg => sig_t_ref,
											C_val => sig_C,
											Z_val => sig_Z);
											
FSM_main: FSM port map(clk => clk, rst => rst,
									instruction => sig_instr,
									ra => sig_ra,
									rb => sig_rb,
									C_val => sig_C,
									Z_val => sig_Z,
									t_reg => t_reg_v,
									
									c_assign => sig_c_assign, z_assign => sig_z_assign, rf_wr => sig_rf_wr, 
									alu_op => sig_alu_op, c_m6 => sig_c_m6, c_m8 => sig_c_m8, c_sext9 => sig_c_sext9,
									c_m1 => sig_c_m1, c_m4 => sig_c_m4, c_m5 => sig_c_m5, c_m7 => sig_c_m7,	c_m9 => sig_c_m9,
									c_d1 => sig_c_d1, c_d2 => sig_c_d2, c_d3 => sig_c_d3, c_d4 => sig_c_d4,
									
									mem_wr => sig_mem_wr,
									mem_rd => sig_mem_rd);
									
memory_main: Memory port map(clk => clk,
											wr => sig_mem_wr,
											rd => sig_mem_rd,
											Addr_in => sig_mem_addr,
											D_in => sig_mem_datain, 
											D_out => sig_mem_dataout);

op <= "0000";

end behave;