#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my (%allergen, %ingredient);
my @input;

while (<>) {
    my ($ingredient_string, $allergen_string) = /^(.*) \(contains (.*)\)/
        or die $_;
    my @ingredients = split ' ', $ingredient_string;
    my @allergens   = split /, /, $allergen_string;
    @allergen{@allergens} = ();
    ++$ingredient{$_} for @ingredients;
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

my @clean = grep keys %{ $isnt{$_} } == keys %allergen, keys %isnt;

say sum(@ingredient{@clean});

__DATA__
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
