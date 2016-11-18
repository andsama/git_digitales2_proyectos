`timescale 1ns/1ps

module test_cmd
(
  // outputs
  output reg oClock_host,
  output reg oReset,
  output reg oNew_command,
  output reg [5:0] oCmd_index,
  output reg [31:0] oCmd_argument,
  output reg oStrobe_in,
  output reg oAck_in,

  // inputs
  // input wire iIdle_out,
  input wire iStrobe_out,
  input wire iAck_out,
  input wire iCommand_complete,
  input wire [37:0] iResponse
);

	always #1 oClock_host = !oClock_host;

	initial begin
		// initial conditions
	  oClock_host = 0;
	  oReset = 0;
    oCmd_index = 6'd5;
    oCmd_argument = 32'd5;

		#50
		oReset = 1;

		#4
		oReset = 0;

		#50
    oNew_command = 1;

    #20
    oStrobe_in = 1;

    #20
    oAck_in = 1;

    #50
		$finish;

	end

endmodule // test_cmd
