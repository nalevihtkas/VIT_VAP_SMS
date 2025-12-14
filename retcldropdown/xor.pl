#!/usr/bin/perl
$module=$ARGV[0];
$a=$ARGV[1];
$b=$ARGV[2];
$c=$ARGV[3];
chomp($module,$a,$b,$c);
open(vlog,">$module".".v");
print vlog"module $module($c,$b,$a);\n";
print vlog"input $a,$b;\n";
print vlog"output $c;\n";
print vlog"assign $c=$a^$b;\n";
print vlog"endmodule";
close vlog;

