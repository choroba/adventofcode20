#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %yes;
my $count;
my $size;
while (<>) {
    chomp;
    if ($_) {
        ++$yes{$_} for split //;
        ++$size;
    } else {
        $count += grep $yes{$_} == $size, keys %yes;
        %yes = ();
        $size = 0;
    }
}
$count += grep $yes{$_} == $size, keys %yes;
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
