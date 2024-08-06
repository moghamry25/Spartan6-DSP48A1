vlib work
vlog DSP.v DSP_TB.v mux4.v REG_MUX.V
vsim -voptargs=+acc work.DSP_TB
add wave *
run -all
#quit -sim
