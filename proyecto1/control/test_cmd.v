//test.v
`timescale 1ns/1ps

module test_cmd
(
	// outputs
  output reg oClock,
  output reg oReset,
  // inputs
  input wire ipasee_por_reset,
  input wire [31:0] io1,
  input wire io2
);

	always #1 oClock = !oClock;
	//always #1 oCLK = !oCLK;
	initial begin
		// condiciones iniciales
	  oClock = 0;
	  oReset = 0;

		#50
		oReset = 1;

		#4
		oReset = 0;

		#100
		$finish;

	end

endmodule // 32

//---------------------------------------------------------------------------------------------------
