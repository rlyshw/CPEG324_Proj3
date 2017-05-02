library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity calc_single_tb is
end calc_single_tb;

architecture behavioral of calc_single_tb is
--  Declaration of the component that will be instantiated.

-- Internal signals (wires for connecting components)
signal inst,outp : std_logic_vector(7 downto 0);
signal GCLOCK : std_logic;

begin
--  Component instantiation.
calc_single_0: entity work.calc_single port map (Inst=>inst,GCLOCK=>GCLOCK,outp=>outp); 

-- Testing process
test_bench_calc_single : process  is
--begin

type pattern_type is record
--  The inputs and outputs of the shift_reg.
inst, outp : std_logic_vector (7 downto 0);
GCLOCK : std_logic;

end record;

--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
("10100000", "ZZZZZZZZ", '0'),
("10100000", "ZZZZZZZZ", '1'), --LI r2 0

("10000001", "ZZZZZZZZ", '0'),
("10000001", "ZZZZZZZZ", '1'), --LI r0 1

("10010010", "ZZZZZZZZ", '0'),
("10010010", "ZZZZZZZZ", '1'), --LI r1 2

("11100001", "ZZZZZZZZ", '0'),
("11100001", "ZZZZZZZZ", '1'), --BR1 r2 

("01000110", "ZZZZZZZZ", '0'),
("01000110", "ZZZZZZZZ", '1'), --SUB r0 r1 r2 (1-2=-1)

("11100000", "00000000", '0'), 
("11100000", "00000000", '1'),  --PR r2, should be 0

--    start
("10001000", "ZZZZZZZZ", '0'),
("10001000", "ZZZZZZZZ", '1'),  -- LI r0, -8

("10010111", "ZZZZZZZZ", '0'),
("10010111", "ZZZZZZZZ", '1'),  -- LI r1, 7

("00000111", "ZZZZZZZZ", '0'),
("00000111", "ZZZZZZZZ", '1'),  -- ADD r0, r1, r3

("01001110", "ZZZZZZZZ", '0'),  
("01001110", "ZZZZZZZZ", '1'),  -- SUB r0, r3, r2

("00100100", "ZZZZZZZZ", '0'),
("00100100", "ZZZZZZZZ", '1'),  -- ADD r2, r1, r0

("10110010", "ZZZZZZZZ", '0'),
("10110010", "ZZZZZZZZ", '1'),  -- LI r3, 2

("11000010", "ZZZZZZZZ", '0'),
("11000010", "ZZZZZZZZ", '1'),  -- BR2, r0 (should happen)

("11000000", "ZZZZZZZZ", '0'),
("11000000", "ZZZZZZZZ", '1'),  -- PR r0

("11010000", "ZZZZZZZZ", '0'),
("11010000", "ZZZZZZZZ", '1'),  -- PR r1

("00001100", "ZZZZZZZZ", '0'),
("00001100", "ZZZZZZZZ", '1'),  -- ADD r0, r3, r0

("11000010", "ZZZZZZZZ", '0'),
("11000010", "ZZZZZZZZ", '1'),  -- BR2 r0 (shouldn't happen)

("11000000", "ZZZZZZZZ", '0'),
("11000000", "ZZZZZZZZ", '1'),  -- PR r0

("11110000", "ZZZZZZZZ", '0'),
("11110000", "ZZZZZZZZ", '1'),  -- PR r3

("01001100", "ZZZZZZZZ", '0'),
("01001100", "ZZZZZZZZ", '1'),  -- SUB r0 r3 r0

("11000001", "ZZZZZZZZ", '0'),
("11000001", "ZZZZZZZZ", '1'),  -- BR1 r0 (should happen)

("11110000", "ZZZZZZZZ", '0'),
("11110000", "ZZZZZZZZ", '1'),  -- PR r3

("11010000", "ZZZZZZZZ", '0'),
("11010000", "ZZZZZZZZ", '1'),  -- PR r1

("00101010", "ZZZZZZZZ", '0'),
("00101010", "ZZZZZZZZ", '1'),  -- ADD r2, r2, r2

("11100000", "ZZZZZZZZ", '0'),
("11100000", "ZZZZZZZZ", '1'),  -- PR r2

("10001000", "ZZZZZZZZ", '0'),
("10001000", "ZZZZZZZZ", '1'),  -- LI r0 -8

("01100011", "ZZZZZZZZ", '0'),
("01100011", "ZZZZZZZZ", '1'),  -- SUB r2, r0, r3

("11110000", "ZZZZZZZZ", '0'),
("11110000", "ZZZZZZZZ", '1'),  -- PR r3

("10110000", "ZZZZZZZZ", '0'),
("10110000", "ZZZZZZZZ", '1'),  -- SUB r3, r0, r0

("11110001", "ZZZZZZZZ", '0'),
("11110001", "ZZZZZZZZ", '1'),  -- BR1 r3

("10010110", "ZZZZZZZZ", '0'),
("10010110", "ZZZZZZZZ", '1'),  -- LI r1, 6

("11010000", "ZZZZZZZZ", '0'),
("11010000", "ZZZZZZZZ", '1'),  -- PR r1

("11000001", "ZZZZZZZZ", '0'),
("11000001", "ZZZZZZZZ", '1'),  -- BR1 r0

("11000000", "ZZZZZZZZ", '0'),
("11000000", "ZZZZZZZZ", '1'),  -- PR r0

("11100000", "ZZZZZZZZ", '0'),
("11100000", "ZZZZZZZZ", '0')   -- PR r2

);


variable test_result : std_logic_vector(3 downto 0) := "0000";
variable print_control : std_logic := '0';

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
inst <= patterns(n).inst;
GCLOCK <=patterns(n).GCLOCK;


--  Wait for the results.
wait for 20 ns;

 -- test_result := output;

-- if (print_control = '1') then 
 -- for i in 0 to test_result'LENGTH loop
 -- report "test_result("&integer'image(i)&") value is" &  std_logic'image(test_result(i));
 -- end loop;
-- end if;
 
 -- print_control := not print_control;
 
--  Check the outputs.
assert outp = patterns(n).outp report "Error: bad output value" severity error;

end loop;

assert false report "End of calc test. Passed if no errors displayed" severity note;

--  Wait forever; this will finish the simulation.
wait;

end process test_bench_calc_single;
-- End of testing process

end architecture;
-- end of bavioral test bench 
