`timescale 1ns/1ps
//`include "test_cmdblock.v"
//`include "cmdblock.v"

module testbench_cmdblock;

  wire wClock_host            ;
  wire wReset                 ;
  wire wNew_command           ;
  wire [31:0] wCmd_argument   ;
  wire [5:0] wCmd_index       ;
  wire wTimeout_enable        ;
  wire wSerial_from_card      ;

  wire wCommand_complete      ;
  wire wCommand_index_error   ;
  wire [47:0] wResponse       ;

  wire wClock_SD              ;

  initial begin
		$dumpfile("testbench_cmdblock.vcd");
		$dumpvars(0,testbench_cmdblock);
	end

  cmdblock uutCmdB1
	(

    .iClock_host                  ( wClock_host ),
    .iReset                       ( wReset ),
    .iNew_command                 ( wNew_command ),
    .iCmd_argument                ( wCmd_argument ),
    .iCmd_index                   ( wCmd_index ),
    .iTimeout_enable              ( wTimeout_enable ),
    .iSerial_from_card            ( wSerial_from_card ),
    .iClock_SD                    ( wClock_SD ),

    .oCommand_complete            ( wCommand_complete ),
    .oCommand_index_error         ( wCommand_index_error ),
    .oResponse                    ( wResponse )

	);

	test_cmdblock uutTest_CmdB1
	(
    .oClock_host                  ( wClock_host ),
    .oReset                       ( wReset ),
    .oNew_command                 ( wNew_command ),
    .oCmd_argument                ( wCmd_argument ),
    .oCmd_index                   ( wCmd_index ),
    .oTimeout_enable              ( wTimeout_enable ),
    .oSerial_from_card            ( wSerial_from_card ),
    .oClock_SD                    ( wClock_SD ),

    .iCommand_complete            ( wCommand_complete ),
    .iCommand_index_error         ( wCommand_index_error ),
    .iResponse                    ( wResponse )
	);

endmodule // testbench_cmdblock
