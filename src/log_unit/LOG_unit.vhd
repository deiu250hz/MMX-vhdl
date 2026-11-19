
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LOG_unit is
    Port ( A : in STD_LOGIC_VECTOR (63 downto 0);
           B : in STD_LOGIC_VECTOR (63 downto 0);
           op : in STD_LOGIC_VECTOR (1 downto 0);
           res : out STD_LOGIC_VECTOR (63 downto 0));
end LOG_unit;

architecture Behavioral of LOG_unit is

signal res_and,res_andn,res_or,res_xor: STD_LOGIC_VECTOR(63 downto 0);

begin

res_and <= A and B;
res_andn <= (not A) and B;
res_or <= A or B;
res_xor <= A xor B;

process(op,res_and,res_andn,res_or,res_xor)
begin
  case op is
    when "00" => res <= res_and;
    when "01" => res <= res_andn;
    when "10" => res <= res_or;
    when others => res <= res_xor;
  end case;
end process;


end Behavioral;
