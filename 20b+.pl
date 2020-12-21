#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

# Turn on colours in grep and run with 
# | GREP_COLORS='mt=7;1;33' grep --color=always 'O\|$'
# to highlight the monsters.

use ARGV::OrDATA;

sub column {
    my ($tile, $x) = @_;
    join "", map substr($tile->[$_], $x, 1), 0 .. $#$tile
}

sub pattern {
    my ($tile, $transformation) = @_;
    my ($left, $right) = map column($tile, $_), 0, -1;
    ($tile->[0],  scalar reverse($tile->[0]),
     $tile->[-1], scalar reverse($tile->[-1]),
     $left,       scalar reverse($left),
     $right,      scalar reverse($right))[$transformation]
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
    my @borders = map pattern($tile, $_), 0 .. 7;
    $pattern{ $borders[$_] }{$id} = $_ for 0 .. $#borders;
}

my %neighbour;
for my $p (keys %pattern) {
    my @ids = keys %{ $pattern{$p} };
    next if 1 == @ids;
    die $p if 2 < @ids;
    $neighbour{ $ids[0] }{ $ids[1] } = [@{ $pattern{$p} }{@ids[0, 1]}];
    $neighbour{ $ids[1] }{ $ids[0] } = [@{ $pattern{$p} }{@ids[1, 0]}];
}

sub flip { [reverse @{ $_[0] } ] }

sub rotate {
    my ($tile, $n) = @_;
    return $tile unless $n;

    for (1 .. $n) {
        my @t2;
        for my $y (reverse 0 .. $#$tile) {
            for my $x (0 .. length($tile->[$y]) - 1) {
                $t2[$x] .= substr $tile->[$y], $x, 1;
            }
        }
        $tile = \@t2;
    }
    return $tile
}

sub move {
    my ($tile, $flip, $rotate) = @_;
    return rotate($flip ? flip($tile) : $tile, $rotate)
}

my $first = (grep 2 == keys %{ $neighbour{$_} }, keys %neighbour)[0];
my %used = ($first => undef);
my $tile = $tile{$first};
my @borders = sort { $a <=> $b } map $_->[0], values %{ $neighbour{$first} };
$tile = flip($tile) if $borders[0] < 2;
$tile = move($tile, 1, 2) if $borders[1] < 6;
my @tiles = ([[$first, $tile]]);

my %MOVES = (R => [3, 1, 0, 2],
             D => [0, 2, 1, 3]);
sub neighbour {
    my ($tile, $x, $y, $pattern, $direction, $flip, $rotate) = @_;
    return if $tiles[$y][$x];
    my $tile_id = $tile->[0];

    my $p1 = pattern($tile->[1], $pattern);
    if (my @next = grep ! exists $used{$_},
                   keys %{ $neighbour{$tile_id} }
    ) {
        for my $next (@next) {
            my $p2 = pattern($tile{$next},
                             $neighbour{$tile_id}{$next}[1]);
            if ($p2 eq $p1 || $p2 eq reverse $p1) {
                my $new = rotate(
                    $tile{$next},
                    $MOVES{$direction}[ $neighbour{$tile_id}{$next}[1] / 2 ]);
                $new = move($new, $flip, $rotate)
                    if pattern($new, $pattern - 1) eq $p1;
                $tiles[$y][$x] = [$next, $new];
                undef $used{$new};
                last
            }
        }
    }
}

until (keys %used == keys %tile) {
    for my $y (0 .. $#tiles) {
        for my $x (0 .. $#{ $tiles[$y] }) {
            neighbour($tiles[$y][$x], $x + 1, $y, 6, 'R', 1, 0);
            neighbour($tiles[$y][$x], $x, $y + 1, 2, 'D', 1, 2);
        }
    }
}

my @lines;
my $length = length($tiles[0][0][1][0]) - 2;
my $octothorpes = 0;
for my $line (@tiles) {
    for my $i (1 .. $#{ $line->[0][1] } - 1) {
        push @lines, join "", map substr($_->[1][$i], 1, $length), @$line;
        $octothorpes += $lines[-1] =~ tr/#//;
    }
}

my $monsters = 0;
for my $step (1 .. 8) {
    @lines = @{ rotate(flip(\@lines), $step % 2) };
    for my $i (0 .. $#lines) {
        # We need to match a different variable, as part of $lines[$i]
        # is changing.
        my $l = $lines[$i];
        while ($l =~ /(?=[#O].{4}[#O]{2}.{4}[#O]{2}.{4}[#O]{3})/g) {
            my $pos = pos $l;
            if (substr($lines[ $i - 1 ], $pos + 18, 1) =~ /^[#O]/
                && substr($lines[ $i + 1 ], $pos + 1) =~ /^[#O]..[#O]..[#O]..[#O]..[#O]..[#O]/
            ) {
                substr $lines[ $i - 1 ], $pos + 18, 1, 'O';
                substr($lines[$i], $pos)
                    =~ s/^[#O](....)[#O]{2}(....)[#O]{2}(....)[#O]{3}/O$1OO$2OO$3OOO/;
                substr($lines[ $i + 1 ], $pos + 1)
                    =~ s/^[#O](..)[#O](..)[#O](..)[#O](..)[#O](..)[#O]/O$1O$2O$3O$4O$5O/;
                ++$monsters;
            }
        }
    }
}
say $octothorpes - $monsters * 15;

say for @lines;

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
