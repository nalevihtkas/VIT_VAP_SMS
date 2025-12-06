Perl Verilog Generator for Adders and Subtractors
-------------------------------------------------
Usage examples:

$ chmod +x gen_nbit_arith.pl

# Generate 8-bit adder
$ ./gen_nbit_arith.pl 8 add

# Generate 8-bit ripple carry subtractor
$ ./gen_nbit_arith.pl 8 sub_rc

# Generate 8-bit ripple borrow subtractor
$ ./gen_nbit_arith.pl 8 sub_rb

Each command creates:
  - Verilog file: nbit_<type>_<N>bit.v
  - Testbench:   nbit_<type>_<N>bit_tb.v
