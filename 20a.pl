#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ product };

sub column {
    my ($tile, $x) = @_;
    join "", map substr($tile->[$_], $x, 1), 0 .. $#$tile
}

my $id;
my %tile;
while (<>) {
    chomp;
    next unless length;

    if (/Tile ([0-9]+):/) {
        $id = $1;
    } elsif ($id) {
        push @{ $tile{$id} }, $_;
    }
}

my %pattern;
for my $id (keys %tile) {
    my $tile = $tile{$id};
    my ($left, $right) = map column($tile, $_), 0, -1;
    undef $pattern{$_}{$id} for $tile->[0],  scalar reverse($tile->[0]),
                                $tile->[-1], scalar reverse($tile->[-1]),
                                $left,       scalar reverse($left),
                                $right,      scalar reverse($right);
}

my %neighbour;
for my $p (keys %pattern) {
    my @ids = keys %{ $pattern{$p} };
    next if 1 == @ids;
    die $p if 2 < @ids;
    undef $neighbour{ $ids[0] }{ $ids[1] };
    undef $neighbour{ $ids[1] }{ $ids[0] };
}

my @corners = grep 2 == keys %{ $neighbour{$_} }, keys %neighbour;

say product(@corners);

__DATA__
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
