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

my @tallies;
my $width = @{ $map[0] };
for my $vector ([1, 1], [1, 3], [1, 5], [1, 7], [2, 1]) {
    my ($x, $y) = (0, 0);
    my $tree_tally = 0;
    while ($x <= $#map) {
        ++$tree_tally if $map[$x][$y] eq '#';
        $x += $vector->[0];
        $y += $vector->[1];
        $y %= $width;
    }
    push @tallies, $tree_tally;
}
my $p = 1;
$p *= $_ for @tallies;
say $p;

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
