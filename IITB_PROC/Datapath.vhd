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
		c_rf, c_alu, c_m1, c_m2, c_m3, c_m6, c_m8, c_m10, c_m12, c_sext9: in std_logic;
		c_m4, c_m5, c_m7, c_m9, c_m11: in std_logic_vector(1 downto 0); -- c_m2, c_m3 are not available as those muxes are not present as of now
		c_T1, c_T2, c_T3, c_IR, c_PC, c_C, c_Z: in std_logic;
		
		-- ins from memory
		mem_dataout: in std_logic_vector(15 downto 0);
		
		--outs to memory
		mem_addr, mem_datain: out std_logic_vector(15 downto 0);
		
		--outs to FSM
		instruction, T1, T2, T3: out std_logic_vector(15 downto 0);
		Cout, Zout: out std_logic;
		
		--outs for testing
		pco: out std_logic_vector(15 downto 0)
		
	);
end entity;

architecture struc of Datapath is
-----------components-------------
-- 1. ALU
component ALU is
	port(
		X, Y: in std_logic_vector(15 downto 0);
		op: in std_logic;
		--not complete(have to set nothing flag, also have to take C_in, Z_in input, to maintain states clk, rst too)
		C_out, Z_out: out std_logic;
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
		Y: out std_logic_vector(15 downto 0)
	);
end component;

-- 4. Sign Extender: input 6bits to 16 bits
component sext_6bit is --in the sext_6bit implementation rn, clk signal is not used, unlike sext_9bit where there is process statement on input variables
	port(
		X: in std_logic_vector(5 downto 0);
		Y: out std_logic_vector(15 downto 0)
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

-- 7. 3bit 2x1 Mux
component Mux3_2_1 is
	port( 
		A, B : in std_logic_vector(2 downto 0);
		S0 : in std_logic;
		y : out std_logic_vector(2 downto 0) 
	);
end component;

-- 8. 3bit 4x1Mux
component Mux3_4_1 is
	port( 
		A, B, C, D : in std_logic_vector(2 downto 0);
		S1, S0 : in std_logic;
		y : out std_logic_vector(2 downto 0) 
	);
end component;

--9. DFlipFlop
component DFlipFlop is
	port (
		clk, rst, wr, i: in std_logic;
		o: out std_logic
	);
end component;

-- 10. FF register
component dff_register is
	port(
		clk, rst, wr: in std_logic;
		i: in std_logic_vector(15 downto 0);
		o: out std_logic_vector(15 downto 0)
	);
end component;
 
--signals to connect the various components
signal m7out, m2out: std_logic_vector(2 downto 0);
signal aluout, t1out, t2out, t3out, pcin, pcout, rfd1, rfd2, m3out, m4out, m5out, m6out, m9out, m10out, m11out, m12out, se7out, se10out, instr: std_logic_vector(15 downto 0);
signal aluout_c, aluout_z: std_logic;

--constants
constant Z3: std_logic_vector(2 downto 0) := (others => '0');
constant Z16 :  std_logic_vector(15 downto 0) := (others => '0');
constant O16 :  std_logic_vector(15 downto 0) := (0 => '1', others => '0');

begin

--temporary registers
temp1: dff_register port map(clk => clk, rst => rst, wr => c_T1, i => m10out, o => t1out);
temp2: dff_register port map(clk => clk, rst => rst, wr => c_T2, i => m11out, o => t2out);
temp3: dff_register port map(clk => clk, rst => rst, wr => c_T3, i => m12out, o => t3out);

--instruction address and instruction register
PC: dff_register port map(clk => clk, rst => rst, wr => c_PC, i => pcin, o => pcout);
IR: dff_register port map(clk => clk, rst => rst, wr => c_IR, i => mem_dataout, o => instr);

-- CZ flag registers
C: DFlipFlop port map(clk => clk, rst => rst, wr => c_C, i => aluout_c, o => Cout);
Z: DFlipFlop port map(clk => clk, rst => rst, wr => c_Z, i => aluout_z, o => Zout);

-- main components
RF: RegisterFile port map( clk => clk, rst => rst, 
									wr => c_rf, 
									A1 => instr(11 downto 9), 
									A2 => m2out, 
									A3 => m7out, 
									Din => m9out, 
									Dout1 => rfd1, 
									Dout2 => rfd2); 

alu_main: ALU port map( X => m4out,
								Y => m5out,
								op => c_alu,
								C_out => aluout_c,
								Z_out => aluout_z,
								Z => aluout);

se7: sext_9bit port map( X => instr(8 downto 0),
								 s_type => c_sext9,
								 Y => se7out);

se10: sext_6bit port map( X => instr(5 downto 0),
								  Y => se10out);


--Muxes

-- M1. selecting the address for the memory
m1: Mux16_2_1 port map( A => pcout, B => aluout,
								S0 => c_m1,
								y => mem_addr);
								
-- M2. for selecting the second address to the register file								
m2: Mux3_2_1 port map( A => instr(8 downto 6), B => t2out(2 downto 0), 
							  S0 => c_m2, y => m2out);

--						  
m3: Mux16_2_1 port map( A => t1out, B => rfd2, 
								S0 => c_m3,
								y => mem_datain);

-- M4. for selecting input1 to the ALU
m4: Mux16_4_1 port map(A => t1out,
								B => t2out, 
								C => pcout, 
								D => Z16,
								S1 => c_m4(1),
								S0 => c_m4(0),
								y => m4out);

-- M5. for selecting input2 to the ALU								
m5: Mux16_4_1 port map(A => t2out,
								B => t3out, 
								C => O16, 
								D => Z16,
								S1 => c_m5(1),
								S0 => c_m5(0),
								y => m5out);

-- M6. for sign extended input to be stored in T3 depending on control c_m6								
m6: Mux16_2_1 port map(A => se7out,
								B => se10out,
								S0 => c_m6,
								y => m6out);
								

-- M7. assigning the datain address for the register file
m7: Mux3_4_1 port map( A => instr(11 downto 9),
							  B => instr(8 downto 6), 
							  C => instr(5 downto 3), 
							  D => t2out(2 downto 0), 
							  S1 => c_m7(1), 
						     S0 => c_m7(0), 
							  y => m7out);

-- M8. assigning PC with the new value
m8: Mux16_2_1 port map(A => aluout,
								B => t2out,
								S0 => c_m8,
								y => pcin);

-- M9. for selecting the datain for the register file
m9: Mux16_4_1 port map(A => t2out,
								B => t3out, 
								C => mem_dataout, 
								D => pcout,
								S1 => c_m9(1),
								S0 => c_m9(0),
								y => m9out);

-- M10, M11, M12 muxes to assign values to T1, T2, T3 for the next clock cycle
m10: Mux16_2_1 port map( A => aluout, B => rfd1,
								 S0 => c_m10,
								 y => m10out);
								 
m11: Mux16_4_1 port map( A => aluout, B => rfd2,
								 C => mem_dataout, D => Z16,
								 S0 => c_m11(0),
								 S1 => c_m11(1),
								 y => m11out);
								 
m12: Mux16_2_1 port map( A => aluout, B => m6out,
								 S0 => c_m12,
								 y => m12out);
								
instruction <= instr;
T1 <= t1out;
T2 <= t2out;
T3 <= t2out;

-- testing 
pco <= pcout;

end struc; 

