#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @map = map [do { chomp; split // }], <>;

my $height = $#map;
my $width = $#{ $map[0] };

my $change = 1;
while ($change) {
    undef $change;

    my @adjacent;
    for my $y (0 .. $height) {
        for my $x (0 .. $width) {
            next if $map[$y][$x] ne '#';

            for my $j ($y - 1 .. $y + 1) {
                for my $i ($x - 1 .. $x + 1) {
                    next if $i == $x && $j == $y
                         || $j < 0 || $j > $height
                         || $i < 0 || $i > $width;

                    ++$adjacent[$j][$i];
                }
            }
        }
    }
    for my $y (0 .. $height) {
        for my $x (0 .. $width) {
            next if (my $current = $map[$y][$x]) eq '.';

            if ($current eq 'L' && ! $adjacent[$y][$x]) {
                $map[$y][$x] = '#';
                $change = 1;
            } elsif ($current eq '#' && ($adjacent[$y][$x] // 0) > 3) {
                $map[$y][$x] = 'L';
                $change = 1;
            }
        }
    }
}

my $count = grep $_ eq '#', map @$_, @map;
say $count;

__DATA__
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
