// testbench_ff.v
`timescale 1ns/1ps

module testbench_cmd;

  wire wClock;
  wire wReset;
  wire wpasee_por_reset;
  wire [31:0] wio1;
  wire wio2;

  initial begin
		$dumpfile("testbench_cmd.vcd");
		$dumpvars(0,testbench_cmd);
	end

  cmd uutCmd1
	(
		.iClock( wClock ),
		.Reset( wReset ),
		.pasee_por_reset( wpasee_por_reset ),
    .o1( wio1 ),
    .o2( wio2 )

	);

	test_cmd uutTest_cmd1
	(
		.oClock( wClock ),
		.oReset( wReset ),
		.ipasee_por_reset( wpasee_por_reset ),
    .io1( wio1 ),
    .io2( wio2 )  
	);

endmodule // testbench_ff
