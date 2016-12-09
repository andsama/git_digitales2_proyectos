`timescale 1ns / 1ps

// state definitions
`define STATE_RESET 	                  0  // change this
`define STATE_IDLE 	                    1
`define STATE_SETTINGS_OUTPUTS 	        2
`define STATE_PROCESSING 	              3

module cmdcontrol // solo no implement'e serial ready input
(
  // inputs
  input wire iClock_host,
  input wire iReset,
  input wire iNew_command,
  input wire [5:0] iCmd_index,
  input wire [31:0] iCmd_argument,
  input wire [37:0] iCmd_in,
  input wire iStrobe_in,
  input wire iAck_in,

  input wire iTimeout_enable,
  input wire iTimeout,

  // outputs
  output reg oIdle_out,
  output reg oStrobe_out,
  output reg oAck_out,
  output reg oCommand_complete,
  output reg [37:0] oResponse,

  output reg oCommand_index_error,
  output reg [37:0] oCmd_out

);

reg [1:0] rCurrentState, rNextState;

//----------------------------------------------

always @ ( posedge iClock_host )
begin
	if (iReset)
	begin
		rCurrentState <= `STATE_RESET;
	end

	else
	begin
    if (iTimeout_enable && iTimeout)
    begin
      rCurrentState <= `STATE_IDLE;
    end else begin
      rCurrentState <= rNextState;
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

    oIdle_out = 0;
    oStrobe_out = 0;
    oAck_out = 0;
    oCommand_complete = 0;
    oResponse = 0;
    oCommand_index_error = 0;
    oCmd_out = 0;
		rNextState = 	`STATE_IDLE;
	end
	//------------------------------------------
	`STATE_IDLE:
	begin
    oIdle_out = 1;
    if(iNew_command == 1)
    begin
      rNextState =  `STATE_SETTINGS_OUTPUTS;
    end else begin
      rNextState = 	`STATE_IDLE;
    end
	end
	//------------------------------------------
	`STATE_SETTINGS_OUTPUTS:
	begin
    oStrobe_out = 1;
    oCmd_out = {iCmd_index, iCmd_argument};
    rNextState = `STATE_PROCESSING;
	end
  //------------------------------------------
	`STATE_PROCESSING:
	begin
    if (iStrobe_in == 1)
    begin
      oAck_out = 1;
      oCommand_complete = 1;
      oResponse = iCmd_in;

      if (iCmd_in[36] == 1)
      begin
        oCommand_index_error = 1;
      end else begin
        oCommand_index_error = 0;
      end

      if (iAck_in == 1)
      begin
        rNextState = `STATE_IDLE;
      end else begin
        rNextState = `STATE_PROCESSING;
      end
    end else begin
      rNextState = `STATE_PROCESSING;
    end
	end
	//------------------------------------------
	default:
	begin
    rNextState = `STATE_RESET;
	end
	//------------------------------------------
	endcase
end

endmodule // cmdcontrol
