library ieee;
use ieee.std_logic_1164.all;

-- Load immediate first 
-- last 4 bits of intstruction input are assigned to an immediate value 
-- target register is determined by instr(5 downto 4)


-- have a component for the 8 bit ALU (add/sub)


entity calc_single is
port(	Inst : in std_logic_vector(8 downto 0);
			Clock : in std_logic
		);
end calc_single;

architecture behavioral of calc_single is
	-- components for the single cycle calculator 
	
	-- ALU for 8 bit adding/subtracting/loading immediates
	-- delcaration 
	component add_sub_8 
	port(	In1, In2 : in std_logic_vector(7 downto 0);
				Output : out std_logic_vector(7 downto 0)
	);
	end component add_sub_8;
	
	
	
	-- four 8 bit registers
	signal register0 : std_logic_vector(7 downto 0) := "00000000";
	signal register1 : std_logic_vector(7 downto 0) := "00000000";
	signal register2 : std_logic_vector(7 downto 0) := "00000000";
	signal register3 : std_logic_vector(7 downto 0) := "00000000";
	
	-- register addresses
	signal source_register : std_logic_vector(1 downto 0) := Inst(5 downto 4);
	signal target_register : std_logic_vector(1 downto 0) := Inst(3 downto 2);
	signal destination_register : std_logic_vector(1 downto 0) := Inst(1 downto 0);
	
	-- immediate and sign-extended immediate signals 
	signal immediate : std_logic_vector(3 downto 0) := Inst(3 downto 0);
	signal sign_extended_immediate : std_logic_vector(7 downto 0);
	
	-- instruction-type bit
	signal instruction_type : std_logic := Inst(7);
	signal op_type : std_logic := Inst(6);
	
	-- internal signals for ALU
	signal in1 : std_logic_vector(7 downto 0) := "00000000";
	signal in2 : std_logic_vector(7 downto 0) := "00000000";
	signal output : std_logic_vector(7 downto 0) := "00000000";
	
begin
	-- instantiation of component
	add_sub_8_0 : add_sub_8 port map(In1 => in1, In2 => in2, Output => output);

	-- Fetch and decode the instruction, this process should be clocked
	
	calc_process : process(Clock) is
	
	-- process variables 
	
	begin 
	
	if (rising_edge(Clock)) then 
		instruction_type <= Inst(7);		-- determine instruction type
		op_type <= Inst(6);					-- determine operation type 
		
		if (instruction_type = '0') then
			-- add/subtract instruction 
			-- source, target , destination register decode
			
			source_register <= Inst(5 downto 4);
			target_register <= Inst (3 downto 2);
			destination_register <= Inst(1 downto 0);
			
			-- set ALU inputs 
			if (source_register = "00") then in1 <= register0;
			elsif (source_register = "01") then in1 <= register1;
			elsif (source_register = "10") then in1 <= register2;
			else in1 <= register3;
			end if;
			
			
			if (target_register = "00") then in2 <= register0;
			elsif (target_register = "01") then in2 <= register1;
			elsif (target_register = "10") then in2 <= register2;
			else in2 <= register3;
			end if;
			
			-- determine write back for ALU output
			if (destination_register = "00") then register0 <= output;
			elsif (destination_register = "01") then register1 <= output;
			elsif (destination_register = "10") then register2 <= output;
			else register3 <= output;
			end if;
			
			
			--			
		else 
			-- load, print or branch instruction
			
			target_register <= Inst(5 downto 4);
			immediate <= Inst(3 downto 0);
			-- perform sign extension
			
			if (op_type = '0') then 	
				-- load immediate instruction
			
				-- the immediate must be sign extended then loaded into the target register
				-- second input of the ALU gets the sign extended immediate, add 0 to it
				in1 <= "00000000";
				in2 <= sign_extended_immediate;
		
		
				-- assign the output of ALU to target register based on address 
				if (target_register = "00") then register0 <= output;
				elsif (target_register = "01") then register1 <= output;
				elsif (target_register = "10") then register2 <= output;
				else register3 <= output;
				end if;
				
			else 
				-- branch or print instruction
				
				
			end if;
			
		end if;
		
	end if;
	
	end process calc_process;
		
	
end architecture behavioral;


