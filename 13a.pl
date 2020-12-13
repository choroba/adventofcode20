#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my $t0 = <> );
my @buses = grep ! /x/, split /,/, <>;
chomp $buses[-1];

sub departure {
    my ($i) = @_;
    $buses[$i] - $t0 % $buses[$i]
}

my $min_index = 0;
for my $i (1 .. $#buses) {
    $min_index = $i if  departure($i) < departure($min_index);
}
say $buses[$min_index] * departure($min_index);

__DATA__
939
7,13,x,x,59,x,31,19
