`timescale 1ns/1ps

module testbench_pad;

  wire wSD_clock            ;
  wire wEnable              ;
  wire wOutput_input        ;
  wire wData_in             ;
  wire wIo_port             ;

  wire wData_out            ;

  initial begin
		$dumpfile("testbench_pad.vcd");
		$dumpvars(0,testbench_pad);
	end

  pad uutPad1
	(

    .iSD_clock            ( wSD_clock ),
    .iEnable              ( wEnable ),
    .iOutput_input        ( wOutput_input ),
    .iData_in             ( wData_in  ),
    .iIo_port             ( wIo_port ),

    .oData_out            ( wData_out )

	);

	test_pad uutTest_pad1
	(

    .oSD_clock            ( wSD_clock ),
    .oEnable              ( wEnable ),
    .oOutput_input        ( wOutput_input ),
    .oData_in             ( wData_in  ),
    .oIo_port             ( wIo_port ),

    .iData_out            ( wData_out )

	);

endmodule // testbench_pad
