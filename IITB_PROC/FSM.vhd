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
		instruction, ra, rb, t_reg: in std_logic_vector(15 downto 0);
		C_val, Z_val: in std_logic;
	
		--outs to datapath
		c_assign, z_assign, rf_wr, alu_op, c_m2, c_m3, c_m6, c_m8, c_sext9, reset_treg: out std_logic:= '0';
		c_m1, c_m4, c_m5, c_m7, c_m9: out std_logic_vector(1 downto 0):= "00";-- c_m2, c_m3 are not available as those muxes are not present as of now
		c_d1, c_d2, c_d3, c_d4: out std_logic_vector(1 downto 0);
		
		--outs to memory
		mem_wr, mem_rd: out std_logic:='0'
	);
end entity;

architecture struc of FSM is 

-------components and signals------------
type FSMState is (S_res, S0, S1, S2, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13);
signal state: FSMState;

begin
-----------------------------
process(clk,state) 
	variable next_state: FSMState;
	variable last_state: FSMState;
	variable op_v: std_logic_vector(3 downto 0);
	variable ra_v, rb_v: std_logic_vector(15 downto 0);
	
begin 
case state is --  making cases for states 
       when S_res => -- this state resets all registers, memory write and read flags and z,car flags
		 -- add logic
--------------------------		    
		 when S0 =>
			 mem_wr <= '0';
		    mem_rd <= '1';
			 rf_wr <= '0';
			 c_m1 <= "00";
			 c_d1 <= "00";
			 op_v := instruction(15 downto 12);
			 if(op_v="0110" or op_v="0011" or op_v="0111" or op_v="1000") then
				next_state:= S2;
			 else
			   next_state:= S1;
			 end if;			
-----------------------------------				    
	    when S1 =>
			 c_d2 <= "00";
			 c_d3 <= "00";
		         c_m2 <= '0';
			 if(op_v="0001" or op_v="0011" or op_v="0100" or op_v="0101" or op_v="1100" or op_v="1000") then
				next_state:= S4;
			 elsif (op_v ="1100") then
				next_state := S10;
			 elsif(op_v="1001") then
				next_state := S6;
			 else
			   next_state:= S5;
			 end if;			
-----------------------------------		 
	    when S5 =>
			if(op_v="0000") then
				alu_op <= '0';
				c_m4 <= "00";
				c_m5 <= "00";
				if(op_v(1)='1') then
					if(C_val = '1') then
						c_assign <='1';
						z_assign <= '1';
						c_d4 <= "00";
						next_state := S6;
					else
						c_assign <= '0';
						z_assign <= '0';
						c_d4 <= "10";
						next_state := S10;
					end if;
						
				elsif (op_v(0)='1') then
					if(Z_val = '1') then
						c_assign <='1';
						z_assign <= '1';
						c_d4 <= "00";
						next_state := S6;
					else
						c_assign <= '0';
						z_assign <= '0';
						c_d4 <= "10";
						next_state := S10;
					end if;
				else
					c_d4 <= "00";
					c_assign <= '1';
					z_assign <= '1';
					next_state := S6;
				end if;
			 
			 elsif (op_v="0001") then
				alu_op <= '0';
				c_m4 <= "00";
				c_m5 <= "01";
				c_assign <= '1';
				z_assign <= '1';
				next_state := S6;
			 
			 elsif (op_v="0010") then
				alu_op <= '1';
				c_m4 <= "00";
				c_m5 <= "00";
				if(op_v(1)='1') then
					if(C_val = '1') then
						z_assign <= '1';
						c_d4 <= "00";
						next_state := S6;
					else
						z_assign <= '0';
						c_d4 <= "10";
						next_state := S10;
					end if;
						
				elsif (op_v(0)='1') then
					if(Z_val = '1') then
						z_assign <= '1';
						c_d4 <= "00";
						next_state := S6;
					else
						z_assign <= '0';
						c_d4 <= "10";
						next_state := S10;
					end if;
				else
					c_d4 <= "00";
					z_assign <= '1';
					next_state := S6;
				end if;
			 elsif (op_v="0100") then --LW
					alu_op <= '0';
					c_m4 <= "01";
					c_m5 <= "01";
					c_d4 <= "00";
					next_state := S7;
			 elsif (op_v="0101") then -- SW
					alu_op <= '0';
					c_m4 <= "01";
					c_m5 <= "01";
					c_d4 <= "00";
					next_state := S8;
			 elsif (op_v="0110") then
					alu_op <= '0'; -- add
					c_m4 <= "00"; -- t1 in
					c_m5 <= "11"; -- treg in
					c_d4 <= "00"; --t4 out
					next_state := S7;
			 elsif (op_v="0111") then
					alu_op <= '0'; -- add
					c_m4 <= "00"; -- t1 in
					c_m5 <= "11"; --treg in 
					c_d4 <= "00"; --t4 out
					next_state := S8;
			 end if;
			 -- add cases for adc,add,adz,la,sa etc	
-----------------------------------		
		 when S2 =>
				c_d2 <= "00";  
		                c_m2 <= '0';
				if(op_v="0011") then
					next_state := S4;
				elsif (op_v="1000") then
					next_state := S4;
				elsif(op_v = "0110") then
					next_state := S5;
				elsif(op_v = "0111") then
					c_m2 <= '1'; --!! add to datapath as well - m2 is connected to A2 in reg file, t2 has contents of treg(2 to 0) at 1 , t1 has contents of Ra at 0
					next_state := S5;
				end if;
-----------------------------------
		 when S4 =>
			  if(op_v="0001" or op_v="0100" or op_v="0101") then
					c_m6 <= '1';
					next_state := S5;
			  elsif (op_v="0011") then
					c_m6 <= '0';
					c_sext9 <= '1';
					next_state := S6;
			  elsif(op_v="1000") then
					c_m6 <= '0';
					c_sext9 <= '0';
					next_state := S6;
			  end if;
-----------------------------------
		 when S6 =>
			 c_assign <= '0';
			 z_assign <= '0';
			 mem_rd <= '0';
			 rf_wr <= '1';
			 if(op_v = "0000") then
					c_m7 <= "10";
					c_m9 <= "01";
					next_state := S10;
			 elsif(op_v = "0001") then
					c_m7 <= "01";
					c_m9 <= "01";
					next_state := S10;
			 elsif(op_v = "0011") then
					c_m7 <= "00";
					c_m9 <= "00";
					next_state := S10;
			 elsif(op_v="0100") then
					c_m7 <= "00";
					c_m9 <= "10";
					next_state := S10;
			 elsif(op_v="1000") then
					c_m7 <= "00";
					c_m9 <= "11";
					next_state := S10;
			 elsif(op_v="1001") then
					c_m7 <= "00";
					c_m9 <= "11";
					next_state := S11;
			 elsif(op_v="0110") then
					c_m7 <= "11";
					c_m9 <= "10";
					next_state := S9;
			 end if;
-----------------------------------
		 when S7 => 
				mem_rd <= '1';
				if(op_v="0100") then
					c_m1 <= "01";
					c_d1 <= "01";
					next_state := S6;
				elsif(op_v="0110") then
					if(unsigned(t_reg) < 8) then
						c_m1 <= "01";
						c_d1 <= "01";
						next_state := S6;
					else
						reset_treg <= '1';
						next_state := S10;
					end if;
				end if;
-----------------------------------
		 when S8 =>
				if(op_v="0101") then
					mem_wr <= '1';
					c_m1 <= "01";
					c_m3 <= '0'; --data in t1
					next_state := S10;
				elsif(op_v="0111") then
					if(unsigned(t_reg) < 8) then
						mem_wr <= '1';
						c_m1 <= "01"; -- a_in = t4 
						c_m3 <= '1'; --  d_in = t2 ---t2 should be connected to 1 of m3 , do this in datapath 
						next_state := S9;
					else
						reset_treg <= '1';
						next_state := S10;
					end if;
				end if;
-----------------------------------
		 when S9 => -- update t_reg using some flipflop type of thing for LA
			if(op_v="0110") then
				alu_op <= '0'; -- added this line
				c_m4 <= "11";
				c_m5 <= "10"; --changed from 01 to 10 
				c_d4 <= "01";
				next_state:= S5; --changed from S7 to S5
			elsif(op_v="0111") then
				alu_op <= '0';
				c_m4 <= "11"; --treg in
				c_m5 <= "10"; -- 000000000000..1 in 
				c_d4 <= "01"; -- treg out 
				next_state:= S2; 
			end if;
-----------------------------------
		 when S10 =>
				rf_wr <= '0';
				mem_wr <= '0';
				mem_rd <= '0';
				reset_treg <= '0';
				c_m4 <= "10";
				c_d4 <= "00";
				if(op_v="1100" and ra_v=rb_v) then
					c_m5 <= "01";
					next_state:=S11;
				elsif (op_v="1000") then
					c_m5 <= "01";
					next_state := S11;
				else	
					c_m5 <= "10";
					next_state := S11;
				end if;
-----------------------------------
		 when S11 => 
				if(op_v="1001") then
					c_m8 <= '0';
					next_state := S0;
				else 
					c_m8 <= '1';
					next_state := S0;
				end if;
-----------------------------------
		 when others => null;
	end case;
		
if(clk'event and clk = '0') then
          if(rst = '1') then -- initially setting rst to 1 ensures that the state has a vaue for case analysis in the beginning 
             state <= S_res; 
          else
				 last_state := state; -- !!check this!!
             state <= next_state; -- state transition based on case-wise logic in each clock cycle 
          end if;
     end if;
end process;

end struc;
