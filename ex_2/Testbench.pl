#!/usr/bin/perl
use warnings;

print "Enter the file name:";
$fn = <stdin>;
chomp($fn);
open(File,"$fn.v");
@l = <File>;
close(File);

open(File1,'>'."$fn"."_tb.v");
print File1 "module $fn"."_tb();\n\n";

@fin = grep(/input/,@l);

foreach $li(@fin)
{
$li =~ s/input/reg/;
print File1 $li;
}

@fot = grep(/output/,@l);

foreach $li(@fot)
{
$li =~ s/output/wire/;
print File1 $li;
}

@mn  = grep(/module/,@l);
@smn = split(' ',$mn[0]);
print File1 "\n$smn[1] I1 $smn[2]\n\ninitial\nbegin\n\n\t//Testcase\n\nend\n\nendmodule";

close(File1);