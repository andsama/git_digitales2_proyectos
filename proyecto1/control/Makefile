# Makefile

all:
	iverilog -o cmdblock.o cmdblock.v cmdcontrol.v physic_block_control.v little_modules.v test_cmdblock.v testbench_cmdblock.v
	vvp cmdblock.o
	gtkwave cmdblock.gtkw
	
controlcmd:
	iverilog -o cmdcontrol.o cmdcontrol.v test_cmdcontrol.v testbench_cmdcontrol.v
	vvp cmdcontrol.o
	gtkwave cmdcontrol.gtkw
	
physic:
	iverilog -o physic_block_control.o physic_block_control.v test_physic_block_control.v testbench_physic_block_control.v
	vvp physic_block_control.o
	gtkwave physic_block_control.gtkw
	
pts:
	iverilog -o parallel_serial.o little_modules.v test_little_modules.v testbench_parallel_serial.v
	vvp parallel_serial.o
	gtkwave parallel_serial.gtkw

stp:
	iverilog -o serial_parallel.o little_modules.v test_little_modules.v testbench_serial_parallel.v
	vvp serial_parallel.o
	gtkwave serial_parallel.gtkw

clean:
	rm *.vcd *.o
