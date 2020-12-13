#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

<>;
my @buses = split /,/, <>;
chomp $buses[-1];

my %buses;
for my $i (0 .. $#buses) {
    next if $buses[$i] eq 'x';

    $buses{ $buses[$i] } = ($buses[$i] - ($i || $buses[$i])) % $buses[$i];
}

sub find_multiple_with_remainders {
    my ($x, $y, $rx, $ry) = @_;
    my $m = $x + $rx;
    $m += $x until $m % $y == $ry;
    return $m
}

my @order = keys %buses;
my @prev = ($order[0], $buses{ $order[0] });
for my $i (1 .. $#order) {
    @prev = ($prev[0] * $order[$i],
             find_multiple_with_remainders($prev[0], $order[$i], $prev[1],
                                           $buses{ $order[$i] }));
}

say $prev[1];

__DATA__
939
7,13,x,x,59,x,31,19
