onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Clk & Reset}
add wave -noupdate -radix hexadecimal /tb_UART/clk
add wave -noupdate -radix hexadecimal /tb_UART/arst_n
add wave -noupdate -divider {Starting Signals}
add wave -noupdate -radix hexadecimal /tb_UART/start_master
add wave -noupdate -radix hexadecimal /tb_UART/start_slave
add wave -noupdate -radix hexadecimal /tb_UART/data_in_master
add wave -noupdate -radix hexadecimal /tb_UART/data_out_master
add wave -noupdate -radix hexadecimal /tb_UART/data_in_slave
add wave -noupdate -radix hexadecimal /tb_UART/data_out_slave
add wave -noupdate -divider {Communicating wires}
add wave -noupdate -radix hexadecimal /tb_UART/tx_master
add wave -noupdate -radix hexadecimal /tb_UART/rx_master
add wave -noupdate -radix hexadecimal /tb_UART/rx_slave
add wave -noupdate -radix hexadecimal /tb_UART/tx_slave
add wave -noupdate -divider {Error Flag}
add wave -noupdate -radix hexadecimal /tb_UART/error_flag_master
add wave -noupdate -radix hexadecimal /tb_UART/error_flag_slave
add wave -noupdate -radix hexadecimal /tb_UART/master_uart/next_state
add wave -noupdate -radix hexadecimal /tb_UART/master_uart/current_state
add wave -noupdate -radix hexadecimal /tb_UART/master_uart/clk_gen
add wave -noupdate -radix unsigned /tb_UART/slave_uart/next_state
add wave -noupdate -radix unsigned /tb_UART/slave_uart/current_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11304 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {199553 ps}
