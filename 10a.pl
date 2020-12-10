#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my @adapters = sort { $a <=> $b } 0, <> );
push @adapters, $adapters[-1] + 3;

my %diff;
for my $i (1 .. $#adapters) {
    my $d = $adapters[$i] - $adapters[ $i - 1 ];
    ++$diff{$d};
    die $d if $d < 1 || $d > 3;
}

say $diff{1} * $diff{3};


__DATA__
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
