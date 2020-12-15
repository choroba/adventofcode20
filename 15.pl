#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @data = split /,/, <>;
chomp $data[-1];

my %seen;
my $turn;
$seen{$_} = ++$turn for @data[0 .. $#data - 1];

my ($next, $n) = $data[-1];
while ($turn++ < 30000000) {
    $n = $next;
    $next = $seen{$n} ? $turn - $seen{$n} : 0;
    say $n if 2020 == ($seen{$n} = $turn);
}
say $n;

__DATA__
6,4,12,1,20,0,16
3,1,2
3,2,1
2,3,1
1,2,3
2,1,3
1,3,2
0,3,6
