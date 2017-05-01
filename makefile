test: calc_tb

calc_tb: add_sub_8.o calc_single.o calc_single_tb.o #InstrFetch RegFile printer brancher twoscomp
	ghdl -e --ieee=standard calc_single_tb
	ghdl -r --ieee=standard calc_single_tb

add_sub_8.o: ../add_sub_8/add_sub_8.vhdl
	ghdl -a --ieee=standard ../add_sub_8/add_sub_8.vhdl

calc_single.o: ../calc_single/calc_single.vhdl
	ghdl -a --ieee=standard ../calc_single/calc_single.vhdl

calc_single_tb.o: ../calc_single/calc_single_tb.vhdl
	ghdl -a --ieee=standard ../calc_single/calc_single_tb.vhdl

clean:
	rm *.o *.cf calc_single_tb
