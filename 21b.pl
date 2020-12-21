#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my (%unknown, %ingredient);
my @input;

while (<>) {
    my ($ingredient_string, $allergen_string) = /^(.*) \(contains (.*)\)/
        or die $_;
    @unknown{ my @allergens   = split /, /, $allergen_string } = ();
    @ingredient{ my @ingredients = split ' ', $ingredient_string } = ();
    push @input, [\@ingredients, \@allergens];
}

my %isnt;
for my $line (@input) {
    my %i = %ingredient;
    delete @i{ @{ $line->[0] } };
    for my $i (keys %i) {
        for my $allergen (@{ $line->[1] }) {
            undef $isnt{$i}{$allergen};
        }
    }
}

my %is;
while (%unknown) {
    my $known = (grep keys %{ $isnt{$_} } == keys(%unknown) - 1,
                 keys %isnt)[0];
    my %remaining = %unknown;
    delete @remaining{ keys %{ $isnt{$known} } };
    my $discovered = (keys %remaining)[0];
    $is{$discovered} = $known;
    delete $unknown{$discovered};
    delete $isnt{$_}{$discovered} for keys %isnt;
}

say join ',', @is{sort keys %is};

__DATA__
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
