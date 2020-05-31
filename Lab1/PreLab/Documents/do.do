vsim -gui work.clockgen
add wave -position insertpoint  \
  sim:/clockgen/Clock \
  sim:/clockgen/Reset_n \
  sim:/clockgen/ClockOut \
  sim:/clockgen/Count \
  sim:/clockgen/ClkOutSig
force Clock 1 0, 0 50 ns -r 100 ns
force Reset_n 0 0 ns, 1 15 ns
run 600 ns
