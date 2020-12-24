#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use constant {WHITE => 'white',
              BLACK => 'black'};

my %STEPS = (se => [[1,  1], [ 0,  1]],
             ne => [[1, -1], [ 0, -1]],
             sw => [[0,  1], [-1,  1]],
             nw => [[0, -1], [-1, -1]],
             e  => [([ 1, 0]) x 2],
             w  => [([-1, 0]) x 2]);
my %colour;
while (<>) {
    my ($x, $y) = (0, 0);
    while (/([sn]?[ew])/g) {
        my $move = $STEPS{$1};
        $x += $move->[$y % 2][0];
        $y += $move->[$y % 2][1];
    }
    $colour{"$x:$y"} = WHITE eq ($colour{"$x:$y"} // WHITE)
                       ? BLACK
                       : WHITE;
}
for my $day (1 .. 100) {
    my %neighbours;
    @neighbours{ keys %colour } = (0) x keys %colour;
    for my $tile (keys %colour) {
        next if WHITE eq $colour{$tile};

        my ($x, $y) = split /:/, $tile;
        for my $direction (values %STEPS) {
            my $u = $x + $direction->[$y % 2][0];
            my $v = $y + $direction->[$y % 2][1];
            ++$neighbours{"$u:$v"};
        }
    }

    for my $tile (keys %neighbours) {
        if (BLACK eq ($colour{$tile} // WHITE)
            && (0 == $neighbours{$tile}
                || $neighbours{$tile} > 2)
        ) {
            $colour{$tile} = WHITE;

        } elsif (WHITE eq ($colour{$tile} // WHITE)
                 && 2 == $neighbours{$tile}
        ) {
            $colour{$tile} = BLACK;
        }
    }
}
say scalar grep BLACK eq $_, values %colour;

__DATA__
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
