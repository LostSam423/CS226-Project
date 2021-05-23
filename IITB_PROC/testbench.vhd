library work;
use work.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity testbench is  --- testbench entity definition
end testbench;

architecture tb of testbench is
	signal clock, wr: std_logic := '0';
	signal reset : std_logic := '1';
	signal pc, idx, data: std_logic_vector(15 downto 0);
	
	component IITB_PROC is -- component specifications
		port (
			clk,rst : in  std_logic;
			ext_wr: in std_logic;
			ext_data, ext_index: in std_logic_vector(15 downto 0);
			pco : out std_logic_vector(15 downto 0));
	end component;
	

begin
	--Connecting test bench signals with IITB_PROC.vhd
	test_instance: IITB_PROC
		port map (clk => clock, rst => reset,
						ext_wr => wr, ext_data => data,
						ext_index => idx,
						pco => pc);
	 
	 process
		file in_file : text open read_mode is "D:\IITB CSE\sem4\CS 226\Project\IITB_PROC\bin.txt";
		variable in_line : line;
		variable in_var : std_logic_vector(15 downto 0);
	 begin
	 
		idx <= "0000000000000000";
		
		-- load instructions in the memory
		while not endfile(in_file) loop
			readline (in_file, in_line);
			read (in_line, in_var);
			reset <= '1';
			clock <= '1';
			data <= in_var;
			wr <= '1';
			wait for 100 ns;
			clock <= '0';
			wait for 100 ns;
			idx <= std_logic_vector (unsigned(idx)+1);
		end loop;
		
		-- execute instructions
		reset <= '1';
		wr <= '0';
		clock <= '1';
		wait for 100 ns;
		clock <= '0';
		wait for 100 ns;
		
		reset <= '0';
		
		while 1=1 loop
				clock <= '0';
				wait for 100 ns;
				clock <= '1';
				wait for 100 ns;
		end loop;
	 end process;
	 
end tb;
