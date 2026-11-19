library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUL16_tb is
end MUL16_tb;

architecture Behavioral of MUL16_tb is

component MUL_CU is
    Port ( clk : in STD_LOGIC;
           start : in STD_LOGIC;
           q0 : in STD_LOGIC_VECTOR (3 downto 0);
           load : out STD_LOGIC_VECTOR (3 downto 0);
           shift_left : out STD_LOGIC;
           shift_right : out STD_LOGIC;
           done : out STD_LOGIC);
end component;

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

signal clk     : STD_LOGIC := '0';
signal sim_end : boolean := false;
signal start   : STD_LOGIC := '0';
signal x, y    : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal prod    : STD_LOGIC_VECTOR(31 downto 0);
signal done    : STD_LOGIC;

signal q0_lane       : STD_LOGIC;
signal q0_vec        : STD_LOGIC_VECTOR(3 downto 0);
signal load_vec      : STD_LOGIC_VECTOR(3 downto 0);
signal sl, sr        : STD_LOGIC;

constant T : time := 10 ns;

begin

-- o singura banda conectata la MUL_CU; celelalte 3 intrari q0 sunt legate la 0
q0_vec <= "000" & q0_lane;

cu: MUL_CU port map(clk => clk, start => start, q0 => q0_vec, load => load_vec,
                    shift_left => sl, shift_right => sr, done => done);

uut: MUL16 port map(x => x, y => y, clk => clk, start => start,
                    shift_left => sl, shift_right => sr, load => load_vec(0),
                    q0 => q0_lane, prod => prod);

-- ceas de 10 ns, se opreste la final ca sa mearga "Run All"
clk_gen: process
begin
    while not sim_end loop
        clk <= '0'; wait for T/2;
        clk <= '1'; wait for T/2;
    end loop;
    wait;
end process;

stim: process
begin
    wait for 2*T;

    -- Fiecare test: start pe un ciclu, apoi 16 iteratii.
    -- Rezultatul se citeste pe prod cand done trece din 0 in 1.

    --                                     asteptat prod   (zecimal)
    x <= x"0003"; y <= x"0005";          -- 0000000F       3 * 5 = 15
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"0000"; y <= x"1234";          -- 00000000       0 * 4660 = 0
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"FFFF"; y <= x"0001";          -- FFFFFFFF       -1 * 1 = -1
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"FFFF"; y <= x"FFFF";          -- 00000001       -1 * -1 = 1
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"FFFD"; y <= x"0007";          -- FFFFFFEB       -3 * 7 = -21
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"0064"; y <= x"FF9C";          -- FFFFD8F0       100 * -100 = -10000
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"1234"; y <= x"5678";          -- 06260060       4660 * 22136
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"7FFF"; y <= x"7FFF";          -- 3FFF0001       32767 * 32767
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"8000"; y <= x"7FFF";          -- C0008000       -32768 * 32767
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    x <= x"8000"; y <= x"8000";          -- 40000000       -32768 * -32768 = 2^30
    start <= '1'; wait for T; start <= '0'; wait for 19*T;

    -- Intrarile se schimba in timpul calculului.
    -- Rezultatul trebuie sa ramana -2 * 3 = -6, adica FFFFFFFA.
    -- Daca iese 00000006, semnul nu e memorat la start.
    x <= x"FFFE"; y <= x"0003";
    start <= '1'; wait for T; start <= '0';
    wait for 2*T;
    x <= x"0002"; y <= x"0003";
    wait for 17*T;

    sim_end <= true;
    wait;
end process;

end Behavioral;