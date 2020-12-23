#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @cups = split //, <>;
pop @cups;
my $current_index = 0;
my $current = $cups[$current_index];

push @cups, 10 .. 1e6;
my @next;
for my $i (0 .. $#cups) {
    $next[ $cups[$i] ] = $cups[ ($i + 1) % @cups ];
}

my $MOVES = 10_000_000;
for my $move (1 .. $MOVES) {
    my %pick;
    undef @pick{$next[$current],
                $next[ $next[$current] ],
                my $last = $next[ $next[ $next[$current] ] ]};

    my $destination = ($current - 1) % @cups || @cups;
    $destination = ($destination - 1) % (@cups) || @cups
        while exists $pick{$destination};

    @next[$destination, $current, $last] = @next[$current, $last, $destination];
    $current = $next[$current];
}
say $next[1] * $next[ $next[1] ];

__DATA__
389125467
