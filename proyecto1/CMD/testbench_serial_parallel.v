`timescale 1ns/1ps

module testbench_serial_parallel;

  wire wEnable              ;
  wire wReset               ;
  wire wSerial              ;
  wire wClock_SD            ;

  wire [47:0] wParallel     ;
  wire wComplete            ;

  initial begin
		$dumpfile("testbench_serial_parallel.vcd");
		$dumpvars(0,testbench_serial_parallel);
	end

  serial_parallel uutSerial_parallel1
	(

    .iEnable              ( wEnable ),
    .iReset               ( wReset ),
    .iSerial              ( wSerial  ),
    .iClock_SD            ( wClock_SD ),

    .oParallel            ( wParallel ),
    .oComplete            ( wComplete )

	);

	test_serial_parallel uutTest_serial_parallel1
	(

    .oEnable              ( wEnable ),
    .oReset               ( wReset ),
    .oSerial              ( wSerial  ),
    .oClock_SD            ( wClock_SD ),

    .iParallel            ( wParallel ),
    .iComplete            ( wComplete )

	);

endmodule // testbench_serial_parallel
