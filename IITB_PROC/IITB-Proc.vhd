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
		
	);
end component;

-- 2. FSM
component FSM is 
	port(
	
	);
end component;

--3. Memory 
component Memory is 
	port(
		clk, wr, rd: in std_logic;
		A_in, D_in: in std_logic_vector(15 downto 0);
		Dout: out std_logic_vector(15 downto 0)
	);
end component;



end behave;