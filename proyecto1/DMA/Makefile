all:

	iverilog -o sig.o signal.v probsig.v tbsig.v

	vvp sig.o

	gtkwave signal.gtkw



	iverilog -o sta.o stma.v probsta.v tbsta.v

	vvp sta.o

	gtkwave estados.gtkw



	iverilog -o dma.o dma.v probdma.v tbdma.v

	vvp dma.o

	gtkwave dma.gtkw

clean:

	rm *.o *.vcd
