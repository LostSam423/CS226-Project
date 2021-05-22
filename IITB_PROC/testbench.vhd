library work;
use work.all;

library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is  --- testbench entity definition
end testbench;

architecture tb of testbench is
	signal clock : std_logic := '0';
	signal reset : std_logic := '1';
	signal output : std_logic_vector(3 downto 0);
	
	component IITB_PROC is -- component specifications
		port (
			clk,rst     : in  std_logic;
			op : out std_logic_vector(3 downto 0));
	end component;
	

begin
	--Connecting test bench signals with IITB_PROC.vhd
	test_instance: IITB_PROC
		port map (clk => clock, rst => reset, op => output);

	
    clock <= NOT clock AFTER 5 NS;

    reset <= '1', 
            '0' AFTER 20 NS;
	
end tb;
