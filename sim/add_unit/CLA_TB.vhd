library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_tb is
end CLA_tb;

architecture Behavioral of CLA_tb is

component CLA is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           y : in STD_LOGIC_VECTOR (3 downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (3 downto 0);
           cout : out STD_LOGIC);
end component;

signal x, y : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal cin  : STD_LOGIC := '0';
signal s    : STD_LOGIC_VECTOR(3 downto 0);
signal cout : STD_LOGIC;

begin

uut: CLA port map(x => x, y => y, cin => cin, s => s, cout => cout);

stim: process
begin
    --                                       asteptat:  s     cout
    x <= "0000"; y <= "0000"; cin <= '0'; wait for 10 ns;  -- 0000  0
    x <= "0001"; y <= "0001"; cin <= '0'; wait for 10 ns;  -- 0010  0
    x <= "0011"; y <= "0101"; cin <= '0'; wait for 10 ns;  -- 1000  0
    x <= "0111"; y <= "0001"; cin <= '0'; wait for 10 ns;  -- 1000  0  (overflow cu semn)
    x <= "1111"; y <= "0001"; cin <= '0'; wait for 10 ns;  -- 0000  1
    x <= "1111"; y <= "0000"; cin <= '1'; wait for 10 ns;  -- 0000  1
    x <= "0101"; y <= "1010"; cin <= '0'; wait for 10 ns;  -- 1111  0
    x <= "0101"; y <= "1010"; cin <= '1'; wait for 10 ns;  -- 0000  1
    x <= "1000"; y <= "1000"; cin <= '0'; wait for 10 ns;  -- 0000  1
    x <= "1001"; y <= "0110"; cin <= '1'; wait for 10 ns;  -- 0000  1
    x <= "1010"; y <= "0011"; cin <= '1'; wait for 10 ns;  -- 1110  0
    x <= "1111"; y <= "1111"; cin <= '1'; wait for 10 ns;  -- 1111  1
    wait;
end process;

end Behavioral;