library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
entity bit_16_adder is
  port (A,B: in std_logic_vector(15 downto 0);car_in: in std_logic; car_out: out std_logic; sum: out std_logic_vector(15 downto 0));
end entity bit_16_adder;
architecture arch of bit_16_adder is
  signal flow: std_logic;

component Full_Adder  is
  port (A, B, Cin: in std_logic; S, Cout: out std_logic);
end component Full_Adder;

component EightbitKogStonAddSub is
  port (a,b: in std_logic_vector(7 downto 0);
      cin: in std_logic;
      sum: out std_logic_vector(7 downto 0);
      cout: out std_logic);
end component;

begin
       Kogston0: EightbitKogStonAddSub port map(a => A(7 downto 0), b => B(7 downto 0), cin => car_in, sum => sum(7 downto 0), cout =>flow );

       Kogston1: EightbitKogStonAddSub port map(a => A(15 downto 8) , b => B(15 downto 8), cin => flow, sum =>  sum(15 downto 8), cout => car_out);


end arch;