module signals(
	clk,
	valid_IN,
	End_IN,
	act1_IN,
	act2_IN,
	addr_COM,
	valid_OUT,
	End_OUT,
	addr_RAM,
	trans
);

	input clk;
	input valid_IN;
	input End_IN;
	input act1_IN;
	input act2_IN;
	input [63:0] addr_COM;
	
	output reg valid_OUT;
	output reg End_OUT;
	output reg [63:0] addr_RAM;
	output reg [1:0] trans;
	
always @(posedge clk) begin
	valid_OUT <= valid_IN;
	End_OUT <= End_IN;
	addr_RAM <= addr_COM;
	trans[0] <= act1_IN;
	trans[1] <= act2_IN;
	$display("trans = %b",trans);
	if(valid_IN) begin
		$display("Dato valido");
	end else begin
		$display("Dato no valido");
	end
end

endmodule