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

    signal reg1_out : std_logic_vector(7 downto 0);
    signal reg2_out : std_logic_vector(7 downto 0);
    signal reg3_out : std_logic_vector(7 downto 0);
    signal reg4_out : std_logic_vector(7 downto 0);

    signal en1 : std_logic;
    signal en2 : std_logic;
    signal en3 : std_logic;
    signal en4 : std_logic;


begin

    reg1 : shift_reg_8 port map(I_8bit => rw, SHIFT_LEFT_INPUT_8BIT=>'0', SHIFT_RIGHT_INPUT_8BIT=>'0', sel_8bit=>"00", clock_8bit=>clk, enable_8bit=>en1, O_8bit=>reg1_out);
    reg2 : shift_reg_8 port map(I_8bit => rw, SHIFT_LEFT_INPUT_8BIT=>'0', SHIFT_RIGHT_INPUT_8BIT=>'0', sel_8bit=>"00", clock_8bit=>clk, enable_8bit=>en2, O_8bit=>reg2_out);
    reg3 : shift_reg_8 port map(I_8bit => rw, SHIFT_LEFT_INPUT_8BIT=>'0', SHIFT_RIGHT_INPUT_8BIT=>'0', sel_8bit=>"00", clock_8bit=>clk, enable_8bit=>en3, O_8bit=>reg3_out);
    reg4 : shift_reg_8 port map(I_8bit => rw, SHIFT_LEFT_INPUT_8BIT=>'0', SHIFT_RIGHT_INPUT_8BIT=>'0', sel_8bit=>"00", clock_8bit=>clk, enable_8bit=>en4, O_8bit=>reg4_out);

    process (clk) is begin
        case rs is 
            when "00" => rs_content <= reg1_out;
            when "01" => rs_content <= reg2_out;
            when "10" => rs_content <= reg3_out;
            when "11" => rs_content <= reg4_out;
            when others => rs_content <= "ZZZZZZZZ";
        end case;
        case rt is 
            when "00" => rt_content <= reg1_out;
            when "01" => rt_content <= reg2_out;
            when "10" => rt_content <= reg3_out;
            when "11" => rt_content <= reg4_out;
            when others => rt_content <= "ZZZZZZZZ";
        end case;
        case rd is
            when "00" => en1 <= '1'; en2 <= '0'; en3 <= '0'; en4 <= '0';
            when "01" => en2 <= '1'; en1 <= '0'; en3 <= '0'; en4 <= '0';
            when "10" => en3 <= '1'; en2 <= '0'; en1 <= '0'; en4 <= '0';
            when "11" => en4 <= '1'; en2 <= '0'; en3 <= '0'; en1 <= '0';
            when others => en1 <= 'Z'; en2 <= 'Z'; en3 <= 'Z'; en4 <= 'Z';
        end case;
    end process;

end architecture behavioral;

