LAB01B - REAL HOLD PATH REPAIR
FAIL: 2 x BUF_X1 = about 1.0 ns Q->D against the SAME 2.5 ns minimum delay.
FIX : insert 2 x DLY_X1, adding about 2.0 ns.
The clock and set_min_delay constraints are identical in FAIL and FIX.
Inference: early arrival time is intentionally increased until hold/min-delay slack becomes non-negative.
