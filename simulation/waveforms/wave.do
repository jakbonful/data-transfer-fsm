onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top_fsm/clk
add wave -noupdate /tb_top_fsm/rst_n
add wave -noupdate /tb_top_fsm/we
add wave -noupdate /tb_top_fsm/addr_wr
add wave -noupdate /tb_top_fsm/addr_rd
add wave -noupdate /tb_top_fsm/data_wr
add wave -noupdate /tb_top_fsm/data_rd
add wave -noupdate /tb_top_fsm/data_rd_buf
add wave -noupdate /tb_top_fsm/done
add wave -noupdate /tb_top_fsm/opmode
add wave -noupdate /tb_top_fsm/data_exp
add wave -noupdate /tb_top_fsm/i
add wave -noupdate /tb_top_fsm/loop_no
add wave -noupdate /tb_top_fsm/test_count
add wave -noupdate /tb_top_fsm/success_count
add wave -noupdate /tb_top_fsm/error_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {307253 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {307031 ps} {308052 ps}
