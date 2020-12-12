#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @ROTATIONS = ([-1, 1], [-1, 1], [-1, 1], [-1, 1]);

my ($x, $y) = (0, 0);
my ($u, $v) = (10, -1);

sub rotate {
    my ($amount) = @_;
    $amount /= 90;
    $amount %= 4;
    for (1 .. $amount) {
        my $rotation = $ROTATIONS[ (($v >= 0) * 2 + ($u >= 0)) % 4 ];
        ($u, $v) = ($v * $rotation->[0], $u * $rotation->[1]);
    }
}

my %dispatch = (
    N => sub { $v -= $_[0] },
    S => sub { $v += $_[0] },
    E => sub { $u += $_[0] },
    W => sub { $u -= $_[0] },
    R => sub { rotate($_[0]) },
    L => sub { rotate($_[0] * 3) },
    F => sub {
        $x += $u * $_[0];
        $y += $v * $_[0];
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
