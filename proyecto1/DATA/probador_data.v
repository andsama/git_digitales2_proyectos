
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
//  Descripción: Probador de Data
////////////////////////////////////////////////////////////////////////////////////////////////////


module probador_data
  (
    output Clock,
    output SD_clock,
    output Reset,
    output WriteRead,        //Escritura 1, lectura 0
    output [7:0] Blocks,     //Cantidad de bloques por procesar
    output MultipleData,     //Multitrama
    output Timeout_enable,
    output [15:0] Timeout_reg, //Ciclos para un timeout
    output NewData,            //Nueva operación
    output Serial_ready ,       //Capa física lista
    output wire Timeout,
    output Complete,           //Capa física terminó
    //output Ack_in,
    output FIFO_ok,
    output wire Data_transfer_complete,  //Hacia el DMA
    output wire Send,           //Se debe empezar a enviar los datos, hacia capa física
    //output wire Ack_out,
    output wire Idle,                //Para decir a capa física que vaya al estado idle
    output wire Service,        //Para solicitar servicio
    output wire [31:0] Data_from_FIFO,
    output wire Data_pin_in,
    output wire Data_pin_out
  );

  reg Clock = 0;
  always #20 Clock = !Clock;         //50 MHz

  reg SD_clock = 0;
  always #40 SD_clock = !SD_clock;   //25 MHz

reg Reset=1;
 initial begin
   # 40  Reset = 0;
   # 4000 $finish;
end

reg WriteRead = 1;
reg Blocks = 8'b00000010;
reg MultipleData = 0;
reg Timeout_enable = 0;
reg Timeout_reg = 70;

reg NewData = 0;
initial begin
  # 200  NewData = 1;
  # 200  NewData = 0;
  # 4000 $finish;
end

/*reg Serial_ready = 0;
initial begin
  # 400  Serial_ready = 1;
  # 200  Serial_ready = 0;
  # 4000 $finish;
end*/

reg FIFO_ok = 0;
initial begin
  # 600  FIFO_ok = 1;
  # 200  FIFO_ok = 0;
  # 4000 $finish;
end

/*reg Complete = 0;
initial begin
  # 800  Complete = 1;
  # 200  Complete = 0;
  # 4000 $finish;
end

reg Ack_in = 0;
initial begin
  # 1000  Ack_in = 1;
  # 200  Ack_in = 0;
  # 4000 $finish;
end*/

endmodule // probador de data
