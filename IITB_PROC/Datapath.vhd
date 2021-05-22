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
		c_assign, z_assign, rf_wr, alu_op, c_m2, c_m3, c_m6, c_m8, c_sext9, reset_treg: in std_logic;
		c_m1, c_m4, c_m5, c_m7, c_m9: in std_logic_vector(1 downto 0); -- c_m2, c_m3 are not available as those muxes are not present as of now
		c_d1, c_d2, c_d3, c_d4: in std_logic_vector(1 downto 0);
		
		-- ins from memory
		mem_dataout: in std_logic_vector(15 downto 0);
		
		--outs to memory
		mem_addr, mem_datain: out std_logic_vector(15 downto 0);
		
		--outs to FSM
		instruction, ra, rb, t_reg: out std_logic_vector(15 downto 0);
		C_val, Z_val: out std_logic
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

-- 9. 16bit 1x4 Demux
component DeMux16_1_4 is 
	port(
		A: in std_logic_vector(15 downto 0);
		S1, S0: in std_logic;
		O0, O1, O2, O3: out std_logic_vector(15 downto 0)
	);
end component;

-- 10. 1bit 1x2 Demux
component DeMux1_1_2 is
	port(
		A, S: in std_logic;
		O0, O1: out std_logic
	);
end component;

-- 11. FF register
component ff_register is
	port(
		clk, rst: in std_logic;
		d: in std_logic_vector(15 downto 0);
		s: out std_logic_vector(15 downto 0)
	);
end component;

-- temporary registers
signal t1, t2, t3, t4, t5, gbg16: std_logic_vector(15 downto 0);
signal pc: std_logic_vector(15 downto 0) := (others => '0');
signal instr : std_logic_vector(15 downto 0); -- initialise to "0" on reset
signal C, Z, gbg1: std_logic; -- initialise to "0" on reset
signal t_reg2, t_regc: std_logic_vector(15 downto 0); -- initialise to "000000000.." on reset
 
--signals to connect the various components
signal m7out, m2out: std_logic_vector(2 downto 0);
signal m3out, m4out, m5out, m9out, d2in, d3in, d4in, se7out, se10out: std_logic_vector(15 downto 0);
signal alu_c, alu_z: std_logic;

--constants
constant Z3: std_logic_vector(2 downto 0) := (others => '0');
constant Z16 :  std_logic_vector(15 downto 0) := (others => '0');
constant O16 :  std_logic_vector(15 downto 0) := (0 => '1', others => '0');

begin


-- main components
RF: RegisterFile port map(clk => clk, 
									rst => rst, 
									wr => rf_wr, 
									A1 => instr(11 downto 9), 
									A2 => m2out, 
									A3 => m7out, 
									Din => m9out, 
									Dout1 => d2in, 
									Dout2 => d3in); 

alu_main: ALU port map(X => m4out,
								Y => m5out,
								op => alu_op,
								C_out => alu_c,
								Z_out => alu_z,
								Z => d4in);

se7: sext_9bit port map(X => instr(8 downto 0),
								s_type => c_sext9,
								Y => se7out);

se10: sext_6bit port map(X => instr(5 downto 0),
									Y => se10out);

									
ffr: ff_register port map(clk=>clk, rst => reset_treg, d=> t_reg2, s=> t_regc);
--Muxes
m1: Mux16_4_1 port map(A => pc,
								B => t4, 
								C => t1, 
								D => Z16,
								S1 => c_m1(1),
								S0 => c_m1(0),
								y => mem_addr);
								
m2: Mux3_2_1 port map(A => instr(8 downto 6),
								B => t_regc(2 downto 0), 
								S0 => c_m2,
								y => m2out);
								
m3: Mux16_2_1 port map(A => t1,
								B => t2, 
								S0 => c_m3,
								y => m3out);

m4: Mux16_4_1 port map(A => t1,
								B => t2, 
								C => pc, 
								D => t_regc,
								S1 => c_m4(1),
								S0 => c_m4(0),
								y => m4out);
								
m5: Mux16_4_1 port map(A => t2,
								B => t3, 
								C => O16, 
								D => Z16,
								S1 => c_m5(1),
								S0 => c_m5(0),
								y => m5out);

-- for sign extended input to be stored in t3 depending on control c_m6								
m6: Mux16_2_1 port map(A => se7out,
								B => se10out,
								S0 => c_m6,
								y => t3);
								


m7: Mux3_4_1 port map(A => instr(11 downto 9),
								B => instr(8 downto 6), 
								C => instr(5 downto 3), 
								D => t_regc(2 downto 0), 
								S1 => c_m7(1), 
								S0 => c_m7(0), 
								y => m7out);

-- assigning PC with the new value
m8: Mux16_2_1 port map(A => t4,
								B => t2,
								S0 => c_m8,
								y => pc);


m9: Mux16_4_1 port map(A => t3,
								B => t4, 
								C => t5, 
								D => pc,
								S1 => c_m9(1),
								S0 => c_m9(0),
								y => m9out);

--Demuxes
d1: DeMux16_1_4 port map(A => mem_dataout,
									S1 => c_d1(1),
									S0 => c_d1(1),
									O0 => instr,
									O1 => t5,
									O2 => gbg16,
									O3 => gbg16);
									

d2: DeMux16_1_4 port map(A => d2in, 
									S1 => c_d2(1),
									S0 => c_d2(0),
									O0 => t1,
									O1 => gbg16,
									O2 => gbg16,
									O3 => gbg16);
									
d3: DeMux16_1_4 port map(A => d3in,
									S1 => c_d3(1),
									S0 => c_d3(0),
									O0 => t2,
									O1 => gbg16,
									O2 => gbg16,
									O3 => gbg16);
									

d4: DeMux16_1_4 port map(A => d4in,
									S1 => c_d4(1),
									S0 => c_d4(0),
									O0 => t4,
									O1 => t_reg2,
									O2 => gbg16,
									O3 => gbg16);

-- modifying the C flag
d5: DeMux1_1_2 port map(A => alu_c, 
								S => c_assign,
								O0 => gbg1,
								O1 => C);
								
-- modifying the Z flag
d6: DeMux1_1_2 port map(A => alu_z, 
								S => z_assign,
								O0 => gbg1, -- garbage
								O1 => Z);

			
--have to set default value, after setting the reset becomes 1			
--process(rst, clk)
--begin
--		if(rst = '1') then
--			pc <= Z16;
--		end if;
--end process;

t_reg <= t_regc;
ra <= t1;
rb <= t2;
mem_datain <= m3out;
C_val <= C;
Z_val <= Z;
instruction <= instr;
								
end struc; 

