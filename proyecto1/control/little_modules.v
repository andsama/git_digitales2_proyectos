`timescale 1ns / 1ps

module parallel_serial // not working (?)
(
  // inputs
  input wire iEnable,
  input wire iReset,
  //input wire [5:0] iFramesize, // 6 bits to give a 38 (38 bits for block sent/received)
  //input wire iLoad_send,
  input wire [37:0] iParallel,
  input wire iSD_clock,

  // outputs
  output wire oSerial,
  output wire oComplete
);

reg rC;  // serial line

reg rD;  // complete status

integer j;

always @ (posedge iSD_clock && iEnable)
begin
  if (~iReset) begin
  for (j=0; j <= 37; j = j + 1) begin
      rC <= iParallel[j];
      if (j>=31) begin
          rD <= 1;
      end
      else begin
          rD <= 0;
      end
  end
  end
  else begin
    rC <= 0;
  end
end

assign oSerial = rC;
assign oComplete = rD;

endmodule // parallel_serial

//****************************************************************

module pad // not working (?)
(
    // inputs
    input wire iSD_clock,
    input wire iOutput_input,   // padstate  //1 output (to write), 0 input (to read)
    input wire iEnable,
    input wire iData_in,        // datain
    input wire iIo_port,        // pad

    // outputs
    output wire oData_out       // dataout
);

reg      rA;
reg      rB;

assign iIo_port = iOutput_input ? rA : 1'bZ ;
assign oData_out = rB;

always @ (posedge iSD_clock && iEnable)
begin
  rB <= iIo_port;
  rA <= iData_in;
end

endmodule // pad

//****************************************************************

module serial_parallel
(
  input wire iEnable,
  input wire [7:0] iFrame_size,  //Tamaño de trama
  input wire iSerial,
  input wire [3:0] iSerial_multi,
  input wire iReset,
  input wire iSD_clock,
  output wire [31:0] oParallel,
  output wire oComplete         //Este complete es distinto al general de la capa de datos
);

reg [31:0] rA;  //Para guardar resultados en paralelo
reg rB;         //Para guardar oComplete

//Para Trama:
  integer i;
  always @ (posedge iSD_clock && iEnable) begin
    if (~iReset) begin
      for (i=0; i <= 31; i = i + 1) begin
          rA[i] <= iSerial;
          if (i>=31) begin
              rB <= 1;
          end
          else begin
              rB <= 0;
          end
      end
    end
    else begin
      rA <= 0;
    end
  end

  assign oParallel = rA;
  assign oComplete = rB;

endmodule //Para pasar info de serial a paralelo

//****************************************************************

// no hay que implementar el PAD
