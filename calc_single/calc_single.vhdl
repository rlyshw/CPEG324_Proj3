library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Load immediate first 
-- last 4 bits of intstruction input are assigned to an immediate value 
-- target register is determined by instr(5 downto 4)

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
    port(   inst: in std_logic_vector(7 downto 0);
            clock: in std_logic;
            inst_out: out std_logic_vector(7 downto 0)
        );
    end component InstrFetch;

    -- RegisterFile component
    --  sequential circuit to control reading/writing registers
    component RegFile
        port(   rs, rt, rd : in  std_logic_vector(1 downto 0);
                rw         : in  std_logic_vector(7 downto 0);
                clk, en    : in std_logic;
                rs_content, rt_content : out std_logic_vector(7 downto 0)
            );
    end component RegFile;

    -- Print Module
    --   combination circuit to print
    component printer
        port(   en : in std_logic;
                value: in std_logic_vector(7 downto 0);
                outp: out std_logic_vector(7 downto 0)
            );
    end component printer;
    
    -- Branching hardware
    --   combinational circuit to control branching
    component brancher
        port(   skip_value : in std_logic_vector(1 downto 0);
                clk        : in std_logic;
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
    signal br_val : std_logic_vector(1 downto 0) := "00";
    signal skip_sel : std_logic := '0';

    signal adder_pos, adder_neg, adder_out : std_logic_vector(7 downto 0);

    signal pre_adder_neg,pre_adder_neg_twoscomp : std_logic_vector(7 downto 0);

    signal op_sel : std_logic_vector(2 downto 0);
    signal write_enable : std_logic := '0';
    signal print_output : std_logic_vector(7 downto 0);

    signal cin : std_logic := '0';
    signal cout : std_logic := '0';
	
begin
	-- instantiation of component
    clk <= GCLOCK when skip_sel='0' else '0';

    fetcher : InstrFetch port map(inst=>inst,clock => clk,inst_out=>instr);
    registerfile : RegFile port map(
                                  rs=>instr(5 downto 4), 
                                  rt=>instr(3 downto 2), 
                                  rd=>rd, rw=>write_content, clk=>GCLOCK,
                                  rs_content => rs_content,
                                  rt_content => rt_content,
                                  en => write_enable
                              );
	adder : entity work.adder8 
        port map(
            cin => cin,
            cout => cout,
            x0 => adder_pos(0), 
            x1 => adder_pos(1), 
            x2 => adder_pos(2), 
            x3 => adder_pos(3), 
            x4 => adder_pos(4), 
            x5 => adder_pos(5), 
            x6 => adder_pos(6), 
            x7 => adder_pos(7), 
            y0 => adder_neg(0),
            y1 => adder_neg(1),
            y2 => adder_neg(2),
            y3 => adder_neg(3),
            y4 => adder_neg(4),
            y5 => adder_neg(5),
            y6 => adder_neg(6),
            y7 => adder_neg(7),
            r0 => adder_out(0),
            r1 => adder_out(1),
            r2 => adder_out(2),
            r3 => adder_out(3),
            r4 => adder_out(4),
            r5 => adder_out(5),
            r6 => adder_out(6),
            r7 => adder_out(7)
        );
    printModule : printer port map(en=>print_enable,value=>rs_content,outp=>print_output);
    outp<=print_output;

    branchModule : brancher port map(skip_value=>br_val,clk=>GCLOCK,skip_sel=>skip_sel);

    twos_comp : twoscomp port map(inp => pre_adder_neg, outp => pre_adder_neg_twoscomp);

    op_sel <= pre_adder_neg(7)&instr(7 downto 6);
	
    -- adder_neg <= pre_adder_neg;
    write_content <= adder_out;
    write_enable <= '0' when (instr(6)='1' and instr(7)='1') else '1';

    -- MUXES EVERYWHERE
    print_enable <= '1' when ((adder_out = "00000000") and (instr(7)='1') and (instr(6)='1')) else '0'; --pr_enable mux
    rd <= instr(5 downto 4) when instr(7)='1' else instr(1 downto 0);--rd mux
    
    pre_adder_neg <= std_logic_vector(resize(signed(instr(3 downto 0)), pre_adder_neg'length)) when instr(7)='1' else rt_content;--preadder_neg mux
    adder_neg <= pre_adder_neg_twoscomp when ((pre_adder_neg(7)='0') and (instr(7)='0') and (instr(6)='1')) else pre_adder_neg;
    adder_pos <= "00000000" when instr(7)='1' else rs_content; -- the mux before the positive end of the adder
    br_val <= adder_out(1 downto 0) when ( rt_content = "00000000" and instr(7)='1' and instr(6)='1' ) else "00"; -- branch mux

end architecture behavioral;


