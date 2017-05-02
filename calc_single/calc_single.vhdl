library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Load immediate first 
-- last 4 bits of intstruction input are assigned to an immediate value 
-- target register is determined by instr(5 downto 4)


-- have a component for the 8 bit ALU (add/sub)


entity calc_single is
port(	Inst : in std_logic_vector(7 downto 0);
	    GCLOCK : in std_logic; --global clock
        outp  : out std_logic_vector(7 downto 0)
		);
end calc_single;

architecture behavioral of calc_single is
    --internal components

	-- ALU for 8 bit adding/subtracting/loading immediates
	component add_sub_8 
	port(	In1, In2 : in std_logic_vector(7 downto 0);
				Output : out std_logic_vector(7 downto 0)
	);
    end component add_sub_8;

    -- InstrFetch component
    --  sequential(?) circuit to retrieve instructions
    component InstrFetch
    port(   clock: in std_logic;
            instr: out std_logic_vector(7 downto 0)
        );
    end component InstrFetch;

    -- RegisterFile component
    --  sequential circuit to control reading/writing registers
    component RegFile
        port(   rs, rt, rd : in  std_logic_vector(1 downto 0);
                rw         : in  std_logic_vector(7 downto 0);
                clk        : in std_logic;
                rs_content, rt_content : out std_logic_vector(7 downto 0)
            );
    end component RegFile;

    -- Print Module
    --   combination circuit to print
    component printer
        port(   en : in std_logic;
                value: in std_logic_vector(7 downto 0)
            );
    end component printer;
    
    -- Branching hardware
    --   combinational circuit to control branching
    component brancher
        port(   skip_value : in std_logic_vector(1 downto 0);
                clk        : out std_logic;
                skip_sel   : out std_logic
            );
    end component brancher;

    component twoscomp
        port( inp : in std_logic_vector(7 downto 0);
              outp : out std_logic_vector(7 downto 0)
            );
    end component twoscomp;
    
    signal clk : std_logic := '0';
    signal instr : std_logic_vector(7 downto 0);
    signal rd : std_logic_vector(1 downto 0);
    signal write_content,rs_content, rt_content : std_logic_vector(7 downto 0);
    signal print_enable : std_logic := '0';
    signal br_val : std_logic_vector(1 downto 0);
    signal skip_sel : std_logic := '0';

    signal adder_pos, adder_neg, adder_out : std_logic_vector(7 downto 0);

    signal pre_adder_neg,pre_adder_neg_twoscomp : std_logic_vector(7 downto 0);

    signal op_sel : std_logic_vector(2 downto 0);
	
begin
	-- instantiation of component
    clk <= GCLOCK;
    fetcher : InstrFetch port map(clock => clk);
    registerfile : RegFile port map(
                                  rs=>instr(5 downto 4), 
                                  rt=>instr(3 downto 2), 
                                  rd=>rd, rw=>write_content, clk=>GCLOCK,
                                  rs_content => rs_content,
                                  rt_content => rt_content
                              );
    adder : add_sub_8 port map( In1 => adder_pos, In2 => adder_neg, Output => adder_out);
    printModule : printer port map(en=>print_enable,value=>rt_content);

    branchModule : brancher port map(skip_value=>br_val,clk=>clk,skip_sel=>skip_sel);

    twos_comp : twoscomp port map(inp => pre_adder_neg, outp => pre_adder_neg_twoscomp);

    op_sel <= pre_adder_neg(7)&instr(7 downto 6);
	
    --all the modules defined, wire it up
     calc_process : process(GCLOCK) is begin
        case instr(7) is --RD_SEL mux
            when '1' => rd <= instr(3 downto 2);
            when '0' => rd <= instr(1 downto 0);
            when others => rd <= "ZZ";
        end case;

        case instr(7) is  --adder_pos mux
            when '0' => adder_pos <= rs_content;
            when '1' => adder_pos <= "00000000";
            when others => adder_pos <= "ZZZZZZZZ";
        end case;

        case instr(7) is --val_sel
            when '0' => pre_adder_neg <= rt_content;
            when '1' => pre_adder_neg <= std_logic_vector(resize(signed(instr(3 downto 0)), pre_adder_neg'length)); --immediate value
            when others => pre_adder_neg <= "ZZZZZZZZ";
        end case;

        case op_sel is -- this is the mux before the adder's negative terminal, it depends on the sign of rt_content
            when "001" => adder_neg <= pre_adder_neg_twoscomp;
            when others => adder_neg <= rt_content;
        end case;

        if (adder_out = "0000000" and instr(7)='1' and instr(6)='1') then -- print module enable
            print_enable <= '1';
        else
            print_enable <= '0';
        end if;

        if( rt_content = "0000000000" and instr(7)='1' and instr(6)='1' ) then -- branching mux
            br_val <= adder_out(1 downto 0);
        else 
            br_val <= "00";
        end if;

        case skip_sel is -- IF clock MUX
            when '0' => clk <= clk;
            when '1' => clk <= '0';
            when others => clk <= 'Z';
        end case;

    end process;

end architecture behavioral;


