
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADD_unit is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           y : in STD_LOGIC_VECTOR (63 downto 0);
           pass : in STD_LOGIC_VECTOR (6 downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (63 downto 0);
           cout : out STD_LOGIC_VECTOR(7 downto 0));
end ADD_unit;

architecture Behavioral of ADD_unit is

component CLA_8 is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           cin : in STD_LOGIC;
           s: out STD_LOGIC_VECTOR(7 downto 0);
           cout : out STD_LOGIC);
end component;

signal c1,c2,c3,c4,c5,c6,c7,c8: STD_LOGIC;
signal carry1,carry2,carry3,carry4,carry5,carry6,carry7: STD_LOGIC;

begin

carry1 <= c1 when pass(0)='1' else cin;
carry2 <= c2 when pass(1)='1' else cin;
carry3 <= c3 when pass(2)='1' else cin;
carry4 <= c4 when pass(3)='1' else cin;
carry5 <= c5 when pass(4)='1' else cin;
carry6 <= c6 when pass(5)='1' else cin;
carry7 <= c7 when pass(6)='1' else cin;

cla8_1: CLA_8 port map(x(7 downto 0),  y(7 downto 0),  cin,    s(7 downto 0),  c1);
cla8_2: CLA_8 port map(x(15 downto 8), y(15 downto 8), carry1, s(15 downto 8), c2);
cla8_3: CLA_8 port map(x(23 downto 16),y(23 downto 16),carry2, s(23 downto 16),c3);
cla8_4: CLA_8 port map(x(31 downto 24),y(31 downto 24),carry3, s(31 downto 24),c4);
cla8_5: CLA_8 port map(x(39 downto 32),y(39 downto 32),carry4, s(39 downto 32),c5);
cla8_6: CLA_8 port map(x(47 downto 40),y(47 downto 40),carry5, s(47 downto 40),c6);
cla8_7: CLA_8 port map(x(55 downto 48),y(55 downto 48),carry6, s(55 downto 48),c7);
cla8_8: CLA_8 port map(x(63 downto 56),y(63 downto 56),carry7, s(63 downto 56),c8);

cout <= c8&c7&c6&c5&c4&c3&c2&c1;

end Behavioral;
