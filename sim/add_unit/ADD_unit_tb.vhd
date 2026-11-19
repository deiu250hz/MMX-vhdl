library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ADD_unit_tb is
end ADD_unit_tb;

architecture Behavioral of ADD_unit_tb is

component ADD_unit is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           y : in STD_LOGIC_VECTOR (63 downto 0);
           pass : in STD_LOGIC_VECTOR (6 downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (63 downto 0);
           cout : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal x, y : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal pass : STD_LOGIC_VECTOR(6 downto 0)  := (others => '0');
signal cin  : STD_LOGIC := '0';
signal s    : STD_LOGIC_VECTOR(63 downto 0);
signal cout : STD_LOGIC_VECTOR(7 downto 0);

begin

uut: ADD_unit port map(x => x, y => y, pass => pass, cin => cin, s => s, cout => cout);

-- pass: 0000000 = octeti, 1010101 = cuvinte, 1110111 = dublu-cuvinte, 1111111 = 64 biti
-- La scadere, y se da deja inversat (not y) si cin = '1', ca in entitatea mare.

stim: process
begin
    ------------------------------------------------------------------
    -- 1-4: acelasi FF..FF + 00..01, se verifica ruperea benzilor
    ------------------------------------------------------------------

    -- asteptat: s = FFFFFFFFFFFFFF00   cout = 00000001
    x <= x"FFFFFFFFFFFFFFFF"; y <= x"0000000000000001"; cin <= '0'; pass <= "0000000";
    wait for 10 ns;

    -- asteptat: s = FFFFFFFFFFFF0000   cout = 00000011
    pass <= "1010101";
    wait for 10 ns;

    -- asteptat: s = FFFFFFFF00000000   cout = 00001111
    pass <= "1110111";
    wait for 10 ns;

    -- asteptat: s = 0000000000000000   cout = 11111111
    pass <= "1111111";
    wait for 10 ns;

    ------------------------------------------------------------------
    -- 5-6: adunare pe octeti
    ------------------------------------------------------------------

    -- simplu, fara carry
    -- asteptat: s = 1112131415161718   cout = 00000000
    x <= x"0102030405060708"; y <= x"1010101010101010"; cin <= '0'; pass <= "0000000";
    wait for 10 ns;

    -- cazuri de overflow pe fiecare octet
    -- octeti: 7F+01, 80+80, FF+01, 01+FF, 7F+7F, 80+80, FF+FF, 01+01
    -- asteptat: s = 80000000FE00FE02   cout = 01110110
    x <= x"7F80FF017F80FF01"; y <= x"018001FF7F80FF01"; cin <= '0'; pass <= "0000000";
    wait for 10 ns;

    ------------------------------------------------------------------
    -- 7: adunare pe cuvinte
    -- cuvinte: 7FFF+0001, 8000+8000, FFFF+0001, 1234+4321
    -- asteptat: s = 8000000000005555   cout = 01101100
    ------------------------------------------------------------------
    x <= x"7FFF8000FFFF1234"; y <= x"0001800000014321"; cin <= '0'; pass <= "1010101";
    wait for 10 ns;

    ------------------------------------------------------------------
    -- 8: adunare pe dublu-cuvinte
    -- dublu-cuvinte: 7FFFFFFF+00000001, 00000001+FFFFFFFF
    -- asteptat: s = 8000000000000000   cout = 01111111
    ------------------------------------------------------------------
    x <= x"7FFFFFFF00000001"; y <= x"00000001FFFFFFFF"; cin <= '0'; pass <= "1110111";
    wait for 10 ns;

    ------------------------------------------------------------------
    -- 9: scadere pe octeti (y dat inversat, cin = 1)
    -- x - y: 10-01, 05-05, 00-01, 80-01, 7F-FF, 01-02, FF-01, 03-03
    -- asteptat: s = 0F00FF7F80FFFE00   cout = 11010011  (cout = 1 inseamna fara imprumut)
    ------------------------------------------------------------------
    x <= x"100500807F01FF03"; y <= x"FEFAFEFE00FDFEFC"; cin <= '1'; pass <= "0000000";
    wait for 10 ns;

    ------------------------------------------------------------------
    -- 10: scadere pe cuvinte (y dat inversat, cin = 1)
    -- x - y: 0000-0001, 0100-0001, 8000-0001, 1234-1234
    -- asteptat: s = FFFF00FF7FFF0000   cout = 00101011
    ------------------------------------------------------------------
    x <= x"0000010080001234"; y <= x"FFFEFFFEFFFEEDCB"; cin <= '1'; pass <= "1010101";
    wait for 10 ns;

    wait;
end process;

end Behavioral;