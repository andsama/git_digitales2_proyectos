module tbsta;

wire clk_in_1c, write_1c, reset_1c, error_1c, continue_1c, stop_2c, valid_2c, end_2c, enable_2c, full_FIFOc, busyc;
wire [7:0] data_in_FIFO_1c, data_in_RAM_1c, data_out_FIFO_1c, data_out_RAM_1c;
wire [1:0] tran_2c;
wire [11:0] block_sizec;
wire [63:0] addr_RAM_ic, addr_RAM_oc;

states sta1(
	.clk_in_1 (clk_in_1c),
	.write_1 (write_1c),
	.reset_1 (reset_1c),
	.error_1 (error_1c),
	.data_in_FIFO_1 (data_in_FIFO_1c),
	.data_in_RAM_1 (data_in_RAM_1c),
	.continue_1 (continue_1c),
	.stop_2 (stop_2c),
	.valid_2 (valid_2c),
	.end_2 (end_2c),
	.tran_2 (tran_2c),
	.enable_2 (enable_2c),
	.full_FIFO(full_FIFOc),
	.block_size(block_sizec),
	.addr_RAM_i(addr_RAM_ic),
	.addr_RAM_o(addr_RAM_oc),
	.data_out_FIFO_1 (data_out_FIFO_1c),
	.data_out_RAM_1 (data_out_RAM_1c),
	.busy(busyc)
);

probsta sta2(
	.clk_in_1 (clk_in_1c),
	.write_1 (write_1c),
	.reset_1 (reset_1c),
	.error_1 (error_1c),
	.data_in_FIFO_1 (data_in_FIFO_1c),
	.data_in_RAM_1 (data_in_RAM_1c),
	.continue_1 (continue_1c),
	.stop_2 (stop_2c),
	.valid_2 (valid_2c),
	.end_2 (end_2c),
	.tran_2 (tran_2c),
	.enable_2 (enable_2c),
	.full_FIFO(full_FIFOc),
	.block_size(block_sizec),
	.addr_RAM_i(addr_RAM_ic),
	.addr_RAM_o(addr_RAM_oc),
	.data_out_FIFO_1 (data_out_FIFO_1c),
	.data_out_RAM_1 (data_out_RAM_1c),
	.busy(busyc)
);

initial begin
	$dumpfile("state.vcd");   
    $dumpvars;
end

endmodule