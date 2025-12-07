package Stats;
use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw( sum_array max_array min_array );

sub sum_array {
    my @arr = @_;
    my $sum = 0;
    $sum += $_ for @arr;
    return $sum;
}

sub max_array {
    my @arr = @_;
    return undef unless @arr;
    my $max = $arr[0];
    for my $x (@arr) {
        if ($x > $max) {
            $max = $x;
        }
    }
    return $max;
}

sub min_array {
    my @arr = @_;
    return undef unless @arr;
    my $min = $arr[0];
    for my $x (@arr) {
        if ($x < $min) {
            $min = $x;
        }
    }
    return $min;
}

1;  # module must return true
