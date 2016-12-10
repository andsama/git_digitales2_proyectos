`include "signal.v"
`include "stma.v"

module DMA(
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

	input clk_in_COM;
	input write_in_COM;
	input [95:0] addr_in_COM;
	input reset_in_COM;
	input error_in_COM;
	input [7:0] data_in_RAM;
	input [7:0] data_in_FIFO;
	input full_FIFO;
	input [11:0] block_size_REG;
	input continue_block_gap_REG;
	input stop_block_gap_REG;
	input enable_transfer_mode_REG;
	input transfer_complete_DAT;
	
	output [63:0] addr_out_RAM;
	output [7:0] data_out_RAM;
	output [7:0] data_out_FIFO;
	output busy;
	output reg newDAT_DAT;

wire valid_OUT_c, End_OUT_c;
wire [1:0] trans_c;
wire [63:0] addr_RAM_c;
	
signals sig1(
			 .clk (clk_in_COM),
			 .valid_IN (addr_in_COM[0]),
			 .End_IN (addr_in_COM[1]),
			 .act1_IN (addr_in_COM[4]),
			 .act2_IN (addr_in_COM[5]),
			 .addr_COM (addr_in_COM[95:32]),
			 .valid_OUT (valid_OUT_c),
			 .End_OUT (End_OUT_c),
			 .addr_RAM (addr_RAM_c),
			 .trans (trans_c)
);

always @(posedge clk_in_COM) begin
	newDAT_DAT <= 0;
	if(data_in_RAM!=0) begin
		newDAT_DAT <= 1;
	end else begin
		newDAT_DAT <=0;
	end
	
end

states sta1(
			.clk_in_1 (clk_in_COM),
			.write_1 (write_in_COM),
			.reset_1 (reset_in_COM),
			.error_1 (error_in_COM),
			.data_in_FIFO_1 (data_in_FIFO),
			.data_in_RAM_1 (data_in_RAM),
			.continue_1 (continue_block_gap_REG),
			.stop_2 (stop_block_gap_REG),
			.valid_2 (valid_OUT_c),
			.end_2 (End_OUT_c),
			.tran_2 (trans_c),
			.enable_2 (enable_transfer_mode_REG),
			.full_FIFO (full_FIFO),
			.block_size (block_size_REG),
			.addr_RAM_i (addr_RAM_c),
			.addr_RAM_o (addr_out_RAM),
			.data_out_FIFO_1 (data_out_FIFO),
			.data_out_RAM_1 (data_out_RAM),
			.busy (busy)
);

/*
variables internas: Módulo signal.v
continue, stop --> Block gap
valid, End, act1, act2 --> datos_in
enable --> transfer mode register
*/ 



endmodule









