library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity RegisterFile is 
	port( 
		A1,A2,A3: in std_logic_vector(2 downto 0);
		Din: in std_logic_vector(15 downto 0);
		  
		clk, rst, wr: in std_logic ; -- No separate control for PC required; simply drive 111 to A_
		Dout1, Dout2: out std_logic_vector(15 downto 0));
end entity;

architecture behave of RegisterFile is 
 
type RF is array(0 to 7) of std_logic_vector(15 downto 0);
signal registers: RF;

begin 
Dout1 <= registers(to_integer(unsigned(A1)));
Dout2 <= registers(to_integer(unsigned(A2)));

process (clk)
	begin 
		if((clk'event and clk = '0')) then
			if (rst = '1') then
				for i in 0 to 7 loop
					registers(i) <= "0000000000000000";
				end loop;
			elsif (wr = '1') then
				registers(to_integer(unsigned(A3))) <= Din;
			end if;
		end if;
end process;
		  
end behave;