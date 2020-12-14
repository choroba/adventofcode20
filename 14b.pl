#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

sub from_bin {
    my ($bin) = @_;
    my ($x, $y) = unpack 'N2', pack 'B64', ('0' x 28) . $bin;
    return $x * 2 ** 32 + $y
}

sub to_bin {
    my ($dec) = @_;
    my $x = int($dec / 2 ** 32);
    my $y = $dec % 2 ** 32;
    return join "", substr(unpack('B32',  pack 'N', $x), -4),
                    unpack 'B32', pack 'N', $y;
}

sub expand {
    my ($address, $mask) = @_;
    my $pos = rindex $mask, '-';
    return $address if 35 == $pos;

    ++$pos;
    my $char = substr $mask, $pos, 1, '-';
    if ('X' eq $char) {
        my $address2 = $address;
        substr $address,  $pos, 1, '0';
        substr $address2, $pos, 1, '1';
        return expand($address, $mask), expand($address2, $mask)
    }
    substr $address, $pos, 1, '1' if '1' eq $char;
    return expand($address, $mask)
}

my ($mask, %mem);
while (<>) {
    if (/^mask = ([01X]+)/) {
        $mask = $1;

    } elsif (/mem\[([0-9]+)\] = ([0-9]+)/) {
        my ($address, $value) = ($1, $2);
        my @addresses = map from_bin($_), expand(to_bin($address), $mask);
        @mem{@addresses} = ($value) x @addresses;

    } else {
        die "Invalid instruction at $.";
    }
}

say sum(values %mem);

__DATA__
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
