vsim -gui work.clockdividercircuit
add wave -position insertpoint  \
  sim:/clockdividercircuit/Clock \
  sim:/clockdividercircuit/Reset_n \
  sim:/clockdividercircuit/ClockOut \
  sim:/clockdividercircuit/Count \
  sim:/clockdividercircuit/ClkOutSig
force Clock 1 0, 0 50 ns -r 100 ns
force Reset_n 0 0 ns, 1 15 ns
run 600 ns
