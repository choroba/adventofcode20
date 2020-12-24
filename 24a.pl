#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %STEPS = (se => [[1,  1], [ 0,  1]],
             ne => [[1, -1], [ 0, -1]],
             sw => [[0,  1], [-1,  1]],
             nw => [[0, -1], [-1, -1]],
             e  => [([ 1, 0]) x 2],
             w  => [([-1, 0]) x 2]);
my %tile;
while (<>) {
    my ($x, $y) = (0, 0);
    while (/([sn]?[ew])/g) {
        my $move = $STEPS{$1};
        $x += $move->[$y % 2][0];
        $y += $move->[$y % 2][1];
    }
    $tile{"$x:$y"} = ($tile{"$x:$y"} // 'white') eq 'white' ? 'black' : 'white';
}
say scalar grep $_ eq 'black', values %tile;


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
