#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use lib '.';
use BoardingPass;

my $max = 0;
while (<>) {
    chomp;
    my $bp = 'BoardingPass'->new(code => $_);
    $max = $bp->id if $bp->id > $max;
}
say $max;

__DATA__
FBFBBFFRLR
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL
