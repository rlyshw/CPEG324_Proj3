library ieee;
use ieee.std_logic_1164.all;

-- Design and implement a 8 bit integer adder/subtracter. The inputs are signed!
-- The inputs of the components are two 4-bit signal vectors, and its outputs include a 4
-- bit signed signal vector for result, 1 bit carry(overflow) signal and 1 bit underflow signal

entity twoscomp is
	port( inp : in std_logic_vector(7 downto 0);
		  outp : out std_logic_vector(7 downto 0)
		);
end twoscomp;

architecture behavioral of twoscomp is
	signal cin: std_logic := '0';
    signal cout : std_logic:= '0';
	signal temp : std_logic_vector(8-1 downto 0);
begin
	temp    <= not inp;
	adder : entity work.adder8 
        port map(
            cin => cin,
            cout => cout,
            x0 => temp(0), 
            x1 => temp(1), 
            x2 => temp(2), 
            x3 => temp(3), 
            x4 => temp(4), 
            x5 => temp(5), 
            x6 => temp(6), 
            x7 => temp(7), 
            y0 => '1',
            y1 => '0',
            y2 => '0',
            y3 => '0',
            y4 => '0',
            y5 => '0',
            y6 => '0',
            y7 => '0',
            r0 => outp(0),
            r1 => outp(1),
            r2 => outp(2),
            r3 => outp(3),
            r4 => outp(4),
            r5 => outp(5),
            r6 => outp(6),
            r7 => outp(7)
        );
	
end architecture behavioral;

