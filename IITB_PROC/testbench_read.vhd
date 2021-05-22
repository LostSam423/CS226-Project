library work;
use work.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity testbench_read is  --- testbench entity definition
end testbench_read;

architecture tb of testbench_read is
	signal clock : std_logic := '0';
	signal reset : std_logic := '1';
	signal output : std_logic_vector(3 downto 0);
	signal wr_sig : std_logic :='1';
	signal rd_sig : std_logic:= '0';
	signal A_in_sig,D_in_sig,D_out_sig : std_logic_vector(15 downto 0) := (others => '0');
	
	
	component IITB_PROC is -- component specifications
		port (
			clk,rst     : in  std_logic;
			op : out std_logic_vector(3 downto 0));
	end component;
	
	component Memory is 
		port(
			clk: std_logic; 
			wr, rd: in std_logic;
			Addr_in, D_in: in std_logic_vector(15 downto 0);
			D_out: out std_logic_vector(15 downto 0)
		);
	end component;
	
begin
	--Connecting test bench signals with IITB_PROC.vhd
	test_instance: IITB_PROC
		port map (clk => clock, rst => reset, op => output);
	mem_instance: Memory
		port map (clk => clock, wr => wr_sig, rd => rd_sig, Addr_in => A_in_sig, D_in => D_in_sig, D_out => D_out_sig);
		
		process 
		file in_file : text open read_mode is "add file path here";
		variable in_line : line;
		variable in_var : std_logic_vector(15 downto 0);
		variable count : integer range 0 to 32;
		variable curr : integer range 0 to 32;
		
		begin
			count := 0;
			curr := 0;
			A_in_sig <= "0000000000000000";
			
			-- load instructions in memory
			while not endfile(in_file) loop
				readline (in_file, in_line);
				read (in_line, in_var);
				reset <= '1';
				clock <= '1';
				D_in_sig <= in_var;
				wr_sig <= '1';
				wait for 100 ns;
				clock <= '0';
				wait for 100 ns;
				A_in_sig <= std_logic_vector ( unsigned(A_in_sig) + 1);
				count := count + 1;
			end loop;
			
			-- execute instructions
			reset <= '1';
			wr_sig <= '0';
			clock <= '1';
			wait for 100 ns;
			clock <= '0';
			wait for 100 ns;
	
			reset <= '0';
			while curr < count+1 loop
				clock <= '1';
				wait for 100 ns;
				clock <= '0';
				wait for 100 ns;
				curr := curr + 1;	
			end loop;
	wait;
	end process;
	
end tb;
