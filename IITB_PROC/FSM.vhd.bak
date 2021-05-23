library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

entity FSM is 
	port(
		clk, rst: in std_logic;
		
		--ins from datapath
		instruction, T1, T2, T3: in std_logic_vector(15 downto 0);
		Cin, Zin: in std_logic;
	
		--outs to datapath
		c_rf, c_alu, c_m1, c_m2, c_m3, c_m6, c_m8, c_m10, c_m12, c_sext9: out std_logic;
		c_m4, c_m5, c_m7, c_m9, c_m11: out std_logic_vector(1 downto 0); -- c_m2, c_m3 are not available as those muxes are not present as of now
		c_T1, c_T2, c_T3, c_IR, c_PC, c_C, c_Z: out std_logic;
		
		--outs to memory
		mem_wr: out std_logic
	);
end entity;

architecture struc of FSM is 

-------components and signals------------
type FSMState is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13);
signal state: FSMState;

begin
-----------------------------
process(clk, rst, state, Cin, Zin, T1, T2, instruction) 
	variable next_state: FSMState;
	variable vop: std_logic_vector(3 downto 0);
	variable vc_m4, vc_m5, vc_m7, vc_m9, vc_m11: std_logic_vector(1 downto 0);
	variable vc_rf, vc_alu, vc_m1, vc_m2, vc_m3, vc_m6, vc_m8, vc_m10, vc_m12, vc_sext9,
				vc_T1, vc_T2, vc_T3, vc_IR, vc_PC, vc_C, vc_Z, vmem_wr: std_logic;
	
begin 
	vmem_wr 	:= '0';
	vc_rf 	:= '0';
	vc_alu 	:= '0';
	vc_T1		:= '0';
	vc_T2		:= '0';
	vc_T3		:= '0';
	vc_PC		:= '0';
	vc_IR		:= '0';
	vc_C		:= '0';
	vc_Z		:= '0';
	vc_m1		:= '0';
	vc_m2		:= '0';
	vc_m3		:= '0';
	vc_m4		:= "00";
	vc_m5		:= "00";
	vc_m6		:= '1';
	vc_m7		:= "00";
	vc_m8		:= '0';
	vc_m9		:= "00";
	vc_m10	:= '0';
	vc_m11	:= "11";
	vc_m12	:= '0';
	vc_sext9 := '0';
	vop := instruction(15 downto 12);
	next_state := S0;
	
case state is --  making cases for states 
 
--------------------------		    
	when S0 =>
			vmem_wr 	:= '0';
			vc_m1 	:= '0';
			vc_IR		:= '1';
			next_state := S1;
			
-----------------------------------				    
	when S1 =>
		   vop		:= instruction(15 downto 12);
			vc_T1 	:= '1';
			vc_T2		:= '1';
			vc_T3		:= '1';
			vc_m2 	:= '0';
			vc_m10	:= '1';
			vc_m11	:= "01";
			vc_m12	:= '1';
			
			if(vop="0000" or vop="0010" or vop="0001") then
				next_state := S5;
			elsif (vop="0011") then
				vc_m6 := '0';
				vc_sext9 := '1';
				next_state := S6;
			elsif (vop="0100") then
				next_state := S2;
			elsif (vop="0110") then
				vc_m11 := "11";
				next_state := S8;
			elsif (vop="0111") then
				vc_m11 := "11";
				next_state := S9;
			elsif (vop="1100") then
				next_state := S10;
			elsif(vop="1000" or vop="1001") then
				vc_rf := '1';
				vc_m7 := "00";
				vc_m9 := "11";
				next_state := S10;
			end if;
-----------------------------------		 
	when S5 =>
			if(vop="0000") then
				vc_m4 := "00";
				vc_m5 := "00";
				vc_m12 := '0';
				
				if(instruction(1)='1') then
					if(Cin = '1') then
						vc_C :='1';
						vc_Z := '1';
						vc_T3 := '1';
						next_state := S6;
					else
						next_state := S10;
					end if;
						
				elsif (instruction(0)='1') then
					if(Zin = '1') then
						vc_C :='1';
						vc_Z := '1';
						vc_T3 := '1';
						next_state := S6;
					else
						next_state := S10;
					end if;
				else
					vc_T3 := '1';
					vc_C := '1';
					vc_Z := '1';
					next_state := S6;
				end if;
			 
			elsif (vop="0001") then
				vc_m4 := "00";
				vc_m5 := "01";
				vc_m12 := '0';
				vc_C 	:= '1';
				vc_Z 	:= '1';
				vc_T3 := '1';
				next_state := S6;
			 
			elsif (vop="0010") then
				vc_alu := '1';
				vc_m4 := "00";
				vc_m5 := "00";
				vc_m12 := '0';
				
				if(instruction(1)='1') then
					if(Cin = '1') then
						vc_Z := '1';
						vc_T3 := '1';
						next_state := S6;
					else
						next_state := S10;
					end if;
						
				elsif (instruction(0)='1') then
					if(Zin = '1') then
						vc_Z := '1';
						vc_T3 := '1';
						next_state := S6;
					else
						next_state := S10;
					end if;
				else
					vc_Z := '1';
					vc_T3 := '1';
					next_state := S6;
				end if;
			end if;
-----------------------------------		
	when S2 =>
			if(vop="0100") then
				vc_m4 := "01";
				vc_m5 := "01";
				vc_m1 := '1';
				vc_T2 := '1';
				vc_m11 := "10";
				next_state := S6;
			end if;
--				c_d2 <= "00";  
--		      c_m2 <= '0';
--				if(op_v="0011") then
--					next_state := S4;
--				elsif (op_v="1000") then
--					next_state := S4;
--				elsif(op_v = "0110") then
--					next_state := S5;
--				elsif(op_v = "0111") then
--					c_m2 <= '1'; --!! add to datapath as well - m2 is connected to A2 in reg file, t2 has contents of treg(2 to 0) at 1 , t1 has contents of Ra at 0
--					next_state := S5;
--				end if;
-----------------------------------
	when S3 =>
			vmem_wr := '1';
			vc_m4 := "01";
			vc_m5 := "01";
			vc_m1 := '1';
			vc_m3 := '0';
			next_state := S10;
			
	when S4 => -- t2 += 1;
			if(T2(2 downto 0)="111") then
				next_state := S10;
			else
				vc_m4 := "01";
				vc_m5 := "10";
				vc_T2 := '1';
				vc_m11 := "00";
				if(vop = "0110") then
					next_state := S8;
				else 
					next_state := S9;
				end if;
			end if;
--			  if(op_v="0001" or op_v="0100" or op_v="0101") then
--					c_m6 <= '1';
--					next_state := S5;
--			  elsif (op_v="0011") then
--					c_m6 <= '0';
--					c_sext9 <= '1';
--					next_state := S6;
--			  elsif(op_v="1000") then
--					c_m6 <= '0';
--					c_sext9 <= '0';
--					next_state := S6;
--			  end if;
-----------------------------------
	when S6 =>
			 vc_rf := '1';
			 if(vop="0000" or vop="0010") then
					vc_m7 := "10";
					vc_m9 := "01";
					next_state := S10;
			 elsif(vop = "0001") then
					vc_m7 := "01";
					vc_m9 := "01";
					next_state := S10;
			 elsif(vop = "0011") then
					vc_m7 := "00";
					vc_m9 := "01";
					next_state := S10;
			 elsif(vop="0100") then
					vc_m7 := "00";
					vc_m9 := "00";
					next_state := S10;
			 end if;
-----------------------------------
--	when S7 => 
--			if(op_v="0100") then
--					vc_m1 := "01";
--					vc_d1 := "01";
--					next_state := S6;
--			if(op_v="0110") then
--					if(unsigned(t_reg) < 8) then
--						c_m1 <= "01";
--						c_d1 <= "01";
--						next_state := S6;
--					else
--						reset_treg <= '1';
--						next_state := S10;
--					end if;
--			end if;
-------------------------------------
	when S8 =>
			vc_rf := '1';
			vc_m4 := "00";
			vc_m5 := "00";
			vc_m1 := '1';
			vc_m9 := "10";
			next_state := S4;
--				if(op_v="0101") then
--					mem_wr <= '1';
--					c_m1 <= "01";
--					c_m3 <= '0'; --data in t1
--					next_state := S10;
--				elsif(op_v="0111") then
--					if(unsigned(t_reg) < 8) then
--						mem_wr <= '1';
--						c_m1 <= "01"; -- a_in = t4 
--						c_m3 <= '1'; --  d_in = t2 ---t2 should be connected to 1 of m3 , do this in datapath 
--						next_state := S9;
--					else
--						reset_treg <= '1';
--						next_state := S10;
--					end if;
--				end if;
-----------------------------------
	when S9 =>
			vc_m2 := '1';
			vc_m4 := "00";
			vc_m5 := "00";
			vmem_wr := '1';
			vc_m1 := '1';
			vc_m3 := '1'; 	
			next_state := S4;
--		 when S9 => -- update t_reg using some flipflop type of thing for LA
--			if(op_v="0110") then
--				alu_op <= '0'; -- added this line
--				c_m4 <= "11";
--				c_m5 <= "10"; --changed from 01 to 10 
--				c_d4 <= "01";
--				next_state:= S5; --changed from S7 to S5
--			elsif(op_v="0111") then
--				alu_op <= '0';
--				c_m4 <= "11"; --treg in
--				c_m5 <= "10"; -- 000000000000..1 in 
--				c_d4 <= "01"; -- treg out 
--				next_state:= S2; 
--			end if;
-----------------------------------
		 when S10 =>
				vc_m4 := "10";
				vc_PC := '1';
				if(vop="1100" and T1=T2) then
					vc_m5 := "01";
					vc_m8 := '0';
					next_state:=S0;
				elsif (vop="1000") then
					vc_m5 := "01";
					vc_m8 := '0';
					next_state := S0;
				elsif(vop="1001") then
					vc_m5 := "10";
					vc_m8 := '1';
				else	
					vc_m5 := "10";
					vc_m8 := '0';
					next_state := S0;
				end if;
-----------------------------------
		 when others =>  null;
end case;
	
	mem_wr 	<= vmem_wr;
	c_rf 		<= vc_rf;
	c_alu 	<= vc_alu;
	c_T1		<= vc_T1;
	c_T2		<= vc_T2;
	c_T3		<= vc_T3;
	c_PC		<= vc_PC;
	c_IR 		<= vc_IR;
	c_C		<= vc_C;
	c_Z		<= vc_Z;
	c_m1		<= vc_m1;
	c_m2		<= vc_m2;
	c_m3		<= vc_m3;
	c_m4		<= vc_m4;
	c_m5		<= vc_m5;
	c_m6		<= vc_m6;
	c_m7		<= vc_m7;
	c_m8		<= vc_m8;
	c_m9		<= vc_m9;
	c_m10		<= vc_m10;
	c_m11		<= vc_m11;
	c_m12		<= vc_m12;
	c_sext9 	<= vc_sext9;

	if(clk'event and clk = '0') then
		 if(rst = '1') then -- initially setting rst to 1 ensures that the state has a vaue for case analysis in the beginning 
			 state <= S0; 
		 else
			 state <= next_state; -- state transition based on case-wise logic in each clock cycle 
		 end if;
	end if;
end process;

end struc;
