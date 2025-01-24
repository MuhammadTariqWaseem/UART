vdel -lib work -all
vlib work
vlog -sv tb_UART.sv ../rtl/UART.sv 
vsim -novopt tb_UART
#add wave *
do wave_tb_UART.do
run -a