#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @map = map [do { chomp; split // }], <>;

my $height = $#map;
my $width = $#{ $map[0] };
my @directions = map {
    my $y = $_;
    map +($y == 0 && $_ == 0) ? () : [$y, $_], -1 .. 1
} -1 .. 1;

my $change = 1;
while ($change) {
    undef $change;

    my @see;
    for my $y (0 .. $height) {
        for my $x (0 .. $width) {
            next if $map[$y][$x] eq '.';

            for my $dir (@directions) {
                my ($j, $i) = ($y, $x);
                my ($n, $m) = @$dir;
                while (1) {
                    $i += $m;
                    $j += $n;
                    last if $j < 0 || $j > $height
                         || $i < 0 || $i > $width;

                    next if $map[$j][$i] eq '.';

                    ++$see[$y][$x] if $map[$j][$i] eq '#';
                    last
                }
            }
        }
    }
    for my $y (0 .. $height) {
        for my $x (0 .. $width) {
            next if (my $current = $map[$y][$x]) eq '.';

            if ($current eq 'L' && ! $see[$y][$x]) {
                $map[$y][$x] = '#';
                $change = 1;
            } elsif ($current eq '#' && ($see[$y][$x] // 0) > 4) {
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
