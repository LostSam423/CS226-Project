library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 


entity IITB_PROC is
  port (
    clk,rst     : in  std_logic; -- inputs - control state transitions
	 op : out std_logic_vector(3 downto 0)); -- does not seem like this is even being assigned anywhere 
end entity;

architecture behave of IITB_PROC is
---------------------------------------------------------------------------------------------------components
component ALU is 
	port( X,Y : in std_logic_vector(15 downto 0);
		s_type : in std_logic ;
		C_out, Z_out: out std_logic;
		Z : out std_logic_vector(15 downto 0));
end component ALU;

component se7 is
port (X: in std_logic_vector(8 downto 0);
s_type: in std_logic;
Y: out std_logic_vector(15 downto 0));
end component se7;

component se10 is
port (X: in std_logic_vector(5 downto 0);
Y: out std_logic_vector(15 downto 0));
end component se10;

component memory is 
	port ( wr,rd,clk : in std_logic; 
			Addr_in, D_in: in std_logic_vector(15 downto 0);
			D_out: out std_logic_vector(15 downto 0)); 
end component memory; 

component rf is 
	port( A1,A2,A3 : in std_logic_vector(2 downto 0);
		  D3, D_PC: in std_logic_vector(15 downto 0);
		  
		clk,wr,pc_wr, reset: in std_logic ; 
		D1, D2: out std_logic_vector(15 downto 0));
end component rf;

----------------------------------------------------------------------------------------------------------------------------------------

type FSMState is (S_res, S_next, S0, S_read_ab, S_read_a, S_alu, S_write, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S_jump, S21);
signal state: FSMState;
signal t1, t2, t3, t4 :std_logic_vector(15 downto 0):="0000000000000000"; -- temporary storages to read in from registers and memory 
signal ir :std_logic_vector(15 downto 0):="0000000000000000"; -- instruction register stores only the correct instruction 
signal se7_out,se10_out :std_logic_vector(15 downto 0):="0000000000000000"; -- 16 bit output of signed extenders 
signal mem_add, mem_din, mem_dout :std_logic_vector(15 downto 0):="0000000000000000"; -- inputs and outputs of memory read/write 
signal alu_x, alu_y, alu_out :std_logic_vector(15 downto 0):="0000000000000000"; -- inputs and outputs of ALU unit 
signal rD3, rD_PC, rD1, rD2 :std_logic_vector(15 downto 0):="0000000000000000";  -- data in register files at addresses A3, A_PC, A1, A2 respectively 
signal mem_rd, mem_wr :std_logic:='0'; -- read/write controller inputs to memory component 
signal se7_type :std_logic:='0'; --  captures if l appended bits should be 0 or it should be a signed extender 
signal alu_op :std_logic:='0'; -- input for ALU which decides arithemtic operation to be performed - NAND/SUM 
signal car_out, z_out : std_logic:='0'; -- outputs of ALU unit 
signal zero_out -- seems like it is unused 
signal carry, zero :std_logic:='0'; -- flags of the main file 
signal rwr, rwr, rf_rst :std_logic:='0'; -- inputs to register file component 
signal se7_in : std_logic_vector(8 downto 0); -- 9 bit input to be extended to 16 bits by 7 bit signed extender 
signal se10_in : std_logic_vector(5 downto 0); -- 6 bit input to be extended to 16 bits by 10 bit signed extender 
signal rA1, rA2, rA3: std_logic_vector(2 downto 0); -- register file addresses of size (ceil(log8)=3) bits
signal op_code : std_logic_vector(3 downto 0); -- 4 bit code to identify operation in instruction 
signal mem_addr: std_logic_vector(15 downto 0):="0000000000000000"; -- starting to read from the first instruction in the memory
signal cnt : integer range 0 to 8 := 0;

begin

-- instances for all the components SEs, register files, arithmetic logic units and memory 
se7_reg : se7 port map (se7_in, se7_type, se7_out); 
se10_reg : se10 port map (se10_in, se10_out);

rf_main : rf port map (rA1, rA2, rA3, rD3,rD_PC, clk, rwr,rpc_wr, rf_rst, rD1, rD2);
alu_main : alu port map (alu_x, alu_y, alu_op, car_out, z_out, alu_out);
mem_main : memory port map (mem_wr, mem_rd,clk, mem_add, mem_din, mem_dout);


process(clk,state) -- clk conrtols state transitions and the changes in these signals control the process
     variable next_state : FSMState;
	  variable t1_v, t2_v, t3_v, t4_v, ir_v, next_ip: std_logic_vector(15 downto 0);
	  variable z, car : std_logic;
	  variable op_v : std_logic_vector(3 downto 0);
	  variable imm_flag: std_logic :='0'; -- 1 if next state from S_read is S_imm, else 0
	  
begin
		-- the following variables record the record the current values of the corresponding signals
		-- lhs has variables and has signals, immediate assignment takes place
	   next_state :=state; -- consider renaming to last state
		t1_v :=t1; t2_v :=t2; t3_v :=t3; t4_v :=t4; ir_v :=ir; op_v := op_code;
		z :=zero; car :=carry;
		next_ip :=mem_addr;
  case state is --  making cases for states 
       when S_res => -- this state resets all registers, memeory write and read flags and z,car flags
		    mem_wr <= '0'; 
		    mem_rd <= '0';
			 rwr <= '0';
			 rf_rst <= '1';
          z := '0';
			 car :='0';
          t1_v := "0000000000000000";
          t2_v := "0000000000000000";
          t3_v := "0000000000000000";
		    ir_v := "0000000000000000";
			 next_state := S0; -- after reset S0 is compuslarily the next state 
			 --where the intstruction is read and next state is decided on the basis of the operation to be performed 

----------------------------------------------------------
       when S0 => 
		    mem_wr <= '0';
		    mem_rd <= '1';
			 rwr <= '0';
			 rf_rst <='0';
          t1_v := "0000000000000000";
          t2_v := "0000000000000000";
          t3_v := "0000000000000000";
			 mem_add <= mem_addr; -- check if next_ip or this can be eliminated 
			 ir_v := mem_dout;
			 op_v := ir_v(15 downto 12);
			 
			 case (op_v) is
			   when "0000" => -- ADD/ADC/ADZ
				  next_state :=S_read_ab;
				when "0001" => -- ADI
				  imm_flag :='1';
				  next_state :=S_read_ab;
				when "0010" => -- NDU/NDC/NDZ
				  next_state :=S_read_ab;
				when "0011" => -- LH1
				  imm_flag :='1';
				  next_state :=S_read_a;
				when "0100" => -- LW
				  imm_flag :='1';
				  next_state :=S_read_ab; 
				when "0101" => --SW
				  imm_flag :='1';
				  next_state :=S_read_ab; 
				when "0110" => --LA
				  next_state :=S_read_a;
				when "1001" => -- SA
				  next_state :=S_read_a;
				when "1100" => -- BEQ
				  imm_flag :='1';
				  next_state :=S_read_ab;
				when "1000" =>  -- JAL
				  imm_flag :='1';
				  next_state :=S_read_a;
				when "0111" =>  -- JLR
				  next_state :=S_read_ab;
			   when others => null; -- no other operation codes are valid 
          end case; 
--------------------------------------------		
	     when S_read_ab => -- read and store values from R_A and R_B in t1,t2
		      mem_wr <= '0';
		      mem_rd <= '0';
			   rwr <= '0';
				rA1 <=ir_v(11 downto 9);
				rA2 <=ir_v(8 downto 6);
				t1_v := rD1;
				t2_v := rD2;
				if(imm_flag='1') then
					next_state := S_imm;
				else
					next_state := S_alu;
				end if;
				
----------------------------------------------

		  when S_read_a => -- read and store values from R_A in t1
		      mem_wr <= '0';
		      mem_rd <= '0';
			   rwr <= '0';
				rA1 <=ir_v(11 downto 9);
				t1_v := rD1;
				if(imm_flag='1') then
					next_state := S_imm;
				else
					next_state := S_alu;
				end if;
				
----------------------------------------------

		  when S_imm => -- immediate cases 
		      
				
----------------------------------------------
		  when S_alu => -- feeding inputs to the ALU
		      mem_wr <= '0';
		      mem_rd <= '0';
			   rwr <= '0';
		      alu_x <= t1_v;
				alu_y <= t2_v;
				-- add mux logic for alu here (change till ---***---)
				
				if(op_v="0010") then -- NAND 
				  alu_op <='1';
				else  -- SUM
				  alu_op <= '0';
				end if;
				t3_v := alu_out; -- capture output
				
				---***---
				
				-- add next state cases here 
----------------------------------------------		 
			when S_reg_wr => -- store outputs in register file 
			   mem_wr <= '0';
		      mem_rd <= '0';
			   rwr <= '1';
				
				-- change the following  (till ---**************---)
				if(op_v="") then
					rD3<=t1_v;
					rA3<=ir_v(11 downto 9);
				elsif(op_v="0001") then -- ADI
					rD3<=t3_v;
					rA3<=ir_v(8 downto 6);
					if(op_v="0000" or op_v="0001" or op_v="0010" or op_v="0100") then
					  z :=z_out;
					end if;
					if(op_v="0000" or op_v="0001") then
					  car:=car_out;
					end if;
				else -- ADD/ADC/ADZ/NDU/NDC/NDZ
					if((ir_v(1 downto 0)="00") or (ir_v(1 downto 0)="10" and car='1') or (ir_v(1 downto 0)="01" and z='1')) then -- ADD/ADC/ADZ 
						rD3<=t3_v; -- storing in rA3 
						rA3<=ir_v(5 downto 3);
						if(op_v="0000" or op_v="0001" or op_v="0010" or op_v="0100") then -- if ALU is involved 
							z :=z_out;
						end if;
						if(op_v="0000" or op_v="0001") then -- if SUM is involved, not NAND 
							car:=car_out;
						end if;
					end if;
				end if;
				---**************---
				
				-- cases for going to PC increment cases state (S_next) or back to S_read_a (for SA,LA cases) 
            if(op_v="0110" or op_v="1001") then
					cnt <= cnt+1; -- increment cnt for checking if next state is S_read_a or not
					if(cnt=8) then
						cnt <= 0;
						next_state :=S_next;
					else
						next_state :=S_read_a;
					end if;	
				else 
					next_state :=S_next;
				end if;
-----------------------------------------------------------------
         when S_mem_rd => --mr
			   mem_rd <='1';
			   mem_add <= t3_v; -- check variable ..t3?
			   t1_v := mem_dout;
            next_state :=S_reg_wr; -- have read from memory, now store is reg file 
-----------------------------------------------------------------
         when S_mem_wr => --mw
            mem_wr <= '1';
		      mem_rd <= '0';
			   rwr <= '0';
		      rA1 <=ir_v(11 downto 9);
				t2_v := rD1;
	         mem_add <= t3_v;
	         mem_din <= t2_v;
	         next_state :=S_next; -- have stored in memory, now next instruction 
		
-----------------------------------------------------------------
         when S_next => -- cases for program counter change
			   mem_wr <= '0';
		      mem_rd <= '0';
			   rwr <= '0';
				-- add alu - program counter mux and its controls here
				next_state :=S0; -- restart from reading instruction 
-----------------------------------------------------------------				
		when others => null; -- any other state is not considered 
  end case;		
  
 if(clk'event and clk = '0') then
          if(rst = '1') then -- initially setting rst to 1 ensures that the state has a vaue for case analysis in the beginning 
             state <= S_res; 
          else
             state <= next_state; -- state transition based on case-wise logic in each clock cycle 
				 -- all signals assigned the value stored for their next state values stored in the temporary variables created earlier
				 t1<=t1_v;t2<=t2_v;t3<=t3_v;t4<=t4_v;
				 zero<=z; carry<=car;
				 ir<=ir_v;
				 op_code<=op_v;
				 mem_addr<=next_ip; 
				 -- all the signals on the rhs are the inputs to the alu, memory or/and the register units 
          end if;
     end if;
end process;
end behave;
