`timescale 1ns / 1ps

// state definitions
`define STATE_RESET 	                  0  // change this
`define STATE_IDLE 	                    1
`define STATE_LOAD_COMMAND 	            2
`define STATE_SEND_COMMAND              3
`define STATE_WAIT_RESPONSE             4
`define STATE_SEND_RESPONSE 	          5
`define STATE_WAIT_ACK                  6
`define STATE_SEND_ACK                  7

module physic_block_control 
(
  // inputs
  input wire iClock_SD,
  input wire iReset,
  input wire iStrobe_in,
  input wire iTransmission_complete,
  input wire iReception_complete,
  input wire iNo_response,
  input wire [37:0] iPad_response,
  input wire iAck_in,
  input wire iIdle_in,

  // outputs
  output reg oReset_wrapper,
  output reg oEnable_PTS_wrapper, // parallel to serial
  output reg oEnable_STP_wrapper, // Serial to parallel
  output reg oPad_stable,
  output reg oPad_enable,
  output reg oLoad_send,
  output reg oStrobe_out,
  output reg oCommand_timeout, // NUEVA
  output reg [37:0] oResponse,
  output reg oAck_out
);

reg [3:0] rCurrentState, rNextState;
reg [5:0] rCuenta = 6'd0;

//----------------------------------------------

always @ ( posedge iClock_SD )
begin
	if (iReset)
	begin
		rCurrentState <= `STATE_RESET;
	end else begin

    if (iIdle_in)
    begin
      rCurrentState <= `STATE_IDLE;
    end else begin
      rCurrentState <= rNextState;
      if( rCurrentState == 4)
      begin
        rCuenta = rCuenta + 6'd1;
      end else begin
        rCuenta = 0;
      end
    end
  end
end

//----------------------------------------------

always @ ( * )
begin
	case (rCurrentState)
	//------------------------------------------
	`STATE_RESET:
	begin

    oReset_wrapper = 0;
    oEnable_PTS_wrapper = 0;
    oEnable_STP_wrapper = 0;
    oPad_stable = 0;
    oPad_enable = 0;
    oLoad_send = 0;
    oStrobe_out = 0;
    oResponse = 38'd0;
    oAck_out = 0;
    oCommand_timeout = 0;

		rNextState = 				`STATE_IDLE;
	end
	//------------------------------------------
	`STATE_IDLE:
	begin
    oReset_wrapper = 1;
    if(iStrobe_in == 1)
    begin
      rNextState =  `STATE_LOAD_COMMAND;
    end else begin
      rNextState = 	`STATE_IDLE;
    end
	end
	//------------------------------------------
	`STATE_LOAD_COMMAND:
	begin
    oEnable_PTS_wrapper = 1;
    oPad_stable = 1; // estas sennales que van al PAD no se ocupan
    oPad_enable = 1;
    rNextState = `STATE_SEND_COMMAND;
	end
  //------------------------------------------
	`STATE_SEND_COMMAND:
	begin
    oLoad_send = 1;
    if (iTransmission_complete == 1)
    begin
      rNextState = `STATE_WAIT_RESPONSE;
    end else begin
      rNextState = `STATE_SEND_COMMAND;
    end
	end
	//------------------------------------------
  `STATE_WAIT_RESPONSE:
	begin
    oPad_enable = 0;
    oEnable_STP_wrapper = 1;

    if (rCuenta == 6'd60)
    begin
      oCommand_timeout = 1;
      rNextState = `STATE_IDLE;
    end else begin

      if (iReception_complete == 1 | iNo_response == 1)
      begin
        rNextState = `STATE_SEND_RESPONSE;
      end else begin
        rNextState = `STATE_WAIT_RESPONSE;
      end

    end
	end
	//------------------------------------------
  `STATE_SEND_RESPONSE:
	begin
    oStrobe_out = 1;
    oResponse = iPad_response;
    rNextState = `STATE_WAIT_ACK;
	end
	//------------------------------------------
  `STATE_WAIT_ACK:
	begin
    // outputs in low level?

    oReset_wrapper = 0;
    oEnable_PTS_wrapper = 0;
    oEnable_STP_wrapper = 0;
    oPad_stable = 0;
    oPad_enable = 0;
    oLoad_send = 0;
    oStrobe_out = 0;
    oResponse = 38'd0;
    oAck_out = 0;
    oCommand_timeout = 0;

    if (iAck_in == 1)
    begin
      rNextState = `STATE_SEND_ACK;
    end else begin
      rNextState = `STATE_WAIT_ACK;
    end
	end
	//------------------------------------------
  `STATE_SEND_ACK:
	begin
    oAck_out = 1;
    rNextState = `STATE_IDLE;
	end
	//------------------------------------------
	default:
	begin
    rNextState = `STATE_RESET;
	end
	//------------------------------------------
	endcase
end

endmodule // physic_block_control
