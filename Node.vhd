library work;
use work.all;

library IEEE;
use ieee.std_logic_1164.all;

-- here we define a generic node in the graph
entity Node is 
port (g1, p1, g2, p2: in std_logic;
		gout, pout: out std_logic);
end entity;

architecture arch of Node is 
	
	signal flow: std_logic;
	
	begin
	
	-- ouputs gout = g1 + g2.p1
	flow <= p1 and g2;
	gout <= g1 or flow;
	
	-- ouputs pout = p1.p2
	pout <= p1 and p2;
	
end arch;


	
	