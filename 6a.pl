#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %yes;
my $count;
while (<>) {
    chomp;
    if ($_) {
        ++$yes{$_} for split //;
    } else {
        $count += keys %yes;
        %yes = ();
    }
}
$count += keys %yes;
say $count;

__DATA__
abc

a
b
c

ab
ac

a
a
a
a

b
