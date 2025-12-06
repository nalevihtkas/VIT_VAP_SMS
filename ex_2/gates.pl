#!/usr/bin/perl
use strict;
use warnings;

# Prompt user for gate type and number of inputs
print "Enter the gate type (and, or, nand, nor, xor): ";
chomp(my $gate = <STDIN>);
print "Enter the number of inputs: ";
chomp(my $num_inputs = <STDIN>);

# Validate inputs
die "Invalid gate type!" unless $gate =~ /^(and|or|nand|nor|xor)$/;
die "Invalid number of inputs!" unless $num_inputs =~ /^\d+$/ && $num_inputs > 1;

# Directories for output
my $dut_dir = "dut";
my $tb_dir = "tb";
mkdir $dut_dir unless -d $dut_dir;
mkdir $tb_dir unless -d $tb_dir;

# Generate unique file names
my $module_name = "${gate}_gate_${num_inputs}";
my $dut_file = "$dut_dir/$module_name.v";
my $tb_file = "$tb_dir/tb_$module_name.v";
my $counter = 1;
while (-e $dut_file || -e $tb_file) {
    $module_name = "${gate}_gate_${num_inputs}_$counter";
    $dut_file = "$dut_dir/$module_name.v";
    $tb_file = "$tb_dir/tb_$module_name.v";
    $counter++;
}

# Generate DUT file
open(my $dut_fh, '>', $dut_file) or die "Cannot open $dut_file: $!";
print $dut_fh <<"END";
// $module_name.v - $gate gate with $num_inputs inputs
module $module_name (
    input [${\($num_inputs - 1)}:0] a,
    output y
);
    assign y =
END
for my $i (0 .. $num_inputs - 1) {
    print $dut_fh ($i == 0 ? " a[$i]" : " $gate a[$i]");
}
print $dut_fh ";
endmodule
";
close $dut_fh;

# Generate testbench file
open(my $tb_fh, '>', $tb_file) or die "Cannot open $tb_file: $!";
print $tb_fh <<"END";
// tb_$module_name.v - Testbench for $module_name
`timescale 1ns/1ps
module tb_$module_name;
    reg [${\($num_inputs - 1)}:0] a;
    wire y;

    // Instantiate DUT
    $module_name dut (
        .a(a),
        .y(y)
    );

    initial begin
        \$display("Testing $module_name");
        a = 0; #10;
        \$display("a = %b, y = %b", a, y);
        a = {${\($num_inputs)}}'b1111; #10;
        \$display("a = %b, y = %b", a, y);
        a = {${\($num_inputs)}}'b1010; #10;
        \$display("a = %b, y = %b", a, y);
        \$stop;
    end
endmodule
END
close $tb_fh;

print "Verilog module and testbench generated successfully!\nModule file: $dut_file\nTestbench file: $tb_file\n";