`timescale 1ns/1ps

module test_parallel_serial
(
  // outputs
  output reg oEnable,
  output reg oReset,
  //input wire [5:0] iFramesize, // 6 bits to give a 38 (38 bits for block sent/received)
  //input wire iLoad_send,
  output reg [47:0] oParallel,
  output reg oClock_SD,

  // inputs
  input wire iSerial,
  input wire iComplete
);

	always #1 oClock_SD = !oClock_SD;

	initial begin
		// initial conditions
	  oClock_SD = 0;
	  oEnable = 0;
    oParallel = 47'hafd5554e;
    oReset = 1;

		#20
		oEnable = 1;
    oReset = 0;

    #500
		$finish;

	end

endmodule // test_parallel_serial

//****************************************************************

module test_serial_parallel
(
  // outputs
  output reg oEnable,
  output reg oReset,
  output reg oClock_SD,
  output reg oSerial,

  //inputs
  input wire iComplete,
  input wire [47:0] iParallel
);
  /*
	always #1 oClock_SD = !oClock_SD;

	initial begin
		// initial conditions
	  oClock_SD = 0;
	  oEnable = 0;
    oSerial = 0;
    oReset = 1;

		#20
		oEnable = 1;
    oReset = 0;

    #2
    oSerial = 1;

    #2
    oSerial = 0;

    #2
    oSerial = 1;

    #2
    oSerial = 0;

    #20
    oSerial = 1;

    #100
		$finish;

	end
  */
endmodule // test_serial_parallel
