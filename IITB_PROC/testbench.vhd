library work;
use work.all;

library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is  --- testbench entity definition
end testbench;

architecture tb of testbench is
	signal clock : std_logic := '0';
	signal reset : std_logic := '1';
	signal pc : std_logic_vector(15 downto 0);
	
	component IITB_PROC is -- component specifications
		port (
			clk,rst     : in  std_logic;
			pco : out std_logic_vector(15 downto 0));
	end component;
	

begin
	--Connecting test bench signals with IITB_PROC.vhd
	test_instance: IITB_PROC
		port map (clk => clock, rst => reset, pco => pc);

	
    clock <= NOT clock AFTER 100 NS;
	 
	 process
	 begin
	 
		reset <= '1';
		wait for 80 ns;
		reset <= '0';
		
	 end process;
	 
end tb;
