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
for my $x (keys %n) {
    my $y = SUM - $x;
    if (exists $n{$y}
        || $x == $y && $n{$x} > 1
    ) {
        say $x * $y;
        last
    }
}

__DATA__
1721
979
366
299
675
1456
