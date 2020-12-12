#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use GD;

use constant SCALE => 25;

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

my @path = ([$x, $y, $x + $u, $y + $v]);
while (<>) {
    my ($instruction, $number) = /(.)([-?0-9]+)/;
    $dispatch{$instruction}->($number);
    push @path, [$x, $y, $x + $u, $y + $v];
    warn join ", ", $x, $y, $x + $u, $y + $v;
}
my ($minx, $maxx, $miny, $maxy) = ($x, $x, $y, $y);
for my $i (0, 2) {
    for (@path) {
        $minx = $_->[$i]       if $_->[$i]       < $minx;
        $maxx = $_->[$i]       if $_->[$i]       > $maxx;
        $miny = $_->[ $i + 1 ] if $_->[ $i + 1 ] < $miny;
        $maxy = $_->[ $i + 1 ] if $_->[ $i + 1 ] > $maxy;
    }
}
say "$maxx $minx $maxy $miny";
my $img = 'GD::Image'->new(1 + ($maxx - $minx) / SCALE,
                           1 + ($maxy - $miny) / SCALE);
$img->colorAllocate(0, 0, 0);
my $boat     = $img->colorAllocate(191, 95, 0);
my $waypoint = $img->colorAllocate(255, 255, 255);
my $wp_old   = $img->colorAllocate(159, 159, 79);
my $old      = $img->colorAllocate(0, 0, 127);
my $last     = $img->colorAllocate(0, 127, 255);

my $prev = $path[0];
my $length = length scalar @path;
my $i = 0;
for my $step (@path) {
    $img->line(($prev->[0] - $minx) / SCALE, ($prev->[1] - $miny) / SCALE,
               ($step->[0] - $minx) / SCALE, ($step->[1] - $miny) / SCALE,
               $last);
    $img->setPixel(($step->[0] - $minx) / SCALE,
                   ($step->[1] - $miny) / SCALE, $boat);
    $img->setPixel(($step->[2] - $minx) / SCALE,
                   ($step->[3] - $miny) / SCALE, $waypoint);

    open my $out, '>', sprintf "12b-%0${length}d.gif", $i++ or die $!;
    print {$out} $img->gif;
    print STDERR "$i/" . scalar @path . "\r";

    $img->setPixel(($step->[2] - $minx) / SCALE,
                   ($step->[3] - $miny) / SCALE, $wp_old);

    $img->line(($prev->[0] - $minx) / SCALE, ($prev->[1] - $miny) / SCALE,
               ($step->[0] - $minx) / SCALE, ($step->[1] - $miny) / SCALE,
               $old);
    $prev = $step;
}
