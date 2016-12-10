`timescale 1ns/1ps

module testbench_cmdcontrol;

  wire wClock_host                  ;
  wire wReset                       ;
  wire wNew_command                 ;
  wire [5:0] wCmd_index             ;
  wire [31:0] wCmd_argument         ;
  wire [47:0] wCmd_in               ;
  wire wStrobe_in                   ;
  wire wAck_in                      ;

  wire wTimeout_enable              ;
  wire wTimeout                     ;

  wire wIdle_out                    ;
  wire wStrobe_out                  ;
  wire wAck_out                     ;
  wire wCommand_complete            ;
  wire [47:0] wResponse             ;

  wire wCommand_index_error         ;
  wire [47:0] wCmd_out              ;

  initial begin
		$dumpfile("testbench_cmdcontrol.vcd");
		$dumpvars(0,testbench_cmdcontrol);
	end

  cmdcontrol uutCmdC1
	(

    .iClock_host                  ( wClock_host ),
    .iReset                       ( wReset ),
    .iNew_command                 ( wNew_command ),
    .iCmd_index                   ( wCmd_index ),
    .iCmd_argument                ( wCmd_argument ),
    .iCmd_in                      ( wCmd_in ),
    .iStrobe_in                   ( wStrobe_in ),
    .iAck_in                      ( wAck_in ),

    .iTimeout_enable              ( wTimeout_enable ),
    .iTimeout                     ( wTimeout ),

    .oIdle_out                    ( wIdle_out ),
    .oStrobe_out                  ( wStrobe_out ),
    .oAck_out                     ( wAck_out ),
    .oCommand_complete            ( wCommand_complete ),
    .oResponse                    ( wResponse ),

    .oCommand_index_error         ( wCommand_index_error ),
    .oCmd_out                     ( wCmd_out )

	);

	test_cmdcontrol uutTest_cmdC1
	(

    .oClock_host                  ( wClock_host ),
    .oReset                       ( wReset ),
    .oNew_command                 ( wNew_command ),
    .oCmd_index                   ( wCmd_index ),
    .oCmd_argument                ( wCmd_argument ),
    .oCmd_in                      ( wCmd_in ),
    .oStrobe_in                   ( wStrobe_in ),
    .oAck_in                      ( wAck_in ),

    .oTimeout_enable              ( wTimeout_enable ),
    .oTimeout                     ( wTimeout ),

    .iIdle_out                    ( wIdle_out ),
    .iStrobe_out                  ( wStrobe_out ),
    .iAck_out                     ( wAck_out ),
    .iCommand_complete            ( wCommand_complete ),
    .iResponse                    ( wResponse ),

    .iCommand_index_error         ( wCommand_index_error ),
    .iCmd_out                     ( wCmd_out )

	);

endmodule // testbench_cmd
