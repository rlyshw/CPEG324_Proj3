library ieee;
use ieee.std_logic_1164.all;

-- Design and implement a 8 bit integer adder/subtracter. The inputs are signed!
-- The inputs of the components are two 4-bit signal vectors, and its outputs include a 4
-- bit signed signal vector for result, 1 bit carry(overflow) signal and 1 bit underflow signal

entity printer is
	port( en : in std_logic;
			value: in std_logic_vector(7 downto 0);
			CLK_Internal : in std_logic;
			GCLOCK : in std_logic;
         SSEG_CA : out  STD_LOGIC_VECTOR (7 downto 0);
         SSEG_AN : out  STD_LOGIC_VECTOR (3 downto 0)
		);
end printer;

architecture behavioral of printer is	

component SSD 
    Port ( Val : in  STD_LOGIC_VECTOR (7 downto 0);
			  CLK_Internal : in  STD_LOGIC;
			  Enable : in STD_LOGIC;
			  Is_neg : in std_logic;
           SSEG_CA : out  STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN : out  STD_LOGIC_VECTOR (3 downto 0));
end component SSD;

component twoscomp
	port( inp : in std_logic_vector(7 downto 0);
		  outp : out std_logic_vector(7 downto 0)
		);
end component twoscomp;


signal clock_switch : std_logic;
signal twos_comp_convert : std_logic_vector(7 downto 0);
signal true_print_val : std_logic_vector(7 downto 0);

begin

print_converter : twoscomp port map(inp => value, outp => twos_comp_convert);
ssd_display : SSD port map(Val => true_print_val, CLK_Internal => clock_switch, Enable => en, 
Is_neg => value(7), SSEG_CA => SSEG_CA, SSEG_AN => SSEG_AN);


	true_print_val <= value when value(7) = '0' else twos_comp_convert;
	
	process(GCLOCK) is begin
        if(en = '1') then
				clock_switch <= CLK_Internal;
			else
				clock_switch <= '0';
				
        end if;
	end process;
end architecture behavioral;

