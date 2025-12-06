#!/usr/bin/perl
use strict;
use warnings;

# Open files
open my $out, ">", "fulladd_tb.v" or die "Cannot open output file: $!";
open my $in, "<", "fulladd.v" or die "Cannot open input file: $!";

# Variables
my $test_vector = 9;
my ($name, $portlist, $input, $output, @inputs);

# Read the input file
while (my $a = <$in>) {
    if ($a =~ /module\s+(\w+)\s*\((.*)\)\;/) {
        $name = $1;
        $portlist = $2;
    }
    if ($a =~ /input\s+(.*)\;/) {
        $input = $1;
        @inputs = split /,/, $input;
    }
    if ($a =~ /output\s+(.*)\;/) {
        $output = $1;
    }
}

# Write to the output file
print $out "module ${name}_test;\n\n";
print $out "reg $input;\n";
print $out "wire $output;\n";
print $out "$name f1($portlist);\n\n";

print $out "initial begin\n";

# Generate random test vectors
for my $i (0 .. $test_vector - 1) {
    foreach my $signal (@inputs) {
        my $data = int(rand(2));
        print $out "#205 $signal = $data;\n";
    }
    print $out "\n";
}

print $out "#200 \$stop;\n";
print $out "end\n\n";
print $out "endmodule\n";

# Close files
close $in;
close $out;