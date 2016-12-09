# Makefile

all:

	iverilog -o cmdcontrol.o cmdcontrol.v test_cmdcontrol.v testbench_cmdcontrol.v
	iverilog -o physic_block_control.o physic_block_control.v test_physic_block_control.v testbench_physic_block_control.v
	iverilog -o pad.o little_modules.v test_little_modules.v testbench_pad.v
	iverilog -o parallel_serial.o little_modules.v test_little_modules.v testbench_parallel_serial.v

	vvp cmdcontrol.o
	vvp physic_block_control.o
	vvp pad.o
	vvp parallel_serial.o

	#gtkwave testbench_cmdcontrol.vcd
	gtkwave cmdcontrol.gtkw

	#gtkwave testbench_physic_block_control.vcd
	#gtkwave physic_block_control.gtkw

	#gtkwave testbench_pad.vcd

	#gtkwave testbench_parallel_serial.vcd

clean:
	rm *.vcd *.o
