library work;
use work.all;

library IEEE;
use ieee.std_logic_1164.all;

entity PostProcess is 
port (I1, I2, I3: in std_logic_vector(7 downto 0);
		CIN: in std_logic;
		O1: out std_logic;
		O2: out std_logic_vector(7 downto 0));
end entity;

architecture arch of PostProcess is 
	
	signal flow, carry: std_logic_vector(7 downto 0);
	
	begin
	-- inputs are the values G(i,0), P(i,0), P(i, i) for all i
	-- ouputs sum and cout
	
	-- this part calculates carry as c(i+1) = G(i,0) + P(i,0),c(i)
	carry_calc0: for j in 0 to 7 generate
		flow(j) <= I2(j) and CIN;
	end generate;
	
	carry_calc1: for j in 0 to 6 generate
		carry(j+1) <= I1(j) or flow(j);
	end generate;

	O1 <= I1(7) or flow(7);

	-- this part calculates sum(i) = P(i,i) xor c(i)
	O2(0) <= I3(0) xor cin;	
	
	sum_calc: for j in 1 to 7 generate
		O2(j) <= I3(j) xor carry(j);
	end generate;
		
	
end arch;