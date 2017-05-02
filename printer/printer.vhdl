library ieee;
use ieee.std_logic_1164.all;

-- Design and implement a 8 bit integer adder/subtracter. The inputs are signed!
-- The inputs of the components are two 4-bit signal vectors, and its outputs include a 4
-- bit signed signal vector for result, 1 bit carry(overflow) signal and 1 bit underflow signal

entity printer is
	port(   en : in std_logic;
			value: in std_logic_vector(7 downto 0)
		);
end printer;

architecture behavioral of printer is	
begin
	process(en) is begin
        if(en = '1') then
            for i in 0 to value'LENGTH-1 loop
                report std_logic'image(value(i)) severity note;
            end loop;
        end if;
	end process;
end architecture behavioral;

