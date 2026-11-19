library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUL_unit_tb is
end MUL_unit_tb;

architecture Behavioral of MUL_unit_tb is

component MUL_unit is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           y : in STD_LOGIC_VECTOR (63 downto 0);
           clk : in STD_LOGIC;
           start : in STD_LOGIC;
           op : in STD_LOGIC;
           res : out STD_LOGIC_VECTOR (63 downto 0);
           done : out STD_LOGIC);
end component;

signal clk     : STD_LOGIC := '0';
signal sim_end : boolean := false;
signal start   : STD_LOGIC := '0';
signal op      : STD_LOGIC := '0';
signal x, y    : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal res     : STD_LOGIC_VECTOR(63 downto 0);
signal done    : STD_LOGIC;

constant T : time := 10 ns;

begin

uut: MUL_unit port map(x => x, y => y, clk => clk, start => start,
                       op => op, res => res, done => done);

-- ceas de 10 ns, se opreste la final ca sa mearga "Run All"
clk_gen: process
begin
    while not sim_end loop
        clk <= '0'; wait for T/2;
        clk <= '1'; wait for T/2;
    end loop;
    wait;
end process;

-- op = '0' -> PMULLW (bitii 15..0 ai fiecarui produs)
-- op = '1' -> PMULHW (bitii 31..16 ai fiecarui produs)
-- Benzile se citesc de la stanga la dreapta: cuvantul 3, 2, 1, 0.
-- Dupa ce done trece pe 1, op se schimba ca sa se vada ambele rezultate.

stim: process
begin
    wait for 2*T;

    ------------------------------------------------------------------
    -- Test 1
    -- cuvant 3: 0003 *  0005 = 0000000F
    -- cuvant 2: FFFF *  FFFF = 00000001   (-1 * -1)
    -- cuvant 1: 7FFF *  7FFF = 3FFF0001
    -- cuvant 0: 8000 *  8000 = 40000000   (-32768 * -32768)
    -- asteptat PMULLW: 000F 0001 0001 0000
    -- asteptat PMULHW: 0000 0000 3FFF 4000
    ------------------------------------------------------------------
    x <= x"0003FFFF7FFF8000"; y <= x"0005FFFF7FFF8000";
    start <= '1'; wait for T; start <= '0';
    wait for 18*T;
    op <= '0'; wait for 3*T;
    op <= '1'; wait for 3*T;

    ------------------------------------------------------------------
    -- Test 2
    -- cuvant 3: FFFD *  0007 = FFFFFFEB   (-3 * 7)
    -- cuvant 2: 0064 *  FF9C = FFFFD8F0   (100 * -100)
    -- cuvant 1: 1234 *  5678 = 06260060
    -- cuvant 0: 8000 *  7FFF = C0008000   (-32768 * 32767)
    -- asteptat PMULLW: FFEB D8F0 0060 8000
    -- asteptat PMULHW: FFFF FFFF 0626 C000
    ------------------------------------------------------------------
    x <= x"FFFD006412348000"; y <= x"0007FF9C56787FFF";
    start <= '1'; wait for T; start <= '0';
    wait for 18*T;
    op <= '0'; wait for 3*T;
    op <= '1'; wait for 3*T;

    ------------------------------------------------------------------
    -- Test 3
    -- cuvant 3: 0000 *  1234 = 00000000
    -- cuvant 2: 0100 *  0100 = 00010000
    -- cuvant 1: FFFE *  0003 = FFFFFFFA   (-2 * 3)
    -- cuvant 0: 4000 *  0004 = 00010000
    -- asteptat PMULLW: 0000 0000 FFFA 0000
    -- asteptat PMULHW: 0000 0001 FFFF 0001
    ------------------------------------------------------------------
    x <= x"00000100FFFE4000"; y <= x"1234010000030004";
    start <= '1'; wait for T; start <= '0';
    wait for 18*T;
    op <= '0'; wait for 3*T;
    op <= '1'; wait for 3*T;

    sim_end <= true;
    wait;
end process;

end Behavioral;