# MAP-2 Asynchronous-Clear Flip-Flop Fix

The project RTL uses active-low asynchronous reset, for example:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        result <= 0;
    else
        result <= next_result;
end
```

Cadence Genus therefore requires a library cell with an asynchronous active-low clear.
The corrected libraries now include:

- `DFFR_X1` in `demo_cmos.lib`
- `DFFR_X1_LVT` in `demo_lvt.lib`
- `DFFR_X1_RVT` in `demo_rvt.lib`
- `DFFR_X1_HVT` in `demo_hvt.lib`

Each cell contains the Liberty sequential definition:

```liberty
ff (IQ, IQN) {
    clocked_on : "CLK";
    next_state : "D";
    clear      : "!RN";
}
```

Before a full synthesis run, verify the library with:

```bash
genus -files scripts/verify_library.tcl
```

You should see a PASS message showing `DFFR_X1`.
