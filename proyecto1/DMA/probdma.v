module probdma(
	clk_in_COM,               // COMP
	write_in_COM,             // COMP
	addr_in_COM,              // COMP
	reset_in_COM,             // COMP
	error_in_COM,             // COMP
	data_in_RAM,			  // RAM
	data_in_FIFO,             // FIFO
	full_FIFO,                // FIFO
	block_size_REG,           // Register
	continue_block_gap_REG,   // Register 
	stop_block_gap_REG,       // Register 
	enable_transfer_mode_REG, // Register
	transfer_complete_DAT,    // Datos
	addr_out_RAM,             // RAM
	data_out_RAM,             // RAM
	data_out_FIFO,            // FIFO
	busy,                     // COMP
	newDAT_DAT                // Datos
);

	output clk_in_COM;
	output write_in_COM;
	output [95:0] addr_in_COM;
	output reset_in_COM;
	output error_in_COM;
	output [7:0] data_in_RAM;
	output [7:0] data_in_FIFO;
	output full_FIFO;
	output [11:0] block_size_REG;
	output continue_block_gap_REG;
	output stop_block_gap_REG;
	output enable_transfer_mode_REG;
	output transfer_complete_DAT;
	
	input [63:0] addr_out_RAM;
	input [7:0] data_out_RAM;
	input [7:0] data_out_FIFO;
	input busy;
	input newDAT_DAT;
	
reg clk_in_COM = 0;                         
	always #1 clk_in_COM = !clk_in_COM;

reg	write_in_COM = 1;
initial fork
#60 write_in_COM = 0;
#80 write_in_COM = 1;
#100 $finish;
join

reg	addr_in_COM = 96'h000001000000111100000033;
/* initial fork
#200 $finish;
join */

reg	reset_in_COM = 0;
/* initial fork
#200 $finish;
join */

reg	error_in_COM = 0;
initial fork
#30 error_in_COM = 1;
#40 error_in_COM = 0;
join

reg	data_in_RAM = 8'b00001100;
initial fork
#10 data_in_RAM = 8'b00001101;
join

reg	data_in_FIFO = 8'b01100000;
initial fork
#60 data_in_FIFO = 8'b01100100;
#65 data_in_FIFO = 8'b00001100;
#75 data_in_FIFO = 8'b01110101;
join 

reg	full_FIFO = 0;
initial fork
#10 full_FIFO = 1;
#25 full_FIFO = 0;
join

reg	block_size_REG = 12'b000000000011;
/* initial fork
#200 $finish;
join */

reg	continue_block_gap_REG = 0;
/* initial fork
#200 $finish;
join */

reg	stop_block_gap_REG = 0;
/* initial fork
#200 $finish;
join */

reg	enable_transfer_mode_REG = 1;
/* initial fork
#200 $finish;
join */

reg	transfer_complete_DAT = 0;
/* initial fork
#200 $finish;
join */

endmodule