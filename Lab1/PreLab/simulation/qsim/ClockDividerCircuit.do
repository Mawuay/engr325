onerror {quit -f}
vlib work
vlog -work work ClockDividerCircuit.vo
vlog -work work ClockDividerCircuit.vt
vsim -novopt -c -t 1ps -L cycloneiv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.ClockDividerCircuit_vlg_vec_tst
vcd file -direction ClockDividerCircuit.msim.vcd
vcd add -internal ClockDividerCircuit_vlg_vec_tst/*
vcd add -internal ClockDividerCircuit_vlg_vec_tst/i1/*
add wave /*
run -all
