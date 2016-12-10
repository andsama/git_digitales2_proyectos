module tbsig;

wire clkc, valid_INc, End_INc, act1_INc, act2_INc,valid_OUTc,End_OUTc; 
wire [1:0] transc;
wire [63:0] addr_COMc, addr_RAMc;

signals sig1(	
	.clk (clkc),
	.valid_IN(valid_INc),
	.End_IN(End_INc),
	.act1_IN(act1_INc),
	.act2_IN(act2_INc),
	.addr_COM(addr_COMc),
	.valid_OUT(valid_OUTc),
	.End_OUT(End_OUTc),
	.addr_RAM(addr_RAMc),
	.trans(transc)
);

probsig p1p1(
	.clk (clkc),
	.valid_IN(valid_INc),
	.End_IN(End_INc),
	.act1_IN(act1_INc),
	.act2_IN(act2_INc),
	.addr_COM(addr_COMc),
	.valid_OUT(valid_OUTc),
	.End_OUT(End_OUTc),
	.addr_RAM(addr_RAMc),
	.trans(transc)
);

initial begin
	$dumpfile("signal.vcd");   
    $dumpvars;
end

endmodule