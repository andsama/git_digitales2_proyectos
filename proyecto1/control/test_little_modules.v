`timescale 1ns/1ps

module test_pad
(
  // outputs
  output reg oSD_clock,
  output reg oEnable,
  output reg oOutput_input,   // padstate  //1 output (to write), 0 input (to read)
  output reg oData_in,        // datain
  output reg oIo_port,        // pad

  // inputs
  input wire iData_out        // dataout
);

  /*
	always #1 oSD_clock = !oSD_clock;

	initial begin
		// initial conditions
	  oSD_clock = 0;
	  oEnable = 0;
    oData_in = 1;

		#20
		oEnable = 1;

		#10
		oOutput_input = 1;

    #2
    oData_in = 0;

    #2
    oData_in = 1;

    #2
    oData_in = 0;

    #10
		oOutput_input = 0;

    #2
    oIo_port = 1;

    #2
    oIo_port = 0;

    #2
    oIo_port = 1;

    #2
    oIo_port = 0;

    #50
		$finish;

	end
  */

endmodule // test_pad

//****************************************************************

module test_parallel_serial
(
  // outputs
  output reg oEnable,
  output reg oReset,
  //input wire [5:0] iFramesize, // 6 bits to give a 38 (38 bits for block sent/received)
  //input wire iLoad_send,
  output reg [37:0] oParallel,
  output reg oSD_clock,

  // inputs
  input wire iSerial,
  input wire iComplete
);

	always #1 oSD_clock = !oSD_clock;

	initial begin
		// initial conditions
	  oSD_clock = 0;
	  oEnable = 0;
    oParallel = 38'd33;
    oReset = 0;

		#20
		oEnable = 1;

    #20
		oReset = 1;

    #20
    oReset = 0;

    #100
		$finish;

	end

endmodule // test_parallel_serial
