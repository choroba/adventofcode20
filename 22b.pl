#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

sub score {
    my @decks = @_;
    my $score;
    for my $player (1, 2) {
        for my $card_index (0 .. $#{ $decks[$player] }) {
            $score += ($card_index + 1) * $decks[$player][ -$card_index - 1];
        }
    }
    return $score
}

sub game {
    my @decks = (@_);
    my %played;
    while (@{ $decks[1] } && @{ $decks[2] }) {
        if (exists $played{"@{ $decks[1] } | @{ $decks[2] }"}) {

            return $decks[0] ? score(@decks) : 1
        }

        undef $played{"@{ $decks[1] } | @{ $decks[2] }"};
        my $winner;
        if (   $decks[1][0] < @{ $decks[1] }
            && $decks[2][0] < @{ $decks[2] }
        ) {
            $winner = game(0, [@{ $decks[1] }[1 .. $decks[1][0]] ],
                              [@{ $decks[2] }[1 .. $decks[2][0]] ]);
        } else {
            $winner = 1 + ($decks[1][0] < $decks[2][0]);
        }
        push @{ $decks[$winner] }, shift @{ $decks[$winner] },
            shift @{ $decks[ ($winner - 1) || 2 ] };
    }

    return $decks[0] ? score(@decks) : 1 + ! @{ $decks[1] }
}

my $player;
my @decks;
while (<>) {
    next if /^$/;
    if (/Player (.):/) {
        $player = $1;
    } else {
        chomp;
        push @{ $decks[$player] }, $_;
    }
}

$decks[0] = 'score';
my $score = game(@decks);

say $score;

__DATA__
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
