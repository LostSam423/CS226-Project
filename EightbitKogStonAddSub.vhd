library work;
use work.all;

library IEEE;
use ieee.std_logic_1164.all;

entity EightbitKogStonAddSub is
port (a,b: in std_logic_vector(7 downto 0);
		cin: in std_logic;
		sum: out std_logic_vector(7 downto 0);
		cout: out std_logic);
end entity;

architecture arch of EightbitKogStonAddSub is
	
	-- defining 2D arrays G and P
	type G_mem is array(7 downto 0, 7 downto 0) of std_logic;
	signal G: G_mem;
	
	type P_mem is array(7 downto 0, 7 downto 0) of std_logic;
	signal P: P_mem;
	
	-- storing intermediate signals
	signal flow1, flow2, flowP, flowG: std_logic_vector(7 downto 0);
	
	component Node
		port(g1, p1, g2, p2: in std_logic; gout, pout: out std_logic);
	end component;	
	
	component PreProcess
		port(Cin: in std_logic; I1, I2: in std_logic_vector(7 downto 0); O1, O2: out std_logic_vector(7 downto 0));
	end component;	
	
	component PostProcess
		port(I1, I2, I3: in std_logic_vector(7 downto 0); CIN: in std_logic; O1: out std_logic; O2: out std_logic_vector(7 downto 0));
	end component;
	
	begin
	
	-- pre processing
		-- this is the preprocess step that is needed before the optimisation step
		-- here, we deal with xoring b (for add/sub) and store G and P arrays initial values
	pre_process: PreProcess port map(Cin => cin, I1 => a, I2 => b , O1 => flow1, O2 => flow2);
	
	G(0,0) <= flow1(0); P(0,0) <= flow2(0);
	G(1,1) <= flow1(1); P(1,1) <= flow2(1);
	G(2,2) <= flow1(2); P(2,2) <= flow2(2);
	G(3,3) <= flow1(3); P(3,3) <= flow2(3);
	G(4,4) <= flow1(4); P(4,4) <= flow2(4);
	G(5,5) <= flow1(5); P(5,5) <= flow2(5);
	G(6,6) <= flow1(6); P(6,6) <= flow2(6);
	G(7,7) <= flow1(7); P(7,7) <= flow2(7);
	
-- first level prefix computation (defining appropriate nodes at each level, total log8 = 3 levels)	
	
	-- first level of the optimisation 
	level0: for i in 1 to 7 generate
		NodeInst0: Node port map (	g1 => G(i,i), 
											p1 => P(i,i), 
											g2 => G(i-1, i-1), 
											p2 => P(i-1, i-1),
											gout => G(i, i-1),
											pout => P(i, i-1));
	end generate;

	-- second level
	level1_NodeInst: Node port map (	g1 => G(2,1), 
										p1 => P(2,1), 
										g2 => G(0,0), 
										p2 => P(0,0),
										gout => G(2,0),
										pout => P(2,0));
	
	level1: for i in 3 to 7 generate
		NodeInst2: Node port map (	g1 => G(i,i-1), 
											p1 => P(i,i-1), 
											g2 => G(i-2, i-3), 
											p2 => P(i-2, i-3),
											gout => G(i, i-3),
											pout => P(i, i-3));
	end generate;
	
	-- third level
	level2: for i in 4 to 7 generate
		NodeInst3: Node port map (	g1 => G(i,i-3), 
											p1 => P(i,i-3), 
											g2 => G(i-4,0), 
											p2 => P(i-4,0),
											gout => G(i,0),
											pout => P(i,0));
	end generate;
		
	-- post processing
		-- here we extract the sum and carry bits from the 2D arrays
	
	flowG(0) <= G(0,0); flowP(0) <= P(0,0);
	flowG(1) <= G(1,0); flowP(1) <= P(1,0);
	flowG(2) <= G(2,0); flowP(2) <= P(2,0);
	flowG(3) <= G(3,0); flowP(3) <= P(3,0);
	flowG(4) <= G(4,0); flowP(4) <= P(4,0);
	flowG(5) <= G(5,0); flowP(5) <= P(5,0);
	flowG(6) <= G(6,0); flowP(6) <= P(6,0);
	flowG(7) <= G(7,0); flowP(7) <= P(7,0);
	
	post_process: PostProcess port map(I1 => flowG, I2 => flowP, I3 => flow2, CIN => cin, O1 => cout, O2 => sum);
		
end arch;
		