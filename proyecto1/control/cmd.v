`timescale 1ns / 1ps

// state definitions
`define STATE1_IDLE 	0
`define STATE2_RESET 	1
`define STATE3_ADD1 	2
`define STATE4_ADD2 	3

module cmd
(
  // inputs
  input wire iClock,
  input wire Reset,
  // outputs
  output reg pasee_por_reset,
  output reg [31:0] o1,
  output reg o2
);

integer contador = 0;
reg [1:0] rCurrentState, rNextState;
reg [31:0] rTimeCount;
reg [31:0] default_value;
reg rTimeCountReset;

//----------------------------------------------

always @ ( posedge iClock )
begin
	if (Reset)
	begin
    o1 <= 32'b0;
		rCurrentState <= `STATE2_RESET;
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
	`STATE2_RESET:
	begin
    pasee_por_reset =   1'b1;
		rNextState = 				`STATE1_IDLE;
	end
	//------------------------------------------
	`STATE1_IDLE:
	begin
	 rNextState = `STATE3_ADD1;
	end
	//------------------------------------------
	`STATE3_ADD1:
	begin
    o1 = o1 + 1;
		if (o1 > 32'd4)
		begin
			rNextState = `STATE4_ADD2;
		end
		else
			rNextState = `STATE3_ADD1;
	end
  //------------------------------------------
	`STATE4_ADD2:
	begin
    rNextState = `STATE1_IDLE;
	end
	//------------------------------------------
	default:
	begin
    default_value = 32'd16;
    rNextState = `STATE1_IDLE;
	end
	//------------------------------------------
	endcase
end
endmodule
