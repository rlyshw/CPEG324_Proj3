----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:34:59 05/17/2017 
-- Design Name: 
-- Module Name:    display_converter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Developed with help from StackOverflow
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity bin8bcd is
    port (
        bin:    in  std_logic_vector (7 downto 0);
        bcd:    out std_logic_vector (11 downto 0)
    );
end entity;

architecture behavioral of bin8bcd is

    procedure add3 (signal bin: in  std_logic_vector (3 downto 0); 
                    signal bcd: out std_logic_vector (3 downto 0)) is
    
	 variable is_gt_4:  std_logic;
    
	 begin
        is_gt_4 := bin(3) or (bin(2) and (bin(1) or bin(0)));

        if is_gt_4 = '1' then
        -- if the binary number is > 4, you need to add 3
            
				bcd <= std_logic_vector(unsigned(bin) + "0011");
        else
            
				bcd <= bin;
        
		  end if;
    end procedure;

    signal U0bin,U1bin,U2bin,U3bin,U4bin,U5bin,U6bin : std_logic_vector (3 downto 0);

    signal U0bcd,U1bcd,U2bcd,U3bcd,U4bcd,U5bcd,U6bcd : std_logic_vector (3 downto 0);       
begin
	
	-- assign partitions, start with first 3 bits of binary number and concatinate
   U0bin <= '0' & bin (7 downto 5);
	 
   U1bin <= U0bcd(2 downto 0) & bin(4);
    
	U2bin <= U1bcd(2 downto 0) & bin(3);
    
	U3bin <= U2bcd(2 downto 0) & bin(2);
    
	U4bin <= U3bcd(2 downto 0) & bin(1);

   U5bin <= '0' & U0bcd(3) & U1bcd(3) & U2bcd(3);
    
	U6bin <= U5bcd(2 downto 0) & U3bcd(3);

	U0: add3(U0bin,U0bcd);

	U1: add3(U1bin,U1bcd);

	U2: add3(U2bin,U2bcd);

	U3: add3(U3bin,U3bcd);

	U4: add3(U4bin,U4bcd);

	U5: add3(U5bin,U5bcd);

	U6: add3(U6bin,U6bcd);

	OUTP: bcd <= '0' & '0' & U5bcd(3) & U6bcd & U4bcd & bin(0);

end architecture behavioral;

