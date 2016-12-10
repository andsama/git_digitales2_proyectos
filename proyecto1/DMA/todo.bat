start 

verilog -o sig signal.v probsig.v tbsig.v
vvp sig
gtkwave signal.gtkw

verilog -o sta stma.v probsta.v tbsta.v
vvp sta
gtkwave estados.gtkw

verilog -o dma dma.v probdma.v tbdma.v
vvp dma
gtkwave dma.gtkw

finish