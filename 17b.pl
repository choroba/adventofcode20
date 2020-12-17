#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

{   package Grid;
    use Moo;
    has grid => (is => 'ro');
    has width => (is => 'lazy');
    has height => (is => 'lazy');
    has depth => (is => 'lazy');
    has time => (is => 'lazy');
    has _neighbours => (is => 'lazy');

    sub at {
        my ($self, $x, $y, $z, $w) = @_;
        return 0 if $x < 0 || $y < 0 || $z < 0 || $w < 0;

        return ($self->grid->[$w]
                && $self->grid->[$w][$z]
                && $self->grid->[$w][$z][$y]
                && $self->grid->[$w][$z][$y][$x]) ? 1 : 0
    }

    sub iter {
        my ($self, $code, $m) = @_;
        $m //= 0;
        for my $w (0 .. $self->time - 1 + $m) {
            for my $z (0 .. $self->depth - 1 + $m) {
                for my $y (0 .. $self->height - 1 + $m) {
                    for my $x (0 .. $self->width - 1 + $m) {
                        $code->($x, $y, $z, $w);
                    }
                }
            }
        }
    }

    sub count {
        my ($self) = @_;
        my $c = 0;
        $self->iter(sub {
            my ($x, $y, $z, $w) = @_;
            ++$c if $self->at($x, $y, $z, $w);
        });
        return $c
    }

    sub neighbours {
        my ($self, $x, $y, $z, $w) = @_;
        $self->_neighbours->[ $w + 1 ][ $z + 1 ][ $y + 1 ][ $x + 1 ]
    }

    sub next {
        my ($self) = @_;
        my @next;
        $self->iter(sub {
            my ($x, $y, $z, $w) = @_;
            my $neighbours = $self->neighbours($x - 1, $y - 1, $z - 1, $w - 1);
            my $is_active = $self->at($x - 1, $y - 1, $z - 1, $w - 1);
            $next[$w][$z][$y][$x]
                = $is_active
                ? ($neighbours == 2 || $neighbours == 3)
                : ($neighbours == 3);
        }, 2);
        return \@next
    }

    sub _build_time   { scalar @{ $_[0]->grid } }
    sub _build_depth  { scalar @{ $_[0]->grid->[0] } }
    sub _build_height { scalar @{ $_[0]->grid->[0][0] } }
    sub _build_width  { scalar @{ $_[0]->grid->[0][0][0] } }

    sub _build__neighbours {
        my ($self) = @_;
        my @n;
        $self->iter(sub {
            my ($x, $y, $z, $w) = @_;
            for my $i (-1 .. 1) {
                for my $j (-1 .. 1) {
                    for my $k (-1 .. 1) {
                        for my $l (-1 .. 1) {
                            next unless $i || $j || $k || $l;

                            $n[ $w + $l + 1 ]
                                [ $z + $i + 1 ]
                                [ $y + $j + 1 ]
                                [ $x + $k + 1 ]
                                += $self->at($x, $y, $z, $w);
                        }
                    }
                }
            }
        });
        return \@n
    }
}

my @in;
while (<>) {
    chomp;
    push @in, [map $_ eq '#', split //];
}
my $grid = 'Grid'->new(grid => [[\@in]]);

for (1 .. 6) {
    $grid = 'Grid'->new(grid => $grid->next);
}

say $grid->count;

__DATA__
.#.
..#
###
