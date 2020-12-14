#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

sub from_bin {
    my ($bin) = @_;
    return do { no warnings 'portable'; oct "0b$bin" }
}

my ($mask, %mem);
my ($or_mask, $and_mask);
while (<>) {
    if (/^mask = ([01X]+)/) {
        $mask = $1;
        $or_mask  = from_bin($mask =~ tr/X/0/r);
        $and_mask = from_bin($mask =~ tr/X/1/r);

    } elsif (/mem\[([0-9]+)\] = ([0-9]+)/) {
        my ($address, $value) = ($1, $2);
        $value = $value & $and_mask | $or_mask;
        $mem{$address} = $value;

    } else {
        die "Invalid instruction at $.";
    }
}

say sum(values %mem);

__DATA__
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
