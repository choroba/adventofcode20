#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my %rules;
while (<>) {
    die "Unknown input $_" unless /^(.*?) bags contain (no other bags|.*)\.$/;

    my ($outer, $inner) = ($1, $2);
    my @inner;
    if ($inner ne 'no other bags') {
        while ($inner =~ /([0-9]+) (.+?) bags?/g) {
            push @inner, [$1, $2];
        }
    }
    $rules{$outer}{in} = \@inner;
}

my %bags;
my %agenda = ('shiny gold' => 1);
while (keys %agenda) {
    my %next;
    for my $bag (keys %agenda) {
        $bags{$bag} += $agenda{$bag};
        for my $in (@{ $rules{$bag}{in} // [] }) {
            $next{ $in->[1] } += $in->[0] * $agenda{$bag};
        }
    }
    %agenda = %next;
}

say sum(values %bags) - 1;

# shiny gold bags contain 2 dark red bags.
# dark red bags contain 2 dark orange bags.
# dark orange bags contain 2 dark yellow bags.
# dark yellow bags contain 2 dark green bags.
# dark green bags contain 2 dark blue bags.
# dark blue bags contain 2 dark violet bags.
# dark violet bags contain no other bags.

__DATA__
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
