
HALFILES := $(wildcard src/*.v)
TESTFILES := $(wildcard test/*.v)

%-vvp.out: $(HALFILES) $(TESTFILES)
	iverilog -tvvp -Wall $(HALFILES) $(TESTFILES)

test-iverilog: test-vvp.out
	./test-vvp.out

test-yosys-ice40: $(HALFILES) $(TESTFILES)
	yosys -p 'read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog -sv $(HALFILES) $(TESTFILES); prep -top test_tb; sim;'

test-yosys-ice40-x: $(HALFILES) $(TESTFILES)
	yosys -p 'read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog -sv $(HALFILES) $(TESTFILES); prep -top test_tb; write_smt2 -wires test.smt2'
	yosys-smtbmc -t 1 --dump-vcd test.vcd test.smt2


.PHONY: test-iverilog 