#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant SUM => 2020;

my %n;
while (<>) {
    chomp;
    ++$n{$_};
}
FIND:
for my $x (keys %n) {
    my $s = SUM - $x;
    for my $y (keys %n) {
        next if $y == $x && $n{$x} == 1;

        my $z = $s - $y;
        if (exists $n{$z}) {
            say $x * $y * $z;
            last FIND
        }
    }
}

__DATA__
1721
979
366
299
675
1456
