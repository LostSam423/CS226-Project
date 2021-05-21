library ieee;
use ieee.std_logic_1164.all;
--library work;
--use work.Gates.all;

entity adder_16bit is
  port (A,B: in std_logic_vector(15 downto 0);car_in: in std_logic; car_out: out std_logic; sum: out std_logic_vector(15 downto 0));
end entity adder_16bit;

architecture Struct of adder_16bit is
  signal ti1, ti2,ti3,ti4,ti5,ti6,ti7,ti8,ti9,ti10,ti11,ti12,ti13,ti14,ti15: std_logic;

  component Full_Adder  is
  port (A, B, cin: in std_logic; sum, carry: out std_logic);
	end component Full_Adder;
	
begin
       
  -- component instances
       fa0: Full_Adder
       port map (A => A(0), B => B(0) , cin=>car_in, sum => sum(0), carry => ti1 );
       fa1: Full_Adder
       port map (A => A(1), B => B(1) , cin=> ti1, sum => sum(1), carry => ti2 );
       fa2: Full_Adder
       port map (A => A(2), B => B(2) , cin=> ti2, sum => sum(2), carry => ti3 );
		 fa3: Full_Adder
       port map (A => A(3), B => B(3) , cin=> ti3, sum => sum(3), carry => ti4 );
		 fa4: Full_Adder
       port map (A => A(4), B => B(4) , cin=> ti4, sum => sum(4), carry => ti5 );
		 fa5: Full_Adder
       port map (A => A(5), B => B(5) , cin=> ti5, sum => sum(5), carry => ti6 );
		 fa6: Full_Adder
       port map (A => A(6), B => B(6) , cin=> ti6, sum => sum(6), carry => ti7 );
		 fa7: Full_Adder
       port map (A => A(7), B => B(7) , cin=> ti7, sum => sum(7), carry => ti8 );
		 fa8: Full_Adder
       port map (A => A(8), B => B(8) , cin=> ti8, sum => sum(8), carry => ti9 );
		 fa9: Full_Adder
       port map (A => A(9), B => B(9) , cin=> ti9, sum => sum(9), carry => ti10 );
		 fa10: Full_Adder
       port map (A => A(10), B => B(10) , cin=> ti10, sum => sum(10), carry => ti11 );
		 fa11: Full_Adder
       port map (A => A(11), B => B(11) , cin=> ti11, sum => sum(11), carry => ti12 );
		 fa12: Full_Adder
       port map (A => A(12), B => B(12) , cin=> ti12, sum => sum(12), carry => ti13 );
		 fa13: Full_Adder
       port map (A => A(13), B => B(13) , cin=> ti13, sum => sum(13), carry => ti14 );
		 fa14: Full_Adder
       port map (A => A(14), B => B(14) , cin=> ti14, sum => sum(14), carry => ti15 );
		 fa15: Full_Adder
       port map (A => A(15), B => B(15) , cin=> ti15, sum => sum(15), carry => car_out );
  -- propagate carry.
end Struct;