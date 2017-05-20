library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Debounce is
  Port (
    CLK_Internal : in  STD_LOGIC;
    InstCLK : in  STD_LOGIC;
    out_btn : out  STD_LOGIC
  );
end Debounce;

architecture Behavioral of Debounce is
	signal Q1, Q2, Q3 : std_logic;

signal tmrCntr : std_logic_vector(26 downto 0) := (others => '0');
constant TMR_CNTR_MAX : std_logic_vector(26 downto 0) := "000000001011110000100000000"; 

	signal f2hz : std_logic;

begin

clock_2hz : process (CLK_Internal)
begin
    if (rising_edge(CLK_Internal)) then
        if (tmrCntr = TMR_CNTR_MAX) then
            tmrCntr <= (others => '0');
			f2hz <= not f2hz;                
        else
            tmrCntr <= tmrCntr + 1;
        end if;
        end if;
end process;

process(f2hz)
begin

   if (rising_edge(f2hz)) then

         Q1 <= InstCLK;

         Q2 <= Q1;

         Q3 <= Q2;

      end if;

end process;

out_btn <= Q1 and Q2 and (not Q3);

end Behavioral;
