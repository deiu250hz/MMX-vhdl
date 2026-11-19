library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity carry_block is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           y : in STD_LOGIC_VECTOR (3 downto 0);
           cin: in STD_LOGIC;
           c : out STD_LOGIC_VECTOR (4 downto 0));
end carry_block;

architecture Dataflow of carry_block is
signal c1,c2,c3,c4: STD_LOGIC;
begin
    c1<=(x(0) and y(0)) or ((x(0) or y(0)) and cin);
    c2 <= (x(1) and y(1)) or ((x(1) or y(1))
         and ((x(0) and y(0)) or ((x(0) or y(0)) and cin)));
    c3 <= (x(2) and y(2)) or ((x(2) or y(2)) 
        and ((x(1) and y(1)) or ((x(1) or y(1)) 
        and ((x(0) and y(0)) or ((x(0) or y(0)) and cin)))));
    c4 <= (x(3) and y(3)) or ((x(3) or y(3)) 
        and ((x(2) and y(2)) or ((x(2) or y(2)) 
        and ((x(1) and y(1)) or ((x(1) or y(1)) 
        and ((x(0) and y(0)) or ((x(0) or y(0)) and cin)))))));
    c(0)<=cin;
    c(1)<=c1;
    c(2)<=c2;
    c(3)<=c3;
    c(4)<=c4;
end Dataflow;