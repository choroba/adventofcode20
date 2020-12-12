#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @MOVES = ([1, 0], [0, 1], [-1, 0], [0, -1]);

my $facing = 0;  # EAST SOUTH WEST NORTH
my ($x, $y) = (0, 0);

my %dispatch = (
    N => sub { $y -= $_[0] },
    S => sub { $y += $_[0] },
    E => sub { $x += $_[0] },
    W => sub { $x -= $_[0] },
    L => sub { $facing -= $_[0] / 90; $facing %= 4 },
    R => sub { $facing += $_[0] / 90; $facing %= 4 },
    F => sub {
        my $direction = $MOVES[$facing];
        $x += $direction->[0] * $_[0];
        $y += $direction->[1] * $_[0];
    }
);
while (<>) {
    my ($instruction, $number) = /(.)([-?0-9]+)/;
    $dispatch{$instruction}->($number);
}
say abs($x) + abs($y);

__DATA__
F10
N3
F7
R90
F11
