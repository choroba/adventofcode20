#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use GD;

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
my @path = ([$x, $y, $facing]);
while (<>) {
    my ($instruction, $number) = /(.)([-?0-9]+)/;
    $dispatch{$instruction}->($number);
    push @path, [$x, $y, $facing];
}

my ($minx, $maxx, $miny, $maxy) = ($x, $x, $y, $y);
for (@path) {
    $minx = $_->[0] if $_->[0] < $minx;
    $miny = $_->[1] if $_->[1] < $miny;
    $maxx = $_->[0] if $_->[0] > $maxx;
    $maxy = $_->[1] if $_->[1] > $maxy;
}
++$maxx, ++$maxy, --$minx, --$miny;

my $img = 'GD::Image'->new($maxx - $minx, $maxy - $miny);
$img->colorAllocate(0, 0, 0);
my $boat = $img->colorAllocate(127, 63, 0);
my $bow  = $img->colorAllocate(255, 255, 0);
my $old  = $img->colorAllocate(0, 0, 127);
my $last = $img->colorAllocate(0, 127, 255);

my $prev = $path[0];
my $length = length scalar @path;
my $i = 0;
for my $step (@path) {
    $img->line($prev->[0] - $minx, $prev->[1] - $miny,
               $step->[0] - $minx, $step->[1] - $miny,
               $last);
    $img->setPixel($step->[0] - $minx, $step->[1] - $miny, $boat);

    my $bowx = $step->[0] - $minx + $MOVES[ $step->[2] ][0];
    my $bowy = $step->[1] - $miny + $MOVES[ $step->[2] ][1];
    my $under_bow = $img->getPixel($bowx, $bowy);
    $img->setPixel($bowx, $bowy, $bow);

    my $sternx = $step->[0] - $minx - $MOVES[ $step->[2] ][0];
    my $sterny = $step->[1] - $miny - $MOVES[ $step->[2] ][1];
    my $under_stern = $img->getPixel($sternx, $sterny);
    $img->setPixel($step->[0] - $minx, $step->[1] - $miny, $boat);
    $img->setPixel($sternx, $sterny, $boat);

    open my $out, '>', sprintf "12a-%0${length}d.gif", $i++ or die $!;
    print {$out} $img->gif;
    say "$i: ", $step->[0] - $minx, ', ', $step->[1] - $miny;
    $img->setPixel($bowx, $bowy, $under_bow);
    $img->setPixel($sternx, $sterny, $under_stern);
    $img->line($prev->[0] - $minx, $prev->[1] - $miny,
               $step->[0] - $minx, $step->[1] - $miny,
               $old);
    $prev = $step;
}
