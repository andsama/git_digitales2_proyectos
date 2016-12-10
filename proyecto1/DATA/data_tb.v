
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
//  Descripción: Este es el test bench de Data
////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module test_data;

initial begin
  $dumpfile("probador_data.vcd");
  $dumpvars(0,test_data);
end

parameter FIFO_data_size = 32;
parameter Blocks_size_to_process = 8;
parameter Register_size = 16;


wire Clock, Reset, WriteRead, MultipleData, Timeout_enable, NewData, Serial_ready, Timeout;
wire Complete, Ack_in_control, FIFO_ok, Data_transfer_complete, Send, Ack_in_phys, Idle;
wire Service, SD_clock, Data_pin_in, Data_pin_out, Timeout_oc, Read_enable, TEMP;
wire Write_enable, Complete_lectura, Complete_escritura, Empty_out, ReadEn_in;
wire Full_out, WriteEn_in, Clear_in;
wire [Blocks_size_to_process-1:0] Blocks;
wire [Register_size-1:0] Timeout_reg;
wire [FIFO_data_size-1:0] Data_from_FIFO, Data_to_FIFO, Data_to_DMA;
wire [31:0] Data_from_FIFO_temp, Data_to_FIFO_temp, Data_from_DMA;
wire [3:0] fifo_counter;

data_control Control_datos
  (
    .iClock(Clock),
    .iReset(Reset),
    .iWriteRead(WriteRead),
    .iBlocks(Blocks),
    .iMultipleData(MultipleData),
    .iTimeout_enable(Timeout_enable),
    .iTimeout_reg(Timeout_reg),
    .iNewData(NewData),
    .iSerial_ready(Serial_ready),
    .iTimeout(Timeout),
    .iComplete(Complete),
    .iAck(Ack_in_control),
    .iFIFO_ok(FIFO_ok),
    .oData_transfer_complete(Data_transfer_complete),
    .oSend(Send),
    .oAck(Ack_in_phys),
    .oTimeout_val(Timeout_reg),
    .oWriteRead(WriteRead),
    .oMultipleData(MultipleData),
    .oIdle(Idle)
  );

  data_send Capa_Fisica_datos
  (
    .iService(Service),
    .iAck(Ack_in_phys),
    .iIdle(Idle),
    .iTimeout_reg(Timeout_reg),
    .iBlocks(Blocks),
    .iWriteRead(WriteRead),
    .iMultipleData(MultipleData),
    .iData_from_FIFO(Data_from_FIFO),
    .iReset(Reset),
    .iClock(Clock),
    .iSD_clock(SD_clock),
    .iData_from_SD(Data_pin_in),
    .iSend(Send),
    .oSerial_ready(Serial_ready),
    .oComplete(Complete),
    .oAck(Ack_in_control),
    .oTimeout_oc(Timeout_oc),
    .oRead_enable(Read_enable),
    .oWrite_enable(Write_enable),
    .oComplete_lectura(Complete_lectura),
    .oComplete_escritura(Complete_escritura),
    .oReadEn_in(ReadEn_in),
    .oWriteEn_in(WriteEn_in),
    .oClear_in(Clear_in),
    .oData_to_FIFO(Data_to_FIFO)
  );

  probador_data probador
    (
      .Clock(Clock),
      .SD_clock(SD_clock),
      .Reset(Reset),
      .WriteRead(WriteRead),
      .Blocks(Blocks),
      .MultipleData(MultipleData),
      .Timeout_enable(Timeout_enable),
      .Timeout_reg(Timeout_reg),
      .NewData(NewData),
      .Serial_ready(Serial_ready),
      .Timeout(Timeout),
      .Complete(Complete),
      .FIFO_ok(FIFO_ok),
      .Data_transfer_complete(Data_transfer_complete),
      .Send(Send),
      //.Ack_out(Ack_out),
      .Idle(Idle),
      .Service(Service),
      .Data_from_FIFO(Data_from_FIFO),
      .Data_to_FIFO_temp(Data_to_FIFO_temp),
      .Data_pin_in(Data_pin_in),
      .Data_from_DMA(Data_from_DMA),
      .Data_pin_out(Data_pin_out)
    );

  aFifo MyFIFO_Write
    (
      .Data_out(Data_from_FIFO),
      .Empty_out(Empty_out),
      .ReadEn_in(ReadEn_in),
      .RClk(SD_clock),
      .Data_in(Data_from_DMA),
      .Full_out(Full_out),
      .WriteEn_in(WriteEn_in),
      .WClk(Clock),
      .Clear_in(Clear_in)
    );

    aFifo MyFIFO_Read
      (
        .Data_out(Data_to_DMA),
        .Empty_out(Empty_out),
        .ReadEn_in(ReadEn_in),
        .RClk(Clock),
        .Data_in(Data_to_FIFO),
        .Full_out(Full_out),
        .WriteEn_in(WriteEn_in),
        .WClk(SD_clock),
        .Clear_in(Clear_in)
      );

    /*fifo MyFIFO
    (
      .clk(Clock),
      .rst(1'b0),
      .buf_in(Data_to_FIFO_temp),
      .buf_out(Data_from_FIFO_temp),
      .wr_en(1'b0),
      .rd_en(1'b1),
      .buf_empty(Empty_out),
      .buf_full(Full_out),
      .fifo_counter(fifo_counter)
    );

    bfifo MyFIFO
    (
      .clock(Clock),
      .reset(Reset),
      .din(Data_to_FIFO_temp),
      .dout(Data_from_FIFO_temp),
      .wr(1'b0),
      .rd(1'b1),
      .empty(Empty_out),
      .full(Full_out)
    );

    cfifo MyFIFO
    (
      .clock(Clock),
      .reset(~Reset),
      .inData(Data_to_FIFO_temp),
      .new_data(ReadEn_in),
      .outData(Data_from_FIFO_temp),
      .out_data(WriteEn_in),
      .full(Full_out)
    );*/


endmodule    //Test bench de data
