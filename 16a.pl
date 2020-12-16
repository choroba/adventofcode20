#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my $phase = 'fields';
my @rules;
my @invalid;
my %dispatch = (
    ignore   => sub {},
    fields   => sub { push @rules, [split /-/, $1] while /([-0-9]+)/g },
    validate => sub {
        for my $n (split /,/) {
            push @invalid, $n
                unless grep $_->[0] <= $n && $n <= $_->[1], @rules;
        }
    });
while (<>) {
    next if /^$/;

    chomp;
    $dispatch{$phase}() if /[-,]/;
    $phase = 'ignore'   if /^your ticket:$/;
    $phase = 'validate' if /^nearby tickets:$/;
}
say sum(@invalid);

__DATA__
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12

