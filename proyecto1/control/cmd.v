`timescale 1ns / 1ps

// state definitions
`define STATE_RESET 	                  0
`define STATE_IDLE 	                    1
`define STATE_SETTINGS_OUTPUTS 	        2
`define STATE_PROCESSING 	              3

module cmd
(
  // inputs
  input wire iClock_host,
  input wire iReset,
  input wire iNew_command,
  input wire [5:0] iCmd_index,
  input wire [31:0] iCmd_argument,
  //input wire [37:0] iCmd_in,
  input wire iStrobe_in,
  input wire iAck_in,


  // outputs
  // output reg oIdle_out, not implementing timeout signal yet
  output reg oStrobe_out,
  output reg oAck_out,
  output reg oCommand_complete,
  output reg [37:0] oResponse

);

reg [1:0] rCurrentState, rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;

//----------------------------------------------

always @ ( posedge iClock_host )
begin
	if (iReset)
	begin
		rCurrentState <= `STATE_RESET;
		rTimeCount <= 32'b0;
	end
	else
	begin
		if (rTimeCountReset)
				rTimeCount <= 32'b0; // resets count
		else
				rTimeCount <= rTimeCount + 32'b1; // increments count

		rCurrentState <= rNextState;
	end
end

//----------------------------------------------

always @ ( * )
begin
	case (rCurrentState)
	//------------------------------------------
	`STATE_RESET:
	begin

    // oIdle_out = 0;
    oStrobe_out = 0;
    oAck_out = 0;
    oCommand_complete = 0;
    oResponse = 0;
		rNextState = 	`STATE_IDLE;
	end
	//------------------------------------------
	`STATE_IDLE:
	begin
    // oIdle_out = 1;
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
    //assign iCmd_in = {iCmd_index, iCmd_argument}; i just can concatenate this to oResponse
    rNextState = `STATE_PROCESSING;
	end
  //------------------------------------------
	`STATE_PROCESSING:
	begin
    if (iStrobe_in == 1)
    begin
      oAck_out = 1;
      oCommand_complete = 1;
    end // if with no else
    oResponse = {iCmd_index, iCmd_argument};
    if (iAck_in == 1)
    begin
      rNextState = `STATE_IDLE;
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

endmodule // cmd

// i didnt consider errors in index/command
// not sure if implement timeout signal
