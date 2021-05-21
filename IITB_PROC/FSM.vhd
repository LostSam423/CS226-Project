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
		instruction: in std_logic_vector(15 downto 0);
		C_val, Z_val: in std_logic;
		
		--outs to datapath
		cz_assign, rf_wr, alu_op, c_m6, c_m8, c_sext9: out std_logic:= '0';
		c_m1, c_m4, c_m5, c_m7, c_m9: out std_logic_vector(1 downto 0):= "00";-- c_m2, c_m3 are not available as those muxes are not present as of now
		c_d1, c_d2, c_d3, c_d4: out std_logic:='0';
		
		--outs to memory
		mem_wr, mem_rd: out std_logic:='0';
	);
end entity;

architecture struc of FSM is 
-------components and signals------------
type FSMState is (S_res, S0, S1, S2, S4, S5, S6, S7, S8, S10, S11, S12, S13);
signal state: FSMState;

-----------------------------
process(clk,state) 
	variable next_state: FSMState;
	variable last_state: FSMState;
begin 
case state is --  making cases for states 
       when S_res => -- this state resets all registers, memeory write and read flags and z,car flags
		 -- add logic
--------------------------		    
	    when S0 =>
			 mem_wr <= '0';
		    mem_rd <= '1';
			 rf_wr <= '0';
			 rf_rst <='0';
			 c_m1 <= "00";
			 c_d1 <= '0';
			 op_v := instruction(15 downto 12);
			 if(op_v="0110" or op_v="0011" or op_v="0111" or op_v="1000") then
				next_state:= S2;
			 else
			   next_state:= S1;
			 end if;			
-----------------------------------				    
	    when S1 =>
			 c_d2 <= '0';
			 c_d3 <= '0';
			 if(op_v="0001" or op_v="0011" or op_v="0100" or op_v="0101" or op_v="1100" or op_v="1000") then
				next_state:= S4;
			 else
			   next_state:= S5;
			 end if;			
-----------------------------------		 
	    when S5 =>
			 -- add cases for adc,add,adz,la,sa etc	
-----------------------------------		

	
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
