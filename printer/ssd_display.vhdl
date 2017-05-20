library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--The IEEE.std_logic_unsigned contains definitions that allow
--std_logic_vector types to be used with the + operator to instantiate a
--counter
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( Val : in  STD_LOGIC_VECTOR (7 downto 0);
			  CLK_Internal : in  STD_LOGIC;
			  Enable : in STD_LOGIC;
			  Is_neg : in std_logic;
           SSEG_CA : out  STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN : out  STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is


component bin8bcd 
    port (
        bin:    in  std_logic_vector (7 downto 0);
        bcd:    out std_logic_vector (11 downto 0)
    );
end component bin8bcd;

signal displayIndex : std_logic_vector(1 downto 0) := (others => '0');

signal tmrCntr : std_logic_vector(26 downto 0) := (others => '0');
constant TMR_CNTR_MAX : std_logic_vector(26 downto 0) := "000000001011110000100000000"; --"100,000,000 = clk cycles per second^

signal digitBuf : std_logic_vector(15 downto 0) := (others => '0');
signal digit : std_logic_vector(3 downto 0) := (others => '0');

signal annode_control : std_logic_vector(3 downto 0);
signal bcd_holder : std_logic_vector(11 downto 0);
signal neg_sign : std_logic_vector(3 downto 0);
signal display_off : std_logic_vector(11 downto 0);


begin

converter : bin8bcd port map(bin => Val, bcd => bcd_holder);

neg_sign <= "1111" when Is_neg = '1' else "1110";

display_off <= bcd_holder;


digitBuf(3 downto 0) <= neg_sign when display_off(11 downto 8) /= "0000" else "1110";	
digitBuf(7 downto 4) <= bcd_holder(11 downto 8) when display_off(11 downto 8) /= "0000" 
	else neg_sign when display_off(7 downto 4) /= "0000" else "1110"; 
digitBuf(11 downto 8) <= bcd_holder(7 downto 4) when display_off(11 downto 4) /= "00000000" else neg_sign; --"1110";
digitBuf(15 downto 12) <= bcd_holder(3 downto 0); 
	


-- modify digitbuf at various indices to make display correct

with displayIndex select
-- Selects which segment of the buffer to use for displaying digit
	digit <= digitBuf (3 downto 0) when "00",
				digitBuf (7 downto 4) when "01",
				digitBuf (11 downto 8) when "10",
				digitBuf (15 downto 12) when "11";
			
with digit select
-- Selects which cathode to activate for display
	SSEG_CA <= "11000000" when "0000",
				"11111001" when "0001",	--1
				"10100100" when "0010", --2
				"10110000" when "0011",	--3
				"10011001" when "0100", --4
				"10010010" when "0101",	--5
				"10000010" when "0110", --6
				"11111000" when "0111",	--7
				"10000000" when "1000", --8
				"10010000" when "1001",	--9
				"10100100" when "1010", --A
				"10000000" when "1011", --B
				"11000110" when "1100",	--C
				
				"10111111" when "1111", -- minus sign (-) 
				"11111111" when others;
			
with displayIndex select
-- Selects which annode to activate for display
	annode_control <= "1110" when "00",
				"1101" when "01",
				"1011" when "10",
				"0111" when "11",
				"1111" when others;
				
SSEG_AN <= annode_control when Enable = '1' else "1111";
				 
display_process : process (CLK_Internal)
-- This controls the frequency at which each digit in the SSD is illuminated.
-- Only one digit (at current display index) is displayed at a time.
begin
	if (rising_edge(CLK_Internal)) then
        if (tmrCntr = TMR_CNTR_MAX) then
            tmrCntr <= (others => '0');
			
				if (displayIndex >= 3) then
					displayIndex <= (others => '0');
				else 
					displayIndex <= displayIndex + 1;
				end if;
        else
            tmrCntr <= tmrCntr + 1;
        end if;
		end if;
end process;

end Behavioral;