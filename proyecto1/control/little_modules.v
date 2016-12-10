`timescale 1ns / 1ps

module parallel_serial
(
  input wire iEnable,
  input wire iReset,
  input wire iClock_SD,
  input wire [47:0] iParallel,
  output wire oSerial,
  output wire oComplete
);

reg rC;  //Para guardar resultados Seriales
reg rD;  //Para guardar oComplete

  integer j=0;
  always @ (posedge iClock_SD && iEnable) begin
    if (~iReset) begin
        rC <= iParallel[j];
        j = j + 1;
        if (j>=48) begin
            rD <= 1;
            j <= 0;
        end
        else begin
            rD <= 0;
        end
    end
    else begin
      rC <= 0;
      rD <= 0;
    end
end
  assign oSerial = rC;
  assign oComplete = rD;

endmodule // parallel_serial


//****************************************************************

module serial_parallel
(
  input wire iEnable,
  input wire iSerial,
  input wire iReset,
  input wire iClock_SD,
  output wire [47:0] oParallel,
  output wire oComplete
);

reg [47:0] rA;  //Para guardar resultados en paralelo
reg rB;         //Para guardar oComplete

  integer i = 0;
  always @ (posedge iClock_SD && iEnable) begin
    if (~iReset) begin
          rA[i] <= iSerial;
          i = i + 1;
          if (i>=48) begin
              rB <= 1;
              i <= 0;
          end
          else begin
              rB <= 0;
          end
    end
    else begin
      rA <= 0;
    end
  end

  assign oParallel = rA;
  assign oComplete = rB;

endmodule // serial_parallel
