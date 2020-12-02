#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $ok = 0;
while (<>) {
    my ($range, $letter, $password) = split;
    substr $letter, -1, 1, "";
    my ($from, $to) = split /-/, $range;
    my $count = eval "\$password =~ tr/$letter//";
    ++$ok if $from <= $count && $count <= $to;
}
say $ok;

__DATA__
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
