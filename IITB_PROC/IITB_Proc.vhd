library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity IITB_Proc is 
	port(
		clk, rst: in std_logic;
		ext_wr: in std_logic;
		ext_data, ext_index: in std_logic_vector(15 downto 0);
		pco: out std_logic_vector(15 downto 0)
	);
end entity;

architecture behave of IITB_Proc is
------------ components ------------------

-- 1. Datapath
component Datapath is 
	port(
		clk, rst: in std_logic;
		
		--controls from FSM
		c_rf, c_alu, c_m1, c_m2, c_m3, c_m6, c_m8, c_m10, c_m12, c_m13, c_sext9: in std_logic;
		c_m4, c_m5, c_m7, c_m9, c_m11: in std_logic_vector(1 downto 0); -- c_m2, c_m3 are not available as those muxes are not present as of now
		c_T1, c_T2, c_T3, c_IR, c_PC, c_C, c_Z: in std_logic;
		
		-- ins from memory
		mem_dataout: in std_logic_vector(15 downto 0);
		
		--outs to memory
		mem_addr, mem_datain: out std_logic_vector(15 downto 0);
		
		--outs to FSM
		instruction, T1, T2, T3: out std_logic_vector(15 downto 0);
		Cout, Zout: out std_logic;
		
		-- outs for testing
		pco: out std_logic_vector(15 downto 0)
	);
end component;

-- 2. FSM
component FSM is 
	port(
		clk, rst: in std_logic;
		
		--ins from datapath
		instruction, T1, T2, T3: in std_logic_vector(15 downto 0);
		Cin, Zin: in std_logic;
	
		--outs to datapath
		c_rf, c_alu, c_m1, c_m2, c_m3, c_m6, c_m8, c_m10, c_m12, c_m13, c_sext9: out std_logic;
		c_m4, c_m5, c_m7, c_m9, c_m11: out std_logic_vector(1 downto 0); -- c_m2, c_m3 are not available as those muxes are not present as of now
		c_T1, c_T2, c_T3, c_IR, c_PC, c_C, c_Z: out std_logic;
		
		--outs to memory
		mem_wr: out std_logic
	);
end component;

--3. Memory 
component Memory is 
	port(
		clk: std_logic; 
		wr: in std_logic;
		Addr_in, D_in: in std_logic_vector(15 downto 0);
		D_out: out std_logic_vector(15 downto 0)
	);
end component;

-- 4. 16bit 2x1Mux
component Mux16_2_1 is
	port( 
		A, B : in std_logic_vector(15 downto 0);
		S0 : in std_logic;
		y : out std_logic_vector(15 downto 0) 
	);
end component;

-- 5. 1bit 2x1Mux
component Mux1_2_1 is
port( A, B, S0 : in std_logic;
		y : out std_logic );
end component;

-- signals to connect the inputs to the outputs of components
signal sig_c_rf, sig_c_alu, sig_c_m1, sig_c_m2, sig_c_m3, sig_c_m6, sig_c_m8, sig_c_m10, sig_c_m12, sig_c_m13, sig_c_sext9 :std_logic;
signal sig_c_m4, sig_c_m5, sig_c_m7, sig_c_m9, sig_c_m11: std_logic_vector(1 downto 0);
signal sig_c_T1, sig_c_T2, sig_c_T3, sig_c_IR, sig_c_PC, sig_c_C, sig_c_Z: std_logic;
signal sig_mem_dataout, sig_mem_addr, sig_mem_datain, sig_mem_datain2, sig_mem_addr2, sig_T1, sig_T2, sig_T3, sig_instr: std_logic_vector(15 downto 0);
signal sig_C, sig_Z, sig_mem_wr, sig_mem_wr2: std_logic;


begin

datapath_main: Datapath port map(clk => clk, rst => rst,

											c_rf => sig_c_rf, 
											c_alu => sig_c_alu, c_m1 => sig_c_m1, c_m2 => sig_c_m2, c_m3 => sig_c_m3, c_m6 => sig_c_m6, c_m8 => sig_c_m8,
											c_sext9 => sig_c_sext9, c_m10 => sig_c_m10, c_m12 => sig_c_m12, c_m13 => sig_c_m13, 
											c_m4 => sig_c_m4, c_m5 => sig_c_m5, c_m7 => sig_c_m7, c_m9 => sig_c_m9, c_m11 => sig_c_m11,
											c_T1 => sig_c_T1, c_T2 => sig_c_T2, c_T3 => sig_c_T3,
											c_IR => sig_c_IR, c_PC => sig_c_PC, c_C => sig_c_C, c_Z => sig_c_Z,
											
											mem_dataout => sig_mem_dataout,
											mem_addr => sig_mem_addr,
											mem_datain => sig_mem_datain,
											instruction => sig_instr,
											T1 => sig_T1, T2 => sig_T2, T3 => sig_T3,
											Cout => sig_C,
											Zout => sig_Z,
											----
											pco => pco
											);
											
FSM_main: FSM port map(		clk => clk, rst => rst,

									instruction => sig_instr,
									T1 => sig_T1, T2 => sig_T2, T3 => sig_T3,
									Cin => sig_C,
									Zin => sig_Z,
									
									c_rf => sig_c_rf, 
									c_alu => sig_c_alu, c_m1 => sig_c_m1, c_m2 => sig_c_m2, c_m3 => sig_c_m3, c_m6 => sig_c_m6, c_m8 => sig_c_m8,
									c_sext9 => sig_c_sext9, c_m10 => sig_c_m10, c_m12 => sig_c_m12, c_m13 => sig_c_m13,
									c_m4 => sig_c_m4, c_m5 => sig_c_m5, c_m7 => sig_c_m7, c_m9 => sig_c_m9, c_m11 => sig_c_m11,
									c_T1 => sig_c_T1, c_T2 => sig_c_T2, c_T3 => sig_c_T3,
									c_IR => sig_c_IR, c_PC => sig_c_PC, c_C => sig_c_C, c_Z => sig_c_Z,
									
									mem_wr => sig_mem_wr);

mux1: Mux16_2_1 port map(A => sig_mem_addr, B => ext_index, S0 => ext_wr, y => sig_mem_addr2);
mux2: Mux16_2_1 port map(A => sig_mem_datain, B => ext_data, S0 => ext_wr, y => sig_mem_datain2);
mux3: Mux1_2_1 port map(A => sig_mem_wr, B => ext_wr, S0 => ext_wr, y => sig_mem_wr2);

memory_main: Memory port map(clk => clk,
											wr => sig_mem_wr2,
											Addr_in => sig_mem_addr2,
											D_in => sig_mem_datain2, 
											D_out => sig_mem_dataout);

end behave;