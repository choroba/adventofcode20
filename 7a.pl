#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

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

for my $bag (keys %rules) {
    for my $inner (grep @$_, @{ $rules{$bag}{in} }) {
        push @{ $rules{ $inner->[1] }{out} }, $bag;
    }
}

my %bags;
my %next = ('shiny gold' => undef);
while (%next) {
    my %next2;
    for my $bag (keys %next) {
        undef $bags{$bag};
        @next2{ @{ $rules{$bag}{out} // [] } } = ();
    }
    %next = %next2;
}

say keys(%bags) - 1;

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
