
////////////////////////////////////////////////////////////////////////////////////////////////////
//	Universidad de Costa Rica
//	Escuela de Ingeniería Eléctrica
//	IE-0523 Circuitos Digitales 2
//
//	Proyecto 1:  SD Host
//
//	Autores:
//  Andrey Pérez Salazar - B25084
//  Andrés Sánchez López - B26214
//  Ronald Rivera Morales - B25565
//  Daniel Jiménez Villalobos - B13535
//
//  Descripción: El bloque de data se encarga de recibir y enviar datos desde y hacia la SD card.
//  Por lo que se compone de dos partes principales, la primera es el control, el cual se comunica
//  con los registros y el DMA para saber cuando se deben enviar o leer datos. La segunda etapa
//  se encarga de enviar y leer los datos en sí, por lo que se cominuca con el FIFO y además
//  convierte la información de paralela a serial y viceversa, se controlada con la parte anterior.
////////////////////////////////////////////////////////////////////////////////////////////////////

module data_control
  (
    input wire iClock,
    input wire iReset,
    input wire iWriteRead,        //Escritura 1, lectura 0
    input wire [7:0] iBlocks,     //Cantidad de bloques por procesar
    input wire iMultipleData,     //Multitrama
    input wire iTimeout_enable,
    input wire [15:0] iTimeout_reg, //Ciclos para un timeout
    input wire iNewData,            //Nueva operación
    input wire iSerial_ready ,       //Capa física lista
    input wire iTimeout,
    input wire iComplete,           //Capa física terminó
    input wire iAck,                //Viene de capa fisica
    input wire iFIFO_ok,
    output wire oData_transfer_complete,  //Hacia el DMA
    output wire oSend,               //Se debe empezar a enviar los datos, hacia capa física
    output wire oAck,                    //Se envía a capa física
    output wire [3:0] oBlocks,      //Cantidad de bloques por procesar, para enviar a capa física
    output wire [15:0] oTimeout_val, //Ciclos para un timeout, para enviar a capa física
    output wire oWriteRead,          //Escritura 1, lectura 0
    output wire oMultipleData,       //enviar a capa física
    output wire oIdle                //Para decir a capa física que vaya al estado idle
  );

parameter SIZE = 3;
parameter IDLE = 3'b111, SETTING_OUTPUTS = 3'b110, CHECK_FIFO = 3'b101;
parameter TRANSMIT = 3'b100, ACK = 3'b011;

reg [SIZE-1:0] rState;
reg [SIZE-1:0] rNext_state;
reg rTemp_Idle;
reg rTemp_send;
reg rTemp_Ack;
reg rTemp_Data_Complete;


always @ (posedge iClock)
begin: FSM_control
if (iReset) begin
  rState <= #1 IDLE;
  rTemp_Data_Complete <= 0;
  rTemp_send <= 0;
  rTemp_Ack <= 0;
  //oBlocks <= 0;
  //oTimeout_val <= 0;
  //oWriteRead <= 0;
  //oMultipleData <= 0;
  rTemp_Idle <= 0;
end
else begin
  case (rState)
    IDLE: begin
          rTemp_Ack <= 0;
          if (~iNewData) begin
              rTemp_Idle <= 1;
              rState <= #1 IDLE;
           end
           else begin
              rState <= #1 SETTING_OUTPUTS;
           end
        end

   SETTING_OUTPUTS:
          if (iSerial_ready) begin
              rTemp_Idle <= 0;
              rState <= #1 CHECK_FIFO;
          end
          else begin
              rTemp_Idle <= 0;
              rState <= #1 SETTING_OUTPUTS;
          end

    CHECK_FIFO:
          if (iFIFO_ok) begin
              rTemp_Idle <= 0;
              rState <= #1 TRANSMIT;
          end
          else begin
              rTemp_Idle <= 0;
              rState <= #1 CHECK_FIFO;
          end

      TRANSMIT:
          if (~iComplete) begin
              rTemp_send <= 1'b1;
              rState <= #1 TRANSMIT;
          end
          else begin
              rTemp_send <= 0;
              rState <= #1 ACK;
          end

      ACK: begin
          rTemp_Ack <= 1'b1;
          if (~iAck) begin
              rState <= #1 ACK;
          end
          else begin
                rTemp_Data_Complete <= 1'b1;
                rState <= IDLE;
          end
        end

    default: rState <= #1 IDLE;
  endcase
  end
end

assign oIdle = rTemp_Idle;
assign oSend = rTemp_send;
assign oAck = rTemp_Ack;
assign oData_transfer_complete = rTemp_Data_Complete;

endmodule    //Control de datos

/**************************************************************************************************/

module data_send
(
  input wire iService,        //Para solicitar servicio
  input wire iAck,            //Viene de control
  input wire iIdle,           //Ir al estado idle
  input wire [15:0] iTimeout_reg, //Ciclos para un timeout
  input wire [7:0] iBlocks,     //Cantidad de bloques por procesar
  input wire iWriteRead,        //Escritura 1, lectura 0
  input wire iMultipleData,     //Multitrama
  input wire [31:0] iData_from_FIFO,
  input wire iReset,
  input wire iClock,             //reloj de la PC
  input wire iSD_clock,          //reloj de SD
  input wire iData_pin,          //Para el envío de datos
  input wire iSend,
  input wire iData_from_SD,         // Para la recepción de datos
  output wire oSerial_ready ,    //Capa física lista, hacia control
  output wire oComplete,         //Se completó la operación, enviar a control
  output wire oAck,              //Va hacía control
  output wire oTimeout_oc,       //Ocurrencia del timeout, hacia control y registros
  output wire oRead_enable,      //lectura del FIFO, Hacía el FIFO
  output wire oWrite_enable,     //escritura del FIFO, Hacía el FIFO
  output wire oPad_enable,
  output wire oRead_reset,
  output wire oComplete_lectura,
  output wire oComplete_escritura,
  output wire oReadEn_in,
  output wire oWriteEn_in,
  output wire oClear_in,
  output wire [31:0] oData_to_FIFO
);

parameter SIZE = 4;
parameter IDLE = 4'b1111, FIFO_READ = 4'b1110, LOAD_WRITE = 4'b1101, SEND = 4'b1100;
parameter WAIT_RESPONSE = 4'b1011, READ = 4'b1010, READ_FIFO_WRITE = 4'b1001;
parameter READ_WRAPPER_RESET = 4'b1000, WAIT_ACK = 4'b0111, SEND_ACK = 4'b0110;

reg [SIZE-1:0] rState;
reg [SIZE-1:0] rNext_state;
reg rTemp_Serial_ready, rTemp_Complete, rTemp_oAck;
reg rTemp_Read_enable, rTemp_Write_enable;
reg [31:0] rTemp_Data_from_fifo;
reg rTemp_enable_pad, TEMP, rRead_reset;
reg rComplete_Escritura, rComplete_Lectura, rWrite_reset;
reg rTemp_iReadEn_in, rTemp_iWriteEn_in, rTemp_iClear_in;  //Variables del FIFO

integer Contador=0;


serial_parallel lectura
(
  .iEnable(rTemp_Read_enable),
  .iFrame_size(iBlocks),
  .iSerial(iData_from_SD),
  .iReset(oRead_reset),
  .iSD_clock(iSD_clock),
  .oParallel(oData_to_FIFO),
  .oComplete(oComplete_lectura)
);

parallel_serial escritura
(
  .iEnable(oWrite_enable),
  .iFrame_size(iBlocks),
  .iReset(oWrite_reset),
  .iSD_clock(iSD_clock),
  .iParallel(iData_from_FIFO),
  .oSerial(iData_pin),
  .iMultipleData(iMultipleData),
  .oComplete(oComplete_escritura)
);


always @ (posedge iSD_clock)
begin: FSM_fisica
  if (iReset) begin
    rState <= #1 IDLE;
    rTemp_Serial_ready <= 0;
    rTemp_oAck <= 0;
    rTemp_Read_enable <= 0;
    rTemp_Write_enable <= 0;
    rRead_reset <= 1'b0;
    rTemp_iWriteEn_in = 1'b1;
    rTemp_iClear_in = 1'b1;
    rTemp_iReadEn_in = 1'b0;
  end
  else begin
    case (rState)
       IDLE: begin
            rTemp_Write_enable <= 0;
            rTemp_Serial_ready <= 1'b1;
            rTemp_Complete <= 0;
            rTemp_oAck <= 0;
            rWrite_reset <= 0;
            rTemp_iWriteEn_in = 1'b1;
            rTemp_iClear_in = 1'b1;
            rTemp_iReadEn_in = 1'b0;
            if (~iService) begin
              rState <= #1 IDLE;
            end
            else begin
              if (iWriteRead) begin
                rState <= #1 FIFO_READ;    //Escritura a la SD
              end
              else begin
                rState <= #80 READ_FIFO_WRITE;        //Lectura de la SD
              end
            end
          end

        FIFO_READ:  begin
            rTemp_iWriteEn_in = 1'b1;
            rTemp_iClear_in = 1'b0;
            rState <= #80 LOAD_WRITE;
          end

        LOAD_WRITE: begin
            rWrite_reset <= 0;
            rTemp_enable_pad <= 1'b1;
            if (iSend) begin
              rTemp_iWriteEn_in = 1'b0;
              rTemp_iClear_in = 1'b0;
              rTemp_iReadEn_in = 1'b1;
              rState <= #40 SEND;
            end
            else begin
              rState <= #1 LOAD_WRITE;
            end
            end

        SEND: begin
              rTemp_Write_enable <= 1'b1;
              rState <= #1 WAIT_RESPONSE;
        end

        WAIT_RESPONSE:
         begin
            rTemp_iReadEn_in = 1'b0;
            if (~oComplete_escritura) begin
              rState <= #1 WAIT_RESPONSE;
            end
            else begin
            Contador <= Contador + 1;
            rWrite_reset <= 1;
            if (iBlocks) begin
              rTemp_Complete <= 1;
              rState <= #1 WAIT_ACK;
            end
            else begin
              rState <= #1 LOAD_WRITE;
              end
            end // -,-
          end

          READ_FIFO_WRITE: begin
            rTemp_iWriteEn_in = 1'b1;
            rTemp_iClear_in = 1'b0;
            rState <= #80 READ;
          end

        READ: begin
            rTemp_iWriteEn_in = 1'b0;
            rTemp_iClear_in = 1'b0;
            rTemp_iReadEn_in = 1'b1;
            if (~oComplete_lectura) begin
              rRead_reset <= 0;
              rTemp_Read_enable <= 1'b1;
              rState <= #1 READ;
            end else begin
              rRead_reset <= 1'b0;
              Contador <= Contador + 1;
              if (Contador >= iBlocks) begin
                  rTemp_Complete <= 1;
                  rState <= #1 WAIT_ACK;
              end
              else begin
                  rState <= #1 READ_WRAPPER_RESET;
              end
            end
          end


          READ_WRAPPER_RESET: begin
            rRead_reset <= 1'b1;
            rState <= #1 READ;
          end

          WAIT_ACK: begin
            rTemp_iWriteEn_in = 1'b0;
            rTemp_Write_enable <= 0;
            rTemp_Complete <= 1'b1;
            if (iAck) begin
              rState <= #1 SEND_ACK;
            end
            else begin
              rState <= #1 WAIT_ACK;
            end
          end

          SEND_ACK: begin
              rTemp_oAck <= 1'b1;
              rState <= #1 IDLE;
          end


       default: rState <= #1 IDLE;
    endcase
  end
end

assign oSerial_ready = rTemp_Serial_ready;
assign oComplete = rTemp_Complete;
assign oAck = rTemp_oAck;
assign oRead_enable = rTemp_Read_enable;
assign oWrite_enable = rTemp_Write_enable;
assign oPad_enable = rTemp_enable_pad;
assign oRead_reset = rRead_reset;
assign oWrite_reset = rWrite_reset;
assign oReadEn_in = rTemp_iReadEn_in;
assign oWriteEn_in = rTemp_iWriteEn_in;
assign oClear_in = rTemp_iClear_in;
//assign oData_to_FIFO = rTemp_Data_to_fifo;

endmodule // Envío de los datos

/**************************************************************************************************/

module serial_parallel
(
  input wire iEnable,
  input wire [7:0] iFrame_size,  //Tamaño de trama
  input wire iSerial,
  //input wire [3:0] iSerial_multi,
  input wire iReset,
  input wire iSD_clock,
  output wire [31:0] oParallel,
  output wire oComplete         //Este complete es distinto al general de la capa de datos
);

reg [31:0] rA;  //Para guardar resultados en paralelo
reg rB;         //Para guardar oComplete

//Para Trama:
  integer i = 0;
  always @ (posedge iSD_clock && iEnable) begin
    if (~iReset) begin
          rA[i] <= iSerial;
          i = i + 1;
          if (i>=32) begin
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


//Para Multitrama:
/*integer i;
always @ (posedge iSD_clock && iEnable) begin
  if (~iReset) begin
    for (i=0; i <= 7; i = i + 1) begin
        rA[(i*4)+:3] <= iSerial_multi;
        if (i>=7) begin
            rB <= 1;
        end
        else begin
            rB <= 0;
        end
    end
  end
  else begin
    rA = 0;
  end
end

assign oParallel = rA;
assign oComplete = rB;*/


endmodule //Para pasar info de serial a paralelo

/**************************************************************************************************/

module parallel_serial
(
  input wire iEnable,
  input wire [7:0] iFrame_size,  //Tamaño de trama
  input wire iReset,
  input wire iSD_clock,
  input wire [31:0] iParallel,
  input wire iMultipleData,
  output wire oSerial,
  output wire [3:0] oSerial_multi,
  output wire oComplete
);

reg rC;  //Para guardar resultados Seriales
reg [3:0] rE;  //Para Multitrama
reg rD;  //Para guardar oComplete

  //Para trama:
  integer j=0;
  always @ (posedge iSD_clock && iEnable) begin
    if (~iReset) begin
        rC <= iParallel[j];
        j = j + 1;
        if (j>=32) begin
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

//Para Multitrama:
  /*integer i=0;
  always @ (posedge iSD_clock && iEnable) begin
    if (~iReset) begin
        rE <= iParallel[i*4+:3];
        i = i + 1;
        if (i>=7) begin
            rD <= 1;
        end
        else begin
            rD <= 0;
        end
    end
    else begin
      rE <= 0;
    end
  end

  assign oSerial_multi = rE;
  assign oComplete = rD;*/


endmodule // Para pasar info de paralelo a serial

/**************************************************************************************************/

module pad
(
    input wire iOut_in,       //1 Esritura, 0 Lectura
    input wire iEnable,
    input wire iData,        //Dato de entrada si se Escribe a la tarjeta
    input wire iSD_clock,
    input wire iIo_port,     //PIN de salida del SD_HOST, lo que va a la tarjeta
    output wire oData       //Dato de salida si se lee de la tarjeta
);

reg      a;
reg      b;

assign iIo_port = iOut_in ? a : 1'bZ ;
assign oData  = b;

always @ (posedge iSD_clock && iEnable)
begin
    b <= iIo_port;
    a <= iData;
end


endmodule // pad de datos

/**************************************************************************************************/
