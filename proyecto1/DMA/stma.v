module states(
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

	input clk_in_1;
	input write_1;
	input reset_1;
	input error_1;
	input [7:0] data_in_FIFO_1;
	input [7:0] data_in_RAM_1;
	input continue_1;
	input stop_2;
	input valid_2;
	input end_2;
	input [1:0] tran_2;
	input enable_2;
	input full_FIFO;
	input [11:0] block_size;
	input [63:0] addr_RAM_i;
	
	output reg [63:0] addr_RAM_o;
	output reg [7:0] data_out_FIFO_1;
	output reg [7:0] data_out_RAM_1;
	output reg busy;

/* 
variables internas: 
TFC, Data_transfer, trans
*/

	integer ST_STOP = 3'b000;
	integer ST_FDS  = 3'b001;
	integer ST_CADR = 3'b010;
	integer ST_TFR  = 3'b100;
	integer state;
	integer TFC;
	integer Data_transfer;
	integer trans;
//	integer DATA_ADDR;

always @(posedge clk_in_1) begin
	case (tran_2)
		2'b00: begin
			trans = 0;
		end
		2'b01: begin
		trans = 0;
		end
		2'b10: begin
			trans = 1;
		end
		2'b11: begin
			trans = 1;
		end
		default: trans = 0;
	endcase
//-------------------------------------------------------------------
	if(reset_1 || error_1) begin
		data_out_FIFO_1 = 0;
		data_out_RAM_1 = 0;
		addr_RAM_o <= 0;
		state <= ST_STOP;
		$display("Estado ST_STOP por reset o error");
	end else begin
		if(~write_1 && enable_2) begin
			data_out_RAM_1 <= data_in_FIFO_1;
			data_out_FIFO_1 = 0;
			addr_RAM_o <= 0;
		end else begin
			case (state)
//-------------------------------------------------------------------
				ST_STOP: begin
					busy = 0;
					TFC = 0;
					data_out_FIFO_1 = 0;
					data_out_RAM_1 = 0;
					addr_RAM_o <= 0;
					$display("Estado ST_STOP");
					if((write_1 || continue_1) && full_FIFO == 0) begin
						state <= ST_FDS;
					end else begin
						state <= ST_STOP;
					end
				end
//-------------------------------------------------------------------
				ST_FDS: begin
					busy = 0;
					$display("Estado ST_FDS");
					if(valid_2) begin
						TFC = 0;
						state <= ST_CADR;
						busy = 1;
					end else begin
						state <= ST_FDS;
					end
				end
//-------------------------------------------------------------------
				ST_CADR: begin
					$display("Estado ST_CADR");
					if(trans) begin
						Data_transfer = 0;
						state <= ST_TFR;
					end else begin
						if (end_2) begin
							state <= ST_STOP;
						end else begin
							state <= ST_FDS;
						end
					end
				end
//-------------------------------------------------------------------
				ST_TFR: begin
					$display("Estado ST_TFR");
					if(Data_transfer < block_size) begin
						data_out_FIFO_1 <= data_in_RAM_1;
						addr_RAM_o <= addr_RAM_i+(Data_transfer);
						Data_transfer <= Data_transfer+1;
						state <= ST_TFR;
					end else begin
						TFC = 1;
						if(TFC==1 && (end_2==1 || stop_2==1)) begin
							state <= ST_STOP;
						end else begin
							if(TFC==1 && end_2==0 && stop_2==0) begin
								state <= ST_FDS;
							end else begin
								state <= ST_TFR;
							end
						end
					end 
				end
//-------------------------------------------------------------------
				default: begin
					state <= ST_STOP;
					$display("Estado ST_STOP por default");
				end
			endcase
		end
	end 
end


endmodule





