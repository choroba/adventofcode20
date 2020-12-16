#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use List::Util qw{ product };

my %rules;

sub valid {
    for my $n (@_) {
        return 0
            unless grep $_->[0] <= $n && $n <= $_->[1], map @$_, values %rules;
    }
    return 1
}

sub populate_fields {
    my $size = keys %rules;
    map { { map +($_ => undef), keys %rules } } 1 .. $size;
}

my $phase = 'fields';
my @my_ticket;
my @fields;

my %dispatch;
%dispatch = (
    keep     => sub { @my_ticket = split /,/; $dispatch{identify}() },
    fields   => sub {
        my ($field, @ranges) = /^([a-z ]+): ([-0-9]+) or ([-0-9]+)/;
        $rules{$field} = [map [split /-/], @ranges];
    },
    identify => sub {
        my @v = split /,/;
        return unless valid(@v);
        for my $i (0 .. $#v) {
            for my $rule (keys %rules) {
                my $ok;
                for my $range (@{ $rules{$rule} }) {
                    $ok = 1 if $v[$i] >= $range->[0]
                            && $v[$i] <= $range->[1];
                }
                delete $fields[$i]{$rule} unless $ok;
            }
        }
    });

while (<>) {
    next if /^$/;

    chomp;
    $dispatch{$phase}() if /[-,]/;
    $phase = 'keep' if /^your ticket:$/;
    $phase = 'identify', @fields = populate_fields() if /^nearby tickets:$/;
}

sub field_with_single_possibility {
    for my $done (grep 1 == keys %{ $fields[$_] }, 0 .. $#fields) {
        for my $i (grep $_ != $done, 0 .. $#fields) {
            delete $fields[$i]{ (keys %{ $fields[$done] })[0] }
        }
    }
}

my %where;
for my $i (0 .. $#fields) {
    undef $where{$_}{$i} for keys %{ $fields[$i] };
}

sub valid_for_single_field {
    for my $done (grep 1 == keys %{ $where{$_} }, keys %where) {
        my $n = (keys %{ $where{$done} })[0];
        for my $other (grep $_ ne $done, keys %where) {
            delete $where{$other}{$n}
        }
        $fields[$n] = { $done => undef };
    }
}

while ((grep 1 < keys %$_, @fields) || (grep 1 < keys %$_, values %where)) {
    field_with_single_possibility();
    valid_for_single_field();
}

my $p = 1;
for my $field (grep /^departure\b/, keys %rules) {
    my $i = (keys %{ $where{$field} })[0];
    $p *= $my_ticket[$i];
}
say $p;

