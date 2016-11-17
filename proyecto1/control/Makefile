# Makefile

all:

	iverilog -o cmd.o cmd.v test_cmd.v testbench_cmd.v

	vvp cmd.o

	#gtkwave testbench_cmd.vcd
	gtkwave cmd.gtkw

clean:
	rm *.vcd *.o
