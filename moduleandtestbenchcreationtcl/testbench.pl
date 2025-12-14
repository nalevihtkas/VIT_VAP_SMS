#!usr/bin/perl
$fn=$ARGV[0];
chomp($fn);
open(File,"$fn.v");
@l=<File>;
close(File);

open(opFile,'>'."$fn"."_tb.v");
print opFile "module $fn"."_tb();\n\n";

@fin=grep(/input/,@l);

foreach $li(@fin)
{
$li=~s/input/reg/;
print opFile $li;
}

@fout=grep(/output/,@l);

foreach $li(@fout)
{
$li=~s/output/wire/;
print opFile $li;
}

@uut=grep(/module/,@l);
$uutfirst = @uut[0];
@uutSec=split(" ",$uutfirst );
print "sample ",@uutSec[1];
$final=@uutSec[1];
$final=~s/$fn/$fn ut/;
print ("@final ",$final); 
print opFile "\n$final  \n\n initial \n begin\n //test case \n end\n endmodule";

close(opFile);
 



