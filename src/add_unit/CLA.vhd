library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLA is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           y : in STD_LOGIC_VECTOR (3 downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (3 downto 0);
           cout : out STD_LOGIC);
end CLA;

architecture Behavioral of CLA is

component full_adder is
    Port ( x : in STD_LOGIC;
           y : in STD_LOGIC;
           cin : in STD_LOGIC;
           s : out STD_LOGIC;
           cout : out STD_LOGIC);
end component;

component carry_block is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           y : in STD_LOGIC_VECTOR (3 downto 0);
           cin: in STD_LOGIC;
           c : out STD_LOGIC_VECTOR (4 downto 0));
end component;

signal carry: STD_LOGIC_VECTOR(4 downto 0);

begin

cb: carry_block port map(x,y,cin,carry);
fa1: full_adder port map(x(0),y(0),cin,s(0),open);
fa2: full_adder port map(x(1),y(1),carry(1),s(1),open);
fa3: full_adder port map(x(2),y(2),carry(2),s(2),open);
fa4: full_adder port map(x(3),y(3),carry(3),s(3),open);
cout <= carry(4);


end Behavioral;
