#!/usr/bin/perl
use strict;
use warnings;

# Prompt user for the bit width (n)
print "Enter the bit-width (e.g., 4 for a 4-bit adder or subtractor): ";
my $n = <STDIN>;
chomp($n);

# Check if the input is a valid number
if ($n !~ /^\d+$/ || $n <= 0) {
    die "Invalid input. Please enter a positive integer.\n";
}

# Prompt the user to choose between Ripple Carry Adder or Ripple Borrow Subtractor
print "Choose operation (1 for Adder, 2 for Subtractor): ";
my $choice = <STDIN>;
chomp($choice);

# Validate the choice input
if ($choice !~ /^[12]$/) {
    die "Invalid choice. Please select 1 for Adder or 2 for Subtractor.\n";
}

# Open the file for writing the Verilog code
my $file_name = $choice == 1 ? "rca$n.v" : "rbs$n.v";
open my $file, '>', $file_name or die "Could not open file '$file_name' for writing: $!\n";

# Generate the main module for either Adder or Subtractor
if ($choice == 1) {
    # Ripple Carry Adder (RCA)
    print $file "// $n-bit Ripple Carry Adder module\n";
    print $file "module rca$n (input [", $n-1, ":0] a, input [", $n-1, ":0] b, input cin, output [", $n-1, ":0] sum, output cout);\n";

    my $carry = "cin";
    for (my $i = 0; $i < $n; $i++) {
        print $file "    full_adder fa$i (.a(a[$i]), .b(b[$i]), .cin($carry), .sum(sum[$i]), .cout(carry$i));\n";
        $carry = "carry$i";
    }
    print $file "    assign cout = carry", ($n-1), ";\n";
    print $file "endmodule\n";
} elsif ($choice == 2) {
    # Ripple Borrow Subtractor (RBS)
    print $file "// $n-bit Ripple Borrow Subtractor module\n";
    print $file "module rbs$n (input [", $n-1, ":0] a, input [", $n-1, ":0] b, input bin, output [", $n-1, ":0] diff, output bout);\n";

    my $borrow = "bin";
    for (my $i = 0; $i < $n; $i++) {
        print $file "    full_subtractor fs$i (.a(a[$i]), .b(b[$i]), .bin($borrow), .diff(diff[$i]), .bout(borrow$i));\n";
        $borrow = "borrow$i";
    }
    print $file "    assign bout = borrow", ($n-1), ";\n";
    print $file "endmodule\n";
}

# Add the corresponding submodule (either full_adder or full_subtractor)
if ($choice == 1) {
    print $file "// Full Adder module\n";
    print $file "module full_adder (input a, input b, input cin, output sum, output cout);\n";
    print $file "    assign {cout, sum} = a + b + cin;\n";
    print $file "endmodule\n";
} elsif ($choice == 2) {
    print $file "// Full Subtractor module\n";
    print $file "module full_subtractor (input a, input b, input bin, output diff, output bout);\n";
    print $file "    assign {bout, diff} = a - b - bin;\n";
    print $file "endmodule\n";
}

# Close the file after writing
close $file;
print "Verilog code has been written to '$file_name'.\n";