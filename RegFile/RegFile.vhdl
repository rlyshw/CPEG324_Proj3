library ieee;
use ieee.std_logic_1164.all;

-- Design and implement a 8 bit integer adder/subtracter. The inputs are signed!
-- The inputs of the components are two 4-bit signal vectors, and its outputs include a 4
-- bit signed signal vector for result, 1 bit carry(overflow) signal and 1 bit underflow signal

entity regfile is
        port(   rs, rt, rd : in  std_logic_vector(1 downto 0);
                rw         : in  std_logic_vector(7 downto 0);
                clk        : in std_logic;
                rs_content, rt_content : out std_logic_vector(7 downto 0)
            );
end regfile;

architecture behavioral of regfile is
    component shift_reg_8 is
        port(	I_8bit :	in std_logic_vector (7 downto 0);
                SHIFT_LEFT_INPUT_8BIT: in std_logic;				-- replaces the newly vacant rightmost bit
                SHIFT_RIGHT_INPUT_8BIT: in std_logic;				-- replaces the newly vacant leftmost bit
                sel_8bit : in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
                clock_8bit : in std_logic;							-- positive level triggering in problem 3
                enable_8bit : in std_logic;							 -- 0: don't do anything; 1: shift_reg is enabled
                O_8bit : out std_logic_vector(7 downto 0)
        );
    end component;
begin

    process (clk) is begin

end architecture behavioral;

