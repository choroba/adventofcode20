#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use List::Util qw{ sum };
use Marpa::R2;

my $DSL = << '__DSL__';

:default ::= action => [name,values]
lexeme default = latm => 1

Expression ::= ('(') Expression (')')  assoc => group  action => ::first
             | digits                                  action => ::first
            || Expression op Expression                action => main::operate

whitespace ~ [\s]+
digits     ~ [\d]+
op         ~ [+*]
:discard   ~ whitespace

__DSL__

sub operate {
    {'+' => sub { $_[0] + $_[1] },
     '*' => sub { $_[0] * $_[1] }
    }->{$_[2]}->($_[1], $_[3])
}

my $grammar = 'Marpa::R2::Scanless::G'->new({source => \$DSL});
sub evaluate {
    my ($expression) = @_;
    return ${ $grammar->parse(\$expression) }
}

use Test::More;

is evaluate('1 + 2 * 3 + 4 * 5 + 6'), 71;
is evaluate('1 + (2 * 3) + (4 * (5 + 6))'), 51;
is evaluate('2 * 3 + (4 * 5)'), 26;
is evaluate('5 + (8 * 3 + 9 + 3 * 4 * 3)'), 437;
is evaluate('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))'), 12240;
is evaluate('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'), 13632;

done_testing();

say sum(map evaluate($_), <>);
