
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUL_unit is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           y : in STD_LOGIC_VECTOR (63 downto 0);
           clk: in STD_LOGIC;
           op : in STD_LOGIC;
           start: in STD_LOGIC;
           done: out STD_LOGIC;
           res : out STD_LOGIC_VECTOR (63 downto 0));
end MUL_unit;

architecture Behavioral of MUL_unit is

component MUL16 is
    Port ( x : in STD_LOGIC_VECTOR (15 downto 0);
           y : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           start : in STD_LOGIC;
           shift_left: in STD_LOGIC;
           shift_right: in STD_LOGIC;
           load: in STD_LOGIC;
           q0: out STD_LOGIC;
           prod : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUL_CU is
    Port ( clk : in STD_LOGIC;
           start : in STD_LOGIC;
           q0 : in STD_LOGIC_VECTOR (3 downto 0);
           load : out STD_LOGIC_VECTOR (3 downto 0);
           shift_left : out STD_LOGIC;
           shift_right : out STD_LOGIC;
           done : out STD_LOGIC);
end component;

signal shift_left,shift_right: STD_LOGIC;
signal q0,load: STD_LOGIC_VECTOR(3 downto 0);
signal p1,p2,p3,p4: STD_LOGIC_VECTOR(31 downto 0);
signal r_low,r_high: STD_LOGIC_VECTOR(63 downto 0);

begin

cu: MUL_CU port map(clk,start,q0,load,shift_left,shift_right,done);
mul1: MUL16 port map(x(15 downto 0),y(15 downto 0),clk,start,shift_left,shift_right,load(0),q0(0),p1);
mul2: MUL16 port map(x(31 downto 16),y(31 downto 16),clk,start,shift_left,shift_right,load(1),q0(1),p2);
mul3: MUL16 port map(x(47 downto 32),y(47 downto 32),clk,start,shift_left,shift_right,load(2),q0(2),p3);
mul4: MUL16 port map(x(63 downto 48),y(63 downto 48),clk,start,shift_left,shift_right,load(3),q0(3),p4);

r_high <= p4(31 downto 16)&p3(31 downto 16)&p2(31 downto 16)&p1(31 downto 16);
r_low <= p4(15 downto 0)&p3(15 downto 0)&p2(15 downto 0)&p1(15 downto 0);

res <= r_low when op='0' else r_high;

end Behavioral;
