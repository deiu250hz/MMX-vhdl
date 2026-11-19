library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_8_tb is
end CLA_8_tb;

architecture Behavioral of CLA_8_tb is

component CLA_8 is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (7 downto 0);
           cout : out STD_LOGIC);
end component;

signal x, y : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal cin  : STD_LOGIC := '0';
signal s    : STD_LOGIC_VECTOR(7 downto 0);
signal cout : STD_LOGIC;

begin

uut: CLA_8 port map(x => x, y => y, cin => cin, s => s, cout => cout);

stim: process
begin
    --                                        asteptat:  s   cout
    x <= x"00"; y <= x"00"; cin <= '0'; wait for 10 ns;  -- 00   0
    x <= x"08"; y <= x"08"; cin <= '0'; wait for 10 ns;  -- 10   0   (c4 generat in bitul 3)
    x <= x"0F"; y <= x"01"; cin <= '0'; wait for 10 ns;  -- 10   0   (c4 propagat prin bloc)
    x <= x"0F"; y <= x"00"; cin <= '1'; wait for 10 ns;  -- 10   0   (c4 declansat de cin)
    x <= x"12"; y <= x"34"; cin <= '0'; wait for 10 ns;  -- 46   0
    x <= x"7F"; y <= x"01"; cin <= '0'; wait for 10 ns;  -- 80   0   (overflow cu semn)
    x <= x"3C"; y <= x"4B"; cin <= '0'; wait for 10 ns;  -- 87   0   (overflow cu semn)
    x <= x"80"; y <= x"80"; cin <= '0'; wait for 10 ns;  -- 00   1   (overflow cu semn)
    x <= x"C8"; y <= x"9C"; cin <= '0'; wait for 10 ns;  -- 64   1   (overflow cu semn)
    x <= x"FF"; y <= x"01"; cin <= '0'; wait for 10 ns;  -- 00   1
    x <= x"55"; y <= x"AA"; cin <= '0'; wait for 10 ns;  -- FF   0
    x <= x"55"; y <= x"AA"; cin <= '1'; wait for 10 ns;  -- 00   1   (propagare pe toti cei 8 biti)
    x <= x"FF"; y <= x"FF"; cin <= '1'; wait for 10 ns;  -- FF   1
    wait;
end process;

end Behavioral;