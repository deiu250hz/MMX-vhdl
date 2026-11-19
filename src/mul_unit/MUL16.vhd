
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUL16 is
    Port ( x : in STD_LOGIC_VECTOR (15 downto 0);
           y : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           start : in STD_LOGIC;
           shift_left: in STD_LOGIC;
           shift_right: in STD_LOGIC;
           load: in STD_LOGIC;
           q0: out STD_LOGIC;
           prod : out STD_LOGIC_VECTOR (31 downto 0));
end MUL16;

architecture Behavioral of MUL16 is

signal abs_x, abs_y: STD_LOGIC_VECTOR(15 downto 0);
signal A,B: STD_LOGIC_VECTOR(31 downto 0);
signal Q: STD_LOGIC_VECTOR(15 downto 0);
signal alu_out: STD_LOGIC_VECTOR(31 downto 0);
signal sign: STD_LOGIC;

begin

alu_out <= A+B;
abs_x <= (not x + '1') when x(15)='1' else x;
abs_y <= (not y + '1') when y(15)='1' else y;

process(clk)
begin
  if rising_edge(clk) then
    if start='1' then
      A <= (others=>'0');
      B <= X"0000"&abs_x;
      Q <= abs_y;
      sign <= x(15) xor y(15);
    else
      if load='1' then
        A <= alu_out;
      end if;
      if shift_left='1' then
        B <= B(30 downto 0)&'0';
      end if;
      if shift_right='1' then
        Q<='0'&Q(15 downto 1);
      end if;
    end if;
  end if;
end process;

prod <= A when sign='0' else (not A + '1');
q0 <= Q(0);

end Behavioral;
