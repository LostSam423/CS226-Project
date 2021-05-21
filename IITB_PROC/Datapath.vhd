library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity Datapath is
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
end entity;

architecture struc of Datapath is
-----------components-------------
-- 1. ALU
component ALU is
	port(
		X, Y: in std_logic_vector(15 downto 0);
		op, nothing: in std_logic;
		--not complete(have to set nothing flag, also have to take C_in, Z_in input, to maintain states clk, rst too)
		Cout, Zout: out std_logic;
		Z: out std_logic_vector(15 downto 0)
	);
end component;

-- 2. RegisterFile
component RegisterFile is
	port(
		A1,A2,A3: in std_logic_vector(2 downto 0);
		Din: in std_logic_vector(15 downto 0);
		  
		clk, rst, wr: in std_logic ;
		Dout1, Dout2: out std_logic_vector(15 downto 0)
	);
end component;

-- 3. Sign Extender: input 9bits to 16 bits
component sext_9bit is
	port(
		X: in std_logic_vector(8 downto 0);
		s_type: in std_logic;
		Y: out std_logic_vector(15 downto 0));
	);
end component;

-- 4. Sign Extender: input 6bits to 16 bits
component sext_6bit is --in the sext_6bit implementation rn, clk signal is not used, unlike sext_9bit where there is process statement on input variables
	port(
		X: in std_logic_vector(5 downto 0);
		Y: out std_logic_vector(15 downto 0));
	);
end component;

-- 5. 16bit 2x1Mux
component Mux16_2_1 is
	port( 
		A, B : in std_logic_vector(15 downto 0);
		S0 : in std_logic;
		y : out std_logic_vector(15 downto 0) 
	);
end component;

-- 6. 16bit 4x1Mux
component Mux16_4_1 is
	port( 
		A, B, C, D : in std_logic_vector(15 downto 0);
		S1, S0 : in std_logic;
		y : out std_logic_vector(15 downto 0) 
	);
end component;



	
end struc; 