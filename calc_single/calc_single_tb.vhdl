library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity calc_single_tb is
end calc_single_tb;

architecture behavioral of calc_single_tb is
--  Declaration of the component that will be instantiated.
component calc_single
port(	In1, In2:	in std_logic_vector (3 downto 0);		-- signed 4 bit input 
			Output : out std_logic_vector(3 downto 0);			-- signed 4 bit output
			Carry, Underflow : out std_logic								-- overflow and underflow signal
);
end component calc_single;

-- Internal signals (wires for connecting components)
signal in1, in2, output : std_logic_vector(3 downto 0);
signal carry, underflow : std_logic;

begin
--  Component instantiation.
calc_single_0: calc_single port map (In1 => in1, In2 => in2, Output => output, Carry => carry, Underflow => underflow); 

-- Testing process
test_bench_calc_single : process  is
--begin

type pattern_type is record
--  The inputs and outputs of the shift_reg.
in1, in2, output : std_logic_vector (3 downto 0);
carry, underflow : std_logic;

end record;

--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
----------- all 4-bit adder/subtracter functionality -----------
-- ("in1", '"in2", "output", 'carry', 'underflow')
(
("1001", "1001", "1010", '0', '1'),
("1110", "0001", "1111", '0', '0'),
("0011", "1100", "1111", '0', '0'),
("0100", "1010", "1110", '0', '0'),
("1010", "0011", "1101", '0', '0'),
("0111", "0010", "0001", '1', '0'), 
("0011", "0100", "0111", '0', '0'), 
("0001", "0001", "0010", '0', '0'),
("0001", "0001", "0010", '0', '0'), 
("0001", "0100", "0101", '0', '0'), 
("0010", "0010", "0100", '0', '0'),  			
("1110", "1101", "1011", '0', '0'), 			-- neg 5
("1100", "1110", "1010", '0', '0'), 	
("0001", "0010", "0011", '0', '0'),
("0001", "0001", "0010", '0', '0'),
("1001", "1000", "1001", '0', '1'),
("0111", "0001", "0000", '1', '0')
);


variable test_result : std_logic_vector(3 downto 0) := "0000";
variable print_control : std_logic := '0';

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
in1 <= patterns(n).in1;
in2 <= patterns(n).in2;


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
assert output = patterns(n).output report "Error: bad output value" severity error;
assert carry = patterns(n).carry report "Error: bad carry value" severity error;
assert underflow = patterns(n).underflow report "Error: bad underflow value" severity error;

end loop;

assert false report "End of 4-bit integer adder/subtracter test. Passed if no errors displayed" severity note;

--  Wait forever; this will finish the simulation.
wait;

end process test_bench_calc_single;
-- End of testing process

end architecture;
-- end of bavioral test bench 