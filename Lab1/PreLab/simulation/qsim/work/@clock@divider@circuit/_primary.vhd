library verilog;
use verilog.vl_types.all;
entity ClockDividerCircuit is
    port(
        Clock           : in     vl_logic;
        Reset_n         : in     vl_logic;
        ClockOut        : out    vl_logic
    );
end ClockDividerCircuit;
