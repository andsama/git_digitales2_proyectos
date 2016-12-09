`timescale 1ns/1ps

module testbench_parallel_serial;

  wire wEnable              ;
  wire wReset               ;
  wire [37:0] wParallel     ;
  wire wSD_clock            ;

  wire wSerial              ;
  wire wComplete            ;



  initial begin
		$dumpfile("testbench_parallel_serial.vcd");
		$dumpvars(0,testbench_parallel_serial);
	end

  parallel_serial uutParallel_serial1
	(

    .iEnable              ( wEnable ),
    .iReset               ( wReset ),
    .iParallel            ( wParallel  ),
    .iSD_clock            ( wSD_clock ),

    .oSerial              ( wSerial ),
    .oComplete            ( wComplete )

	);

	test_parallel_serial uutTest_parallel_serial1
	(

    .oEnable              ( wEnable ),
    .oReset               ( wReset ),
    .oParallel            ( wParallel  ),
    .oSD_clock            ( wSD_clock ),

    .iSerial              ( wSerial ),
    .iComplete            ( wComplete )

	);

endmodule // testbench_parallel_serial
