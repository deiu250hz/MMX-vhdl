
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLA_8 is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           cin : in STD_LOGIC;
           s: out STD_LOGIC_VECTOR(7 downto 0);
           cout : out STD_LOGIC);
end CLA_8;

architecture Behavioral of CLA_8 is

component CLA is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           y : in STD_LOGIC_VECTOR (3 downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (3 downto 0);
           cout : out STD_LOGIC);
end component;

signal G0, P0 : STD_LOGIC;  
signal G1, P1 : STD_LOGIC;  
signal c4, c8 : STD_LOGIC;

begin

G0 <= (x(3) and y(3))
      or ((x(3) or y(3)) and (x(2) and y(2)))
      or ((x(3) or y(3)) and (x(2) or y(2)) and (x(1) and y(1)))
      or ((x(3) or y(3)) and (x(2) or y(2)) and (x(1) or y(1)) and (x(0) and y(0)));
P0 <= (x(3) or y(3)) and (x(2) or y(2)) and (x(1) or y(1)) and (x(0) or y(0));
G1 <= (x(7) and y(7))
      or ((x(7) or y(7)) and (x(6) and y(6)))
      or ((x(7) or y(7)) and (x(6) or y(6)) and (x(5) and y(5)))
      or ((x(7) or y(7)) and (x(6) or y(6)) and (x(5) or y(5)) and (x(4) and y(4)));
P1 <= (x(7) or y(7)) and (x(6) or y(6)) and (x(5) or y(5)) and (x(4) or y(4));
c4 <= G0 or (P0 and cin);
c8 <= G1 or (P1 and G0) or (P1 and P0 and cin);

cla1: CLA port map(x(3 downto 0),y(3 downto 0),cin,s(3 downto 0),open);
cla2: CLA port map(x(7 downto 4),y(7 downto 4),c4,s(7 downto 4),open);
cout <= c8;

end Behavioral;
