`timescale 1ns/1ps

module testbench_cmd;

  wire wClock_host;
  wire wReset;
  wire wNew_command;
  wire [5:0] wCmd_index;
  wire [31:0] wCmd_argument;
  wire wStrobe_in;
  wire wAck_in;

  // wire wIdle_out;
  wire wStrobe_out;
  wire wAck_out;
  wire wCommand_complete;
  wire [37:0] wResponse;


  initial begin
		$dumpfile("testbench_cmd.vcd");
		$dumpvars(0,testbench_cmd);
	end

  cmd uutCmd1
	(

    .iClock_host( wClock_host ),
    .iReset( wReset ),
    .iNew_command( wNew_command ),
    .iCmd_index( wCmd_index ),
    .iCmd_argument( wCmd_argument ),
    .iStrobe_in( wStrobe_in ),
    .iAck_in( wAck_in ),

    // .oIdle_out( wIdle_out ),
    .oStrobe_out( wStrobe_out ),
    .oAck_out( wAck_out ),
    .oCommand_complete( wCommand_complete ),
    .oResponse( wResponse )

	);

	test_cmd uutTest_cmd1
	(

    .oClock_host( wClock_host ),
    .oReset( wReset ),
    .oNew_command( wNew_command ),
    .oCmd_index( wCmd_index ),
    .oCmd_argument( wCmd_argument ),
    .oStrobe_in( wStrobe_in ),
    .oAck_in( wAck_in ),

    // .iIdle_out( wIdle_out ),
    .iStrobe_out( wStrobe_out ),
    .iAck_out( wAck_out ),
    .iCommand_complete( wCommand_complete ),
    .iResponse( wResponse )

	);

endmodule // testbench_cmd
