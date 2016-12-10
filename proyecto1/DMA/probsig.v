module probsig(
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

	output clk;
	output valid_IN;
	output End_IN;
	output act1_IN;
	output act2_IN;
	output [63:0] addr_COM;
	
	input valid_OUT;
	input End_OUT;
	input [63:0] addr_RAM;
	input [1:0] trans;
	
reg clk = 0;                         
	 always #1 clk = !clk;

reg	valid_IN = 1;
initial fork
#10 valid_IN = 0;
#30 valid_IN = 1;
#70 valid_IN = 0;
join

reg	End_IN = 0;
initial fork
#20 End_IN = 1;
#40 End_IN = 0;
#80 End_IN = 1;
join

reg	act1_IN = 0;
initial fork
#25 act1_IN = 1;
#50 act1_IN = 0;
#75 act1_IN = 1;
join

reg	act2_IN = 0;
initial fork
#50 act2_IN = 1;
join

reg	addr_COM = 64'h0000000000000000;
initial fork
#25 addr_COM = 64'h00000BBB00000000;
#65 addr_COM = 64'h0000000000AAAA00;
#100 $finish;
join

endmodule