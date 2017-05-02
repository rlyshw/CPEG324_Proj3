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
("10000001", "00000000", '1'),
("10000001", "00000000", '0'),
("11000000", "00000000", '1'),
("11000000", "00000000", '0')
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
