library verilog;
use verilog.vl_types.all;
entity ClockDividerCircuit_vlg_sample_tst is
    port(
        Clock           : in     vl_logic;
        Reset_n         : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end ClockDividerCircuit_vlg_sample_tst;
