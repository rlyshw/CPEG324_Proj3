library ieee;
use ieee.std_logic_1164.all;

-- Design and implement a 8 bit integer adder/subtracter. The inputs are signed!
-- The inputs of the components are two 4-bit signal vectors, and its outputs include a 4
-- bit signed signal vector for result, 1 bit carry(overflow) signal and 1 bit underflow signal

entity add_sub_8 is
port(	In1, In2:	in std_logic_vector (7 downto 0);		-- signed 8 bit input signals 
			Output : out std_logic_vector (7 downto 0)		-- signed 8 bit output signal
);
end add_sub_8;

architecture behavioral of add_sub_8 is
	
	-- declare signals needed here
	signal adder_contents : std_logic_vector(7 downto 0) := "00000000";
	
begin
	-- calculate the result of the addition or subtraction 
	compute_output : process(In1, In2) is
	
	variable temp_carry, conversion_carry, In1_neg, In2_neg, convert_output : std_logic := '0';
	
	variable temp_In1, temp_In2, twos_comp_In1, twos_comp_In2, 
	temp_output, output_buffer : std_logic_vector(7 downto 0) := "00000000";
	
	begin 
	
	temp_carry := '0';
	
	-- first check if either of the inputs is negative 
	if (In1(7) = '1') then 
		In1_neg := '1';
		for  i in 0 to 6 loop
			temp_In1(i) := not In1(i);			-- negate the bits up to the signed bit
		end loop;
		
		conversion_carry := '1';
		
		for j in 0 to 6 loop						--  add a '1'
			twos_comp_In1(j) := temp_In1(j) xor conversion_carry;
			conversion_carry := conversion_carry and temp_In1(j);
		end loop;
		twos_comp_In1(7) := In1(7);
		
	end if;
		
	if (In2(7) = '1') then 
		In2_neg := '1';
			for  i in 0 to 6 loop
			temp_In2(i) := not In2(i);			-- negate the bits up to the signed bit
		end loop;
		
		conversion_carry := '1';
		
		for j in 0 to 6 loop						--  add a '1'
			twos_comp_In2(j) := temp_In2(j) xor conversion_carry;
			conversion_carry := conversion_carry and temp_In2(j);
		end loop;
		twos_comp_In2(7) := In2(7);
		
	end if;
	
	-- compute the output signal with new values 
	convert_output := '0';
	
	if ((In1_neg = '0') and (In2_neg = '0')) then 			-- both numbers positive (add unmodified inputs)
		temp_carry := '0';			-- insure that nothing is being carried into the adder
		for k in 0 to 6 loop
			adder_contents(k) <= In1(k) xor In2(k) xor temp_carry;
			temp_carry := ((In1(k) and temp_carry) or (In2(k) and temp_carry) or (In1(k) and In2(k)));
	
		end loop;
		
		adder_contents(7) <= '0';
	
	elsif ((In1_neg = '1') and (In2_neg = '0')) then 
		temp_carry := '0';			-- insure that nothing is being carried into the adder
		for k in 0 to 6 loop
			adder_contents(k) <= In1(k) xor In2(k) xor temp_carry;
			temp_carry := ((In1(k) and temp_carry) or (In2(k) and temp_carry) or 
			(In1(k) and In2(k)));
	
		end loop;
		
		In1_neg := '0';
		In2_neg := '0';
	
	elsif ((In1_neg = '0') and (In2_neg = '1')) then 
		temp_carry := '0';			-- insure that nothing is being carried into the adder
		for k in 0 to 6 loop
			adder_contents(k) <= In1(k) xor In2(k) xor temp_carry;
			temp_carry := ((In1(k) and temp_carry) or (In2(k) and temp_carry) or 
			(In1(k) and In2(k)));
	
		end loop;
		
		In1_neg := '0';
		In2_neg := '0';
		
	else 													-- both numbers negative (add two's complement of inputs)
		convert_output := '1';
		temp_carry := '0';			-- insure that nothing is being carried into the adder
		for k in 0 to 6 loop
			temp_output(k) := twos_comp_In1(k) xor twos_comp_In2(k) xor temp_carry;
			temp_carry := ((twos_comp_In1(k) and temp_carry) or 
			(twos_comp_In2(k) and temp_carry) or (twos_comp_In1(k) and twos_comp_In2(k)));
	
		end loop;
		
	--
	
		In1_neg := '0';
		In2_neg := '0';
	
	end if;
	
	if (convert_output = '1') then 
		convert_output := '0';
		for i in 0 to 6 loop
			output_buffer(i) := not temp_output(i);
		end loop;
		
		conversion_carry := '1';
		
		for j in 0 to 6 loop						--  add a '1'
			adder_contents(j) <= output_buffer(j) xor conversion_carry;
			conversion_carry := output_buffer(j) and conversion_carry;
		end loop;
		
		adder_contents(7) <= '1';
	
	end if;

	end process compute_output;
	
	Output <= adder_contents;

end architecture behavioral;

