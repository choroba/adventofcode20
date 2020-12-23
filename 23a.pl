#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @cups = split //, <>;
pop @cups;
my $current_index = 0;

for my $move (1 .. 100) {
    my @pick_indexes = map +($current_index + $_) % @cups, 1 .. 3;
    my @pick = @cups[@pick_indexes];
    splice @cups, $_, 1 for sort { $b <=> $a } @pick_indexes;
    $current_index -= grep $_ < $current_index, @pick_indexes;

    my $destination = ($cups[$current_index] - 1) % (@pick + @cups)
                    || (@pick + @cups);
    $destination = ($destination - 1) % (@pick + @cups) || (@pick + @cups)
        while grep $_ == $destination, @pick;

    my $destination_index
        = (grep $cups[$_] == $destination, 0 .. $#cups)[0] + 1 % @cups;
    splice @cups, $destination_index, 0, @pick;
    $current_index += 3 if $destination_index <= $current_index;

    $current_index = ($current_index + 1) % @cups;
}
my @result = (@cups, @cups);
shift @result until $result[0] == 1;
say @result[1 .. $#cups];

__DATA__
389125467
