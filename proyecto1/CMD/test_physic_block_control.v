`timescale 1ns/1ps

module test_physic_block_control
(
  // outputs
  output reg oClock_SD,
  output reg oReset,
  output reg oStrobe_in,
  output reg oTransmission_complete,
  output reg oReception_complete,
  output reg oNo_response,
  output reg [47:0] oPad_response,
  output reg oAck_in,
  output reg oIdle_in,
  output reg [47:0] oCommand_from_CC,

  // inputs
  input wire [47:0] iCommand_to_PTS,
  input wire iReset_wrapper,
  input wire iEnable_PTS_wrapper, // parallel to serial
  input wire iEnable_STP_wrapper, // Serial to parallel
  input wire iPad_stable,
  input wire iPad_enable,
  input wire iLoad_send,
  input wire iStrobe_out,
  input wire iCommand_timeout, // NUEVA
  input wire [47:0] iResponse,
  input wire iAck_out
);

	always #1 oClock_SD = !oClock_SD;

	initial begin
		// initial conditions
	  oClock_SD = 0;
	  oReset = 0;
    oPad_response = 48'd7;
    oCommand_from_CC = 48'hfff;

		#50
		oReset = 1;

		#4
		oReset = 0;

		#50
    oStrobe_in = 1;

    #20
    oTransmission_complete = 1;

    // this is to check the interruption
    //#6
    //oIdle_in = 1;

    #200 // any of those signals in high level, change state
    oReception_complete = 1;
    //oNo_response = 1;

    #20
    oAck_in = 1;

    #4
    oStrobe_in = 0;

    #50
		$finish;

	end

endmodule // test_physic_block_control
