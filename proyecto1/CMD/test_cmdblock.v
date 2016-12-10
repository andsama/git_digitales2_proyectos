`timescale 1ns/1ps

module test_cmdblock
(
  // outputs
  output reg oClock_host,
  output reg oReset,
  output reg oNew_command,
  output reg [31:0] oCmd_argument,
  output reg [5:0] oCmd_index,
  output reg oTimeout_enable,
  output reg oSerial_from_card,
  output reg oClock_SD,

  input wire iCommand_complete,
  input wire iCommand_index_error,
  input wire [47:0] iResponse

);

	always #1 oClock_host = !oClock_host;
  always #2 oClock_SD = !oClock_SD; // revisar

	initial begin
		// initial conditions
	  oClock_host = 0;
    oClock_SD = 0;
	  oReset = 0;
    oNew_command = 0;
    oCmd_argument = 32'hDEADBEEF;
    oCmd_index = 6'b111111;
    oTimeout_enable = 1;
    oSerial_from_card = 0;
    //oCmd_in = 48'hFFFFFFFFFFFF; // para generar el index error

    #10
    oReset = 1;
    oSerial_from_card = 1;

    #10
    oReset = 0;

    #10
    oNew_command = 1;

    #10
    oNew_command = 0;

    #1000
		$finish;

	end

endmodule // test_cmdcontrol
