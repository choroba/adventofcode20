#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @map;
while (<>) {
    chomp;
    push @map, [split //];
}

my @VECTOR = (1, 3);
my $width = @{ $map[0] };
my ($x, $y) = (0, 0);
my $tree_tally = 0;
while ($x <= $#map) {
    ++$tree_tally if $map[$x][$y] eq '#';
    $x += $VECTOR[0];
    $y += $VECTOR[1];
    $y %= $width;
}
say $tree_tally;

__DATA__
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
