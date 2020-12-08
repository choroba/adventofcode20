#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @source = map [split], <>;
my $acc = 0;
my $pc = 0;
my @seen;
until ($seen[$pc]) {
    my %step = (
        nop => sub { ++$pc },
        acc => sub { $acc += $_[0]; ++$pc },
        jmp => sub { $pc += $_[0] });
    $seen[$pc] = 1;
    $step{ $source[$pc][0] }->( $source[$pc][1] );
}
say $acc;

__DATA__
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
