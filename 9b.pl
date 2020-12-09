#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant PREAMBLE_SIZE => 25;

my $pos = do { no warnings 'unopened'; tell *ARGV };
$pos = 0 if $pos < 0;
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

my $invalid;
while (<>) {
    chomp;
    my $new = $_;
    $invalid = $new, last unless exists $sums{$new};
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

seek *ARGV, $pos, 0;
chomp( @array = <> );

%sums = (0 => 0);
SEARCH:
for my $i (0 .. $#array) {
    my $new = $array[$i];
    for my $start (keys %sums) {
        my $sum = $sums{$start};
        if ($sum + $new > $invalid) {
            delete $sums{$start};
            next
        }
        $sums{$start} += $new;
        $sums{$i} = $new;
        if ($sums{$start} == $invalid) {
            my ($min, $max) = ($array[$start]) x 2;
            for my $e (@array[$start + 1 .. $i]) {
                $min = $e if $e < $min;
                $max = $e if $e > $max;
            }
            say $min + $max;
            last SEARCH
        }
    }
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
