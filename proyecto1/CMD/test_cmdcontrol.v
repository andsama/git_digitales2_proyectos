`timescale 1ns/1ps

module test_cmdcontrol
(
  // outputs
  output reg oClock_host,
  output reg oReset,
  output reg oNew_command,
  output reg [5:0] oCmd_index,
  output reg [31:0] oCmd_argument,
  output reg [47:0] oCmd_in,
  output reg oStrobe_in,
  output reg oAck_in,

  output reg oTimeout_enable ,
  output reg oTimeout,

  // inputs
  input wire iIdle_out,
  input wire iStrobe_out,
  input wire iAck_out,
  input wire iCommand_complete,
  input wire [47:0] iResponse,

  input wire iCommand_index_error,
  input wire [47:0] iCmd_out
);

	always #1 oClock_host = !oClock_host;

	initial begin
		// initial conditions
	  oClock_host = 0;
	  oReset = 0;
    oCmd_index = 6'b111111;
    oCmd_argument = 32'd5;
    oTimeout = 0;
    oTimeout_enable = 1;
    oCmd_in = 48'hFFFFFFFFFFFF; // para generar el index error
    //oCmd_in = 48'hFF;

		#50
		oReset = 1;

		#10
		oReset = 0;

		#50
    oNew_command = 1;

    #10
    oStrobe_in = 1;

    #1
    oNew_command = 0;

    #50
    oTimeout = 1;

    #8
    oAck_in = 1;

    #8
    oAck_in = 0;

    #20
		oReset = 1;

    #5
    oStrobe_in = 0;
    oTimeout = 0;

		#10
		oReset = 0;

    #50
    oNew_command = 1;

    #20
    oStrobe_in = 1;

    #20
    oAck_in = 1;

    #10
    oNew_command = 0;

    #50
		$finish;

	end

endmodule // test_cmdcontrol
