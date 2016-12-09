
module cfifo (clock, reset, inData, new_data, out_data, outData, full);
 input clock;
 input reset;
 input [WIDTH-1 : 0] inData;
 input new_data;
 input out_data;
 parameter WIDTH = 32;
 parameter DEPTH = 32;
 parameter ADDRESSWIDTH = 5;
 integer k; //index for "for" loops
 output [WIDTH-1 : 0] outData;
 output full;
 reg full; // registered output
 wire fullD; // input to "full" flip-flop
 reg [ADDRESSWIDTH-1 : 0] rear; // points to rear of list
 reg [ADDRESSWIDTH-1 : 0] front; // points to front of list
 // flip-flops to hold value of "rear"
 // also increments the value of "rear" when "new_data" is high,
 // checking
 // the value of "rear" in lieu of a mod divide
 always@(posedge clock)
 begin
 if (!reset) rear <= 0;
 else if(new_data)
 begin
 if (rear == DEPTH) rear <= 0;
 else rear <= rear+1;
 end
 end
 // flip-flops to hold value of "front"
 // also increments the value of "front" when "out_data" is high,
 // checking
 // the value of "front" in lieu of a mod divide
 always@(posedge clock)
 begin
 if (!reset) front <= 0;
 else if(out_data)
 begin
 if (front == DEPTH) front <= 0;
 else front <= front+1;
 end
 end
 // flip-flop for "full" signal
 always@(posedge clock)
 begin
 if (!reset) full <= 0;
 else full <= fullD;
 end
 // full signal
 assign fullD = (front == ((rear==DEPTH) ? 0 : (rear+1)));
 regfile u1 (clock, reset, new_data, rear, front, inData, outData);
endmodule
