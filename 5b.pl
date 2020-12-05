#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use BoardingPass;

my %seats;
my $max = 0;
while (<>) {
    chomp;
    my $bp = 'BoardingPass'->new(code => $_);
    undef $seats{ $bp->id };
    $max = $bp->id if $bp->id > $max;
}

my %all;
@all{ 0 .. $max } = ();
delete @all{ keys %seats };

for my $id (keys %all) {
    say $id if exists $seats{ $id - 1}
            && exists $seats{ $id + 1 };
}
