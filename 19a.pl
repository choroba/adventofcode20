#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %rule;
while (<>) {
    chomp;
    last unless length;

    my ($n, $r) = split /: /;
    die $n if exists $rule{$n};
    $rule{$n} = $r;
}

my $regex = "^($rule{0})\$";
$regex =~ s/([0-9]+)/(?:$rule{$1})/g while $regex =~ /[0-9]/;
$regex =~ s/[ "]//g;

my $count = 0;
while (<>) {
    ++$count if /$regex/;
}
say $count;

__DATA__
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
