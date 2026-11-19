library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LOG_unit_tb is
end LOG_unit_tb;

architecture Behavioral of LOG_unit_tb is

component LOG_unit is
    Port ( A : in STD_LOGIC_VECTOR (63 downto 0);
           B : in STD_LOGIC_VECTOR (63 downto 0);
           op : in STD_LOGIC_VECTOR (1 downto 0);
           res : out STD_LOGIC_VECTOR (63 downto 0));
end component;

signal A, B : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal op   : STD_LOGIC_VECTOR(1 downto 0)  := "00";
signal res  : STD_LOGIC_VECTOR(63 downto 0);

begin

uut: LOG_unit port map(A => A, B => B, op => op, res => res);

-- op: 00 = PAND, 01 = PANDN ((not A) and B), 10 = POR, 11 = PXOR

stim: process
begin
    ------------------------------------------------------------------
    -- Set 1: modele mixte
    ------------------------------------------------------------------
    A <= x"F0F0F0F0FFFF0000"; B <= x"FF00FF00F0F01234";
    op <= "00"; wait for 10 ns;   -- asteptat: F000F000F0F00000
    op <= "01"; wait for 10 ns;   -- asteptat: 0F000F0000001234
    op <= "10"; wait for 10 ns;   -- asteptat: FFF0FFF0FFFF1234
    op <= "11"; wait for 10 ns;   -- asteptat: 0FF00FF00F0F1234

    ------------------------------------------------------------------
    -- Set 2: A = toti bitii 1
    ------------------------------------------------------------------
    A <= x"FFFFFFFFFFFFFFFF"; B <= x"0123456789ABCDEF";
    op <= "00"; wait for 10 ns;   -- asteptat: 0123456789ABCDEF  (= B)
    op <= "01"; wait for 10 ns;   -- asteptat: 0000000000000000
    op <= "10"; wait for 10 ns;   -- asteptat: FFFFFFFFFFFFFFFF
    op <= "11"; wait for 10 ns;   -- asteptat: FEDCBA9876543210  (= not B)

    ------------------------------------------------------------------
    -- Set 3: A = 0 (verifica ca PANDN neaga A, nu B)
    ------------------------------------------------------------------
    A <= x"0000000000000000"; B <= x"0123456789ABCDEF";
    op <= "00"; wait for 10 ns;   -- asteptat: 0000000000000000
    op <= "01"; wait for 10 ns;   -- asteptat: 0123456789ABCDEF  (= B)
    op <= "10"; wait for 10 ns;   -- asteptat: 0123456789ABCDEF
    op <= "11"; wait for 10 ns;   -- asteptat: 0123456789ABCDEF

    wait;
end process;

end Behavioral;