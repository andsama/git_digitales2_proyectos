# Makefile

all:

	iverilog -o cmd.o cmd.v test_cmd.v testbench_cmd.v
	iverilog -o physic_block_control.o physic_block_control.v test_physic_block_control.v testbench_physic_block_control.v

	vvp cmd.o
	vvp physic_block_control.o

	#gtkwave testbench_cmd.vcd
	#gtkwave cmd.gtkw

	#gtkwave testbench_physic_block_control.vcd
	gtkwave physic_block_control.gtkw

clean:
	rm *.vcd *.o
