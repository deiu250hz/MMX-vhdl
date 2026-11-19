
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUL_CU is
    Port ( clk : in STD_LOGIC;
           start : in STD_LOGIC;
           q0 : in STD_LOGIC_VECTOR (3 downto 0);
           load : out STD_LOGIC_VECTOR (3 downto 0);
           shift_left : out STD_LOGIC;
           shift_right : out STD_LOGIC;
           done : out STD_LOGIC);
end MUL_CU;

architecture Behavioral of MUL_CU is

signal N: UNSIGNED(4 downto 0):=(others=>'0');
signal run: STD_LOGIC;

begin

process(clk)
  begin
  if rising_edge(clk) then
    if start='1' then
      N<=TO_UNSIGNED(16,5);
    elsif N/=0 then 
      N<=N-1;
    end if;
  end if;
end process;

run <= '1' when N/=0 else '0';
load(0) <= run and q0(0);
load(1) <= run and q0(1);
load(2) <= run and q0(2);
load(3) <= run and q0(3);
shift_right <= run;
shift_left <= run;
done <= '1' when N = 0 else '0';

end Behavioral;
