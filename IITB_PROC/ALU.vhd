library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
----------------------------------------------------------------------------------
entity ALU is 
	port( X,Y : in std_logic_vector(15 downto 0);
		op : in std_logic ;
		
		C_out, Z_out: out std_logic;
		Z : out std_logic_vector(15 downto 0));
end entity;
-----------------------------------------------------------------------------------
architecture behave of ALU is
	signal t1,t2: std_logic_vector(15 downto 0);
	signal car1, z1, z2: std_logic;

	component adder_16bit is
      port (A,B: in std_logic_vector(15 downto 0);car_in: in std_logic; car_out: out std_logic; sum: out std_logic_vector(15 downto 0));
   end component adder_16bit;

	component nand_op is
	   port(A,B: in std_logic_vector(15 downto 0);
		op: out std_logic_vector(15 downto 0));
   end component nand_op;
	
	component Mux16_2_1 is
	port( 
		A, B : in std_logic_vector(15 downto 0);
		S0 : in std_logic;
		y : out std_logic_vector(15 downto 0) 
	);
	end component; 
	
	component Mux1_2_1 is
	port( 
		A, B, S0 : in std_logic;
		y : out std_logic
	);
	end component;

begin
	p_1: adder_16bit port map (A => X, B => Y, sum => t1, car_in => '0', car_out => car1);
	p_2: nand_op port map (A => X, B => Y, op => t2);
	mux1: Mux16_2_1 port map (A => t1, B => t2, S0 => op, y => Z);
	mux2: Mux1_2_1 port map(A => car1, B => '0', S0 => op, y => C_out);
	
	z1 <= not (t1(0) or t1(1) or t1(2) or t1(3) or t1(4) or t1(5) or t1(6) or t1(7) or t1(8) or t1(9) or t1(10) or t1(11) or t1(12) or t1(13) or t1(14) or t1(15));
	z2 <= not (t2(0) or t2(1) or t2(2) or t2(3) or t2(4) or t2(5) or t2(6) or t2(7) or t2(8) or t2(9) or t2(10) or t2(11) or t2(12) or t2(13) or t2(14) or t2(15));
	
	mux3: Mux1_2_1 port map(A => z1, B => z2, S0 => op, y => Z_out);
end behave;