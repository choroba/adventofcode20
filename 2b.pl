#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $ok = 0;
while (<>) {
    my ($positions, $letter, $password) = split;
    substr $letter, -1, 1, "";
    my @positions = grep $_ <= length $password,
                    map $_ - 1,
                    split /-/, $positions;
    ++$ok if 1 == grep $letter eq $_,
                  map substr($password, $_, 1),
                  @positions;
}
say $ok;

__DATA__
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
