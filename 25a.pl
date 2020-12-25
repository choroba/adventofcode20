#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $DIVIDER = 20201227;

sub secret {
    my ($value, $subject) = @_;
    $value *= $subject;
    $value %= $DIVIDER;
    $value
}

my $SUBJECT = 7;
chomp( my ($card_public, $door_public) = <> );

my $value = 1;
my $loop = 1;
my ($card_loop, $door_loop);
until ($card_loop && $door_loop) {
    $value = secret($value, $SUBJECT);
    $card_loop = $loop if $value == $card_public;
    $door_loop = $loop if $value == $door_public;
} continue {
    ++$loop;
}

$value = 1;
for (1 .. $card_loop) {
    $value = secret($value, $door_public);
}
say $value;

__DATA__
5764801
17807724
