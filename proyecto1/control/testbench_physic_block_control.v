`timescale 1ns/1ps

module testbench_physic_block_control;

  wire wClock_SD                      ;
  wire wReset                         ;
  wire wStrobe_in                     ;
  wire wTransmission_complete         ;
  wire wReception_complete            ;
  wire wNo_response                   ;
  wire [47:0] wPad_response           ;
  wire wAck_in                        ;
  wire wIdle_in                       ;
  wire [47:0] wCommand_from_CC        ;

  wire [47:0] wCommand_to_PTS         ;
  wire wReset_wrapper                 ;
  wire wEnable_PTS_wrapper            ;
  wire wEnable_STP_wrapper            ;
  wire wPad_stable                    ;
  wire wPad_enable                    ;
  wire wLoad_send                     ;
  wire wStrobe_out                    ;
  wire wCommand_timeout               ; // NUEVA
  wire [47:0] wResponse               ;
  wire wAck_out                       ;

  initial begin
		$dumpfile("testbench_physic_block_control.vcd");
		$dumpvars(0,testbench_physic_block_control);
	end

  physic_block_control uutPBC1
	(

    .iClock_SD                      ( wClock_SD ),
    .iReset                         ( wReset ),
    .iStrobe_in                     ( wStrobe_in ),
    .iTransmission_complete         ( wTransmission_complete ),
    .iReception_complete            ( wReception_complete ),
    .iNo_response                   ( wNo_response ),
    .iPad_response                  ( wPad_response ),
    .iAck_in                        ( wAck_in ),
    .iIdle_in                       ( wIdle_in ),
    .iCommand_from_CC               ( wCommand_from_CC ),

    .oCommand_to_PTS                ( wCommand_to_PTS ),
    .oReset_wrapper                 ( wReset_wrapper ),
    .oEnable_PTS_wrapper            ( wEnable_PTS_wrapper ),
    .oEnable_STP_wrapper            ( wEnable_STP_wrapper ),
    .oPad_stable                    ( wPad_stable ),
    .oPad_enable                    ( wPad_enable ),
    .oLoad_send                     ( wLoad_send ),
    .oStrobe_out                    ( wStrobe_out ),
    .oCommand_timeout               ( wCommand_timeout ),
    .oResponse                      ( wResponse ),
    .oAck_out                       ( wAck_out )

	);

	test_physic_block_control uutTest_PBC1
	(

    .oClock_SD                      ( wClock_SD ),
    .oReset                         ( wReset ),
    .oStrobe_in                     ( wStrobe_in ),
    .oTransmission_complete         ( wTransmission_complete ),
    .oReception_complete            ( wReception_complete ),
    .oNo_response                   ( wNo_response ),
    .oPad_response                  ( wPad_response ),
    .oAck_in                        ( wAck_in ),
    .oIdle_in                       ( wIdle_in ),
    .oCommand_from_CC               ( wCommand_from_CC ),

    .iCommand_to_PTS                ( wCommand_to_PTS ),
    .iReset_wrapper                 ( wReset_wrapper ),
    .iEnable_PTS_wrapper            ( wEnable_PTS_wrapper ),
    .iEnable_STP_wrapper            ( wEnable_STP_wrapper ),
    .iPad_stable                    ( wPad_stable ),
    .iPad_enable                    ( wPad_enable ),
    .iLoad_send                     ( wLoad_send ),
    .iStrobe_out                    ( wStrobe_out ),
    .iCommand_timeout               ( wCommand_timeout ),
    .iResponse                      ( wResponse ),
    .iAck_out                       ( wAck_out )

	);

endmodule // testbench_physic_block_control
