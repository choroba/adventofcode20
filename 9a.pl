#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant PREAMBLE_SIZE => 25;

my @array;
push @array, scalar <> for 1 .. PREAMBLE_SIZE;
chomp @array;
my %sums;
for my $i0 (0 .. $#array - 1) {
    for my $i1 ($i0 + 1 .. $#array) {
        next if $array[$i0] == $array[$i1];

        ++$sums{ $array[$i0] + $array[$i1] };
    }
}

while (<>) {
    chomp;
    my $new = $_;
    say $new unless exists $sums{$new};
    my $forget = shift @array;
    for my $a0 (@array) {
        next if $a0 == $forget;

        --$sums{ $a0 + $forget } or delete $sums{ $a0 + $forget };
    }
    for my $a0 (@array) {
        next if $a0 == $new;
        ++$sums{ $a0 + $new };
    }
    push @array, $new;
}

__DATA__
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
