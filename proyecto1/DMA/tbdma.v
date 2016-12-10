module tbdma;

wire clk_in_COMc, write_in_COMc, reset_in_COMc, error_in_COMc, full_FIFOc,continue_block_gap_REGc, stop_block_gap_REGc, enable_transfer_mode_REGc, transfer_complete_DATc, busyc, newDAT_DATc;

wire [7:0] data_in_RAMc, data_in_FIFOc, data_out_RAMc, data_out_FIFOc;

wire [11:0] block_size_REGc;

wire [63:0] addr_out_RAMc;

wire [95:0] addr_in_COMc;

DMA d1(
	.clk_in_COM (clk_in_COMc),
	.write_in_COM (write_in_COMc),
	.addr_in_COM (addr_in_COMc),
	.reset_in_COM (reset_in_COMc),
	.error_in_COM (error_in_COMc),
	.data_in_RAM (data_in_RAMc),
	.data_in_FIFO (data_in_FIFOc),
	.full_FIFO (full_FIFOc),
	.block_size_REG (block_size_REGc),
	.continue_block_gap_REG (continue_block_gap_REGc),
	.stop_block_gap_REG (stop_block_gap_REGc),
	.enable_transfer_mode_REG (enable_transfer_mode_REGc),
	.transfer_complete_DAT (transfer_complete_DATc),
	.addr_out_RAM (addr_out_RAMc),
	.data_out_RAM (data_out_RAMc),
	.data_out_FIFO (data_out_FIFOc),
	.busy (busyc),
	.newDAT_DAT(newDAT_DATc)
);

probdma pr1(
	.clk_in_COM (clk_in_COMc),
	.write_in_COM (write_in_COMc),
	.addr_in_COM (addr_in_COMc),
	.reset_in_COM (reset_in_COMc),
	.error_in_COM (error_in_COMc),
	.data_in_RAM (data_in_RAMc),
	.data_in_FIFO (data_in_FIFOc),
	.full_FIFO (full_FIFOc),
	.block_size_REG (block_size_REGc),
	.continue_block_gap_REG (continue_block_gap_REGc),
	.stop_block_gap_REG (stop_block_gap_REGc),
	.enable_transfer_mode_REG (enable_transfer_mode_REGc),
	.transfer_complete_DAT (transfer_complete_DATc),
	.addr_out_RAM (addr_out_RAMc),
	.data_out_RAM (data_out_RAMc),
	.data_out_FIFO (data_out_FIFOc),
	.busy (busyc),
	.newDAT_DAT(newDAT_DATc)
);

initial begin
	$dumpfile("dma.vcd");   
    $dumpvars;
end

endmodule