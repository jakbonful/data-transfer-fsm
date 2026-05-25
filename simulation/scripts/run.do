vlib work
vmap work work

vlog ../../rtl/ram_dp_async_read.v
vlog ../../rtl/top_fsm.v
vlog ../../tb/top__fsm_tb.v

vsim -gui work.tb_top_fsm
add wave -position end sim:/tb_top_fsm/*
run -all