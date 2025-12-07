#!/usr/bin/env perl
use strict;
use warnings;

# ensure current script dir is in @INC so local Stats.pm is found
use FindBin;
use lib "$FindBin::Bin";

use Stats;   # importing module functions (sum_array, max_array, min_array)

# -------------------------
#   PACKAGE EXAMPLE
# -------------------------
package VLSI::Report;
sub generate {
    my ($msg) = @_;
    print "\n======================================\n";
    print "     VLSI ANALYSIS REPORT\n";
    print "======================================\n";
    print "$msg\n";
    print "======================================\n";
}
package main;

# -------------------------
#     Input Data
# -------------------------
my @modules = ("ALU", "REGFILE", "MULT", "SHIFTER");

my %power = (
    ALU     => 12.5,
    REGFILE => 8.2,
    MULT    => 20.1,
    SHIFTER => 5.4
);

my %delay = (
    ALU     => 2.1,
    REGFILE => 1.4,
    MULT    => 3.7,
    SHIFTER => 0.9
);

my %area = (
    ALU     => 220,
    REGFILE => 180,
    MULT    => 350,
    SHIFTER => 120
);

# -------------------------
#   Restart Label (goto)
# -------------------------
START:

print "\nRunning VLSI Chip Power & Timing Analyzer...\n";

# -------------------------
#     Scalar Example
# -------------------------
my $design_name = "RISC-V Core";
print "\nDesign Name: $design_name\n";

# -------------------------
#     Array Example
# -------------------------
print "\nModules: @modules\n";

# -------------------------
#     Hash + Loop Analysis
# -------------------------
print "\nModule Analysis:\n";

foreach my $m (@modules) {

    my $p = $power{$m};
    my $d = $delay{$m};
    my $a = $area{$m};

    my $eff = $p / $d;   # arithmetic operator

    print "\n$m -> Power=$p mW | Delay=$d ns | Area=$a µm²\n";

    # Boolean behavior
    if ($p > 15) { print "High Power Module\n"; }
    else         { print "Low Power Module\n"; }

    unless ($d < 1) { print "Delay NOT extremely fast\n"; }

    # Nested IF
    if ($eff < 5) {
        print "Efficiency: EXCELLENT\n";
    }
    elsif ($eff < 8) {
        print "Efficiency: GOOD\n";
    }
    elsif ($eff < 12) {
        print "Efficiency: AVERAGE\n";
    }
    else {
        print "Efficiency: POOR\n";
    }

    # String operator
    my $tag = $m . "_BLOCK";
    print "Tag: $tag\n";

    # Replace experimental given/when with plain if/elsif to avoid feature warnings
    if ($m eq "ALU") {
        print "Type: Arithmetic Logic Unit\n";
    }
    elsif ($m eq "REGFILE") {
        print "Type: Register File\n";
    }
    elsif ($m eq "MULT") {
        print "Type: Multiplier\n";
    }
    elsif ($m eq "SHIFTER") {
        print "Type: Barrel Shifter\n";
    }
    else {
        print "Unknown Module Type\n";
    }
}

# -------------------------
#     Array Operations Using Module
# -------------------------
my @pwr_vals = map { $power{$_} } @modules;

print "\nTotal Power = ", sum_array(@pwr_vals), " mW\n";
print "Max Power   = ",  max_array(@pwr_vals), " mW\n";
print "Min Power   = ",  min_array(@pwr_vals), " mW\n";

# -------------------------
#   WHILE, UNTIL, FOR LOOPS
# -------------------------
print "\nIndexing using loops:\n";

my $i = 0;
while ($i < @modules) {
    print "Module[$i] = $modules[$i]\n";
    $i++;
}

my $j = 0;
until ($j == @modules) {
    print "UNTIL Loop -> $modules[$j]\n";
    $j++;
}

for (my $k=0; $k < @modules; $k++) {
    print "FOR Loop -> $modules[$k]\n";
}

# -------------------------
#   Package Output
# -------------------------
VLSI::Report::generate("VLSI Analysis Completed Successfully!");

# -------------------------
#   GOTO to rerun
# -------------------------
print "\nDo you want to run again? (y/n): ";
my $ans = <STDIN>;
chomp($ans);

goto START if ($ans eq 'y');

print "\nProgram Completed.\n";
