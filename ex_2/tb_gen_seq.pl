#!/usr/bin/perl
use strict;
use warnings;

# Open files
open my $out, ">", "count_tb.v" or die "Cannot open output file: $!";
open my $in, "<", "count.v" or die "Cannot open input file: $!";

# Variables
my ($name, $ports, $input, $output, @inputs, @outputs);

# Read the input file
while (my $line = <$in>) {
    if ($line =~ /module\s+(\w+)\s*\((.*)\)\;/) {
        $name = $1;
        $ports = $2;
    }
    if ($line =~ /input\s+(.*)\;/) {
        $input = $1;
        @inputs = split /,/, $input;
    }
    if ($line =~ /output\s+(.*)\;/) {
        $output = $1;
        @outputs = split /,/, $output;
    }
}

# Write to the output file
print $out "module ${name}_tb;\n\n";
print $out "reg ", join(", ", @inputs), ";\n";
print $out "wire ", join(", ", @outputs), ";\n\n";
print $out "$name ${name}_1(", join(", ", @inputs, @outputs), ");\n\n";

# Initial block for the clock and reset
print $out "initial begin\n";
print $out "    $inputs[0] = 1'b0;  // clk\n";
print $out "    $inputs[1] = 1'b1;  // rst\n";
print $out "    #20 $inputs[1] = 1'b0;  // Release reset\n";
print $out "end\n\n";

# Clock generation
print $out "always #5 $inputs[0] = ~$inputs[0];\n\n";

# Monitoring output
print $out "initial begin\n";
print $out "    \$monitor(\"%b %b %b\", $inputs[0], $inputs[1], $outputs[0]);\n";
print $out "end\n\n";

print $out "endmodule\n";

# Close files
close $in;
close $out;