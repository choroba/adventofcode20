#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use constant {WHITE => 'white',
              BLACK => 'black'};

sub show {
    my ($colour) = @_;
    my ($minx, $miny, $maxx) = (0, 0, 0);
    for my $tile (keys %$colour) {
        my ($x, $y) = split /:/, $tile;
        $minx = $x if $x < $minx;
        $miny = $y if $y < $miny;
        $maxx = $x if $x > $maxx;
    }
    my @tiles;
    for my $tile (keys %$colour) {
        my ($x, $y) = split /:/, $tile;
        $tiles[$y - $miny][$x - $minx] = BLACK eq $colour->{$tile}
                                       ? 'X'
                                       : '.';
    }
    for my $y (0 .. $#tiles) {
        print ' ' if $y % 2;
        for my $x (0 .. $maxx - $minx) {
            print +(0 == $y + $miny && 0 == $x + $minx)
                ? ($tiles[$y][$x] // '.') =~ tr/.X/o@/r
                : $tiles[$y][$x] // '.';
            print ' ';
        }
        print "\n";
    }
}


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
say "0: ", scalar grep BLACK eq $_, values %colour;
show(\%colour);
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
    say "$day: ", scalar grep BLACK eq $_, values %colour;
    show(\%colour); select undef, undef, undef, .1;
}


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
