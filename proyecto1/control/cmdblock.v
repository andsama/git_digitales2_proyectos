`timescale 1ns / 1ps

module cmdblock
(
  // inputs and outputs
  input wire iClock_host,
  input wire iReset,
  input wire iNew_command,
  input wire [31:0] iCmd_argument,
  input wire [5:0] iCmd_index,
  input wire iTimeout_enable,
  input wire iSerial_from_card,


  output wire oCommand_complete,
  output wire oCommand_index_error,
  output wire [47:0] oResponse,

  input wire iClock_SD
);

wire [47:0] wPBC_oResponse_CC_iCmd_in;
wire wPBC_oStrobe_out_CC_iStrobe_in;
wire wPBC_oAck_out_CC_iAck_in;
wire wPBC_oCommand_timeout_CC_iTimeout;

wire wCC_oIdle_out_PBC_iIdle_in;
wire wCC_oStrobe_out_PBC_iStrobe_in;
wire wCC_oAck_out_PBC_iAck_in;
wire [47:0] wCC_oCmd_out_PBC_iCommand_from_CC;

wire [47:0] wPBC_oCommand_to_PTS_PTS_iParallel;
wire wPBC_oReset_wrapper_PTS_iReset_STP_iReset;
wire wPBC_oEnable_PTS_wrapper_PTS_iEnable;
wire wPBC_oEnable_STP_wrapper_STP_iEnable;

wire wPTS_oComplete_PBC_iTransmission_complete;
wire wSTP_oComplete_PBC_iReception_complete;
wire [47:0] wSTP_oParallel_PBC_iPad_response;

cmdcontrol uutCmdC1
(

  .iClock_host                  ( iClock_host ),
  .iReset                       ( iReset ),
  .iNew_command                 ( iNew_command ),
  .iCmd_index                   ( iCmd_index ),
  .iCmd_argument                ( iCmd_argument ),
  .iCmd_in                      ( wPBC_oResponse_CC_iCmd_in ),
  .iStrobe_in                   ( wPBC_oStrobe_out_CC_iStrobe_in ),
  .iAck_in                      ( wPBC_oAck_out_CC_iAck_in ),

  .iTimeout_enable              ( iTimeout_enable ),
  .iTimeout                     ( wPBC_oCommand_timeout_CC_iTimeout ),

  .oIdle_out                    ( wCC_oIdle_out_PBC_iIdle_in ),
  .oStrobe_out                  ( wCC_oStrobe_out_PBC_iStrobe_in ),
  .oAck_out                     ( wCC_oAck_out_PBC_iAck_in ),
  .oCommand_complete            ( oCommand_complete ),
  .oResponse                    ( oResponse ),

  .oCommand_index_error         ( oCommand_index_error ),
  .oCmd_out                     ( wCC_oCmd_out_PBC_iCommand_from_CC )

);

physic_block_control uutPBC1
(

  .iClock_SD                      ( iClock_SD ),
  .iReset                         ( iReset ),
  .iStrobe_in                     ( wCC_oStrobe_out_PBC_iStrobe_in ),
  .iTransmission_complete         ( wPTS_oComplete_PBC_iTransmission_complete ),
  .iReception_complete            ( wSTP_oComplete_PBC_iReception_complete ),
  .iNo_response                   ( /* no se usa. Se usa iReception_complete */ ),
  .iPad_response                  ( wSTP_oParallel_PBC_iPad_response ),
  .iAck_in                        ( wCC_oAck_out_PBC_iAck_in ),
  .iIdle_in                       ( wCC_oIdle_out_PBC_iIdle_in ),
  .iCommand_from_CC               ( wCC_oCmd_out_PBC_iCommand_from_CC ),

  .oCommand_to_PTS                ( wPBC_oCommand_to_PTS_PTS_iParallel ),
  .oReset_wrapper                 ( wPBC_oReset_wrapper_PTS_iReset_STP_iReset ),
  .oEnable_PTS_wrapper            ( wPBC_oEnable_PTS_wrapper_PTS_iEnable ),
  .oEnable_STP_wrapper            ( wPBC_oEnable_STP_wrapper_STP_iEnable ),
  .oPad_stable                    ( /* va al PAD */ ),
  .oPad_enable                    ( /* va al PAD */ ),
  .oLoad_send                     ( /* no se usa. Se usa iTransmission_complete */ ),
  .oStrobe_out                    ( wPBC_oStrobe_out_CC_iStrobe_in ),
  .oCommand_timeout               ( wPBC_oCommand_timeout_CC_iTimeout ),
  .oResponse                      ( wPBC_oResponse_CC_iCmd_in ),
  .oAck_out                       ( wPBC_oAck_out_CC_iAck_in )

);

serial_parallel uutSerial_parallel1
(

  .iEnable              ( wPBC_oEnable_STP_wrapper_STP_iEnable ),
  .iReset               ( wPBC_oReset_wrapper_PTS_iReset_STP_iReset ),
  .iSerial              ( iSerial_from_card ),
  .iClock_SD            ( iClock_SD ),

  .oParallel            ( wSTP_oParallel_PBC_iPad_response ),
  .oComplete            ( wSTP_oComplete_PBC_iReception_complete )

);

parallel_serial uutParallel_serial1
(

  .iEnable              ( wPBC_oEnable_PTS_wrapper_PTS_iEnable ),
  .iReset               ( wPBC_oReset_wrapper_PTS_iReset_STP_iReset ),
  .iParallel            ( wPBC_oCommand_to_PTS_PTS_iParallel ),
  .iClock_SD            ( iClock_SD ),

  .oSerial              ( /* llega a la tarjeta */ ),
  .oComplete            ( wPTS_oComplete_PBC_iTransmission_complete )

);

endmodule // cmdblock
