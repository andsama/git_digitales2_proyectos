module probsta(
	clk_in_1,
	write_1,
	reset_1,
	error_1,
	data_in_FIFO_1,
	data_in_RAM_1,
	continue_1,
	stop_2,
	valid_2,
	end_2,
	tran_2,
	enable_2,
	full_FIFO,
	block_size,
	addr_RAM_i,
	addr_RAM_o,
	data_out_FIFO_1,
	data_out_RAM_1,
	busy,
);

	output clk_in_1;
	output write_1;
	output reset_1;
	output error_1;
	output [7:0] data_in_FIFO_1;
	output [7:0] data_in_RAM_1;
	output continue_1;
	output stop_2;
	output valid_2;
	output end_2;
	output [1:0] tran_2;
	output enable_2;
	output full_FIFO;
	output [11:0] block_size;
	output [63:0] addr_RAM_i;
	
	input [63:0] addr_RAM_o;
	input [7:0] data_out_FIFO_1;
	input [7:0] data_out_RAM_1;
	input busy;
	
reg clk_in_1 = 0;                         
	 always #1 clk_in_1 = !clk_in_1;

reg	write_1 = 0;
initial fork
#30 write_1 = 1;
#71 write_1 = 0;
#80 $finish;
join

reg	reset_1 = 0;
initial fork
#67 reset_1 = 1;
#70 reset_1 = 0;
join

reg	error_1 = 0;
initial fork
#45 error_1 = 1;
#55 error_1 = 0;
join

reg	data_in_FIFO_1 = 8'b00000000;
initial fork
#10 data_in_FIFO_1 = 8'b00000001;
#15 data_in_FIFO_1 = 8'b00000010;
#20 data_in_FIFO_1 = 8'b00000100;
#25 data_in_FIFO_1 = 8'b00001000;
#72 data_in_FIFO_1 = 8'b11100000;
#74 data_in_FIFO_1 = 8'b11111000;
#76 data_in_FIFO_1 = 8'b11111110;
join

reg	data_in_RAM_1 = 8'b10001100;
initial fork
#40 data_in_RAM_1 = 8'b10000101;
#63 data_in_RAM_1 = 8'b00100101;
#65 data_in_RAM_1 = 8'b00110101;
join

reg	continue_1 = 0;
/* initial begin
#200 $finish;
end */

reg	stop_2 = 0;
/* initial fork
#81 stop_2 = 1;
join */

reg	valid_2 = 1;
/* initial begin
#200 $finish;
end */

reg	end_2 = 1;
/* initial begin
#200 $finish;
end */

reg	tran_2 = 2'b11;
/* initial begin
#200 $finish;
end */

reg	enable_2 = 1;
/* initial begin
#200 $finish;
end */

reg	full_FIFO = 0;
/* initial begin
#200 $finish;
end */

reg	block_size = 12'b000000000011;
/* initial begin
#200 $finish;
end */

reg	addr_RAM_i = 64'h0000000000000000;
/* initial begin
#200 $finish;
end */

endmodule