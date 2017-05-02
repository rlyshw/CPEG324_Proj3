library ieee;
use ieee.std_logic_1164.all;

-- Design and implement a 8 bit integer adder/subtracter. The inputs are signed!
-- The inputs of the components are two 4-bit signal vectors, and its outputs include a 4
-- bit signed signal vector for result, 1 bit carry(overflow) signal and 1 bit underflow signal

entity regfile is
        port(   rs, rt, rd : in  std_logic_vector(1 downto 0);
                rw         : in  std_logic_vector(7 downto 0);
                clk        : in std_logic;
                rs_content, rt_content : out std_logic_vector(7 downto 0);
                en : in std_logic
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

    signal out_rs : std_logic_vector(7 downto 0); --total output wire
    signal out_rt : std_logic_vector(7 downto 0); --total output wire

    signal en1 : std_logic := '0';
    signal en2 : std_logic := '0';
    signal en3 : std_logic := '0';
    signal en4 : std_logic := '0';


begin

    reg1 : shift_reg_8 port map(I_8bit => rw, SHIFT_LEFT_INPUT_8BIT=>'0', SHIFT_RIGHT_INPUT_8BIT=>'0', sel_8bit=>"00", clock_8bit=>clk, enable_8bit=>en1, O_8bit=>reg1_out);
    reg2 : shift_reg_8 port map(I_8bit => rw, SHIFT_LEFT_INPUT_8BIT=>'0', SHIFT_RIGHT_INPUT_8BIT=>'0', sel_8bit=>"00", clock_8bit=>clk, enable_8bit=>en2, O_8bit=>reg2_out);
    reg3 : shift_reg_8 port map(I_8bit => rw, SHIFT_LEFT_INPUT_8BIT=>'0', SHIFT_RIGHT_INPUT_8BIT=>'0', sel_8bit=>"00", clock_8bit=>clk, enable_8bit=>en3, O_8bit=>reg3_out);
    reg4 : shift_reg_8 port map(I_8bit => rw, SHIFT_LEFT_INPUT_8BIT=>'0', SHIFT_RIGHT_INPUT_8BIT=>'0', sel_8bit=>"00", clock_8bit=>clk, enable_8bit=>en4, O_8bit=>reg4_out);

    rs_content <= out_rs;
    rt_content <= out_rt;

    process (clk, rs, rt, rw) is begin
        case rs is 
            when "00" => out_rs <= reg1_out;
            when "01" => out_rs <= reg2_out;
            when "10" => out_rs <= reg3_out;
            when "11" => out_rs <= reg4_out;
            when others => out_rs <= "ZZZZZZZZ";
        end case;
        case rt is 
            when "00" => out_rt <= reg1_out;
            when "01" => out_rt <= reg2_out;
            when "10" => out_rt <= reg3_out;
            when "11" => out_rt <= reg4_out;
            when others => out_rt <= "ZZZZZZZZ";
        end case;
        case rd is
            when "00" => en1 <= '0'; en2 <= '1'; en3 <= '1'; en4 <= '1';
            when "01" => en2 <= '0'; en1 <= '1'; en3 <= '1'; en4 <= '1';
            when "10" => en3 <= '0'; en2 <= '1'; en1 <= '1'; en4 <= '1';
            when "11" => en4 <= '0'; en2 <= '1'; en3 <= '1'; en1 <= '1';
            when others => en1 <= 'Z'; en2 <= 'Z'; en3 <= 'Z'; en4 <= 'Z';
        end case;
    end process;

end architecture behavioral;

