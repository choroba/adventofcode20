#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my @adapters = sort { $a <=> $b } 0, <> );
push @adapters, $adapters[-1] + 3;

my @ways = (1);
sub ways {
    my ($idx) = @_;
    return $ways[$idx] if $ways[$idx];

    my $from = $idx > 2 ? $idx - 3 : 0;
    ++$from while $adapters[$idx] - $adapters[$from] > 3;
    $ways[$idx] += ways($_) for $from .. $idx - 1;
    return $ways[$idx]
}

say ways($#adapters);

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
