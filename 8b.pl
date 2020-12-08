#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

{   package Game::Console;
    use Moo;
    has source => (is => 'rw', required => 1);
    has debug  => (is => 'ro', default => 0);

    my %toggle = (jmp => 'nop', nop => 'jmp');
    sub fix {
        my ($self, $addr) = @_;
        $self->source->[$addr][0] = $toggle{ $self->source->[$addr][0] }
            or die 'Invalid fix';
    }
    sub run {
        my ($self) = @_;
        my $acc = 0;
        my $pc = 0;
        my @seen;
        my @trace;

        until ($pc > $#{ $self->source }) {
            my %step = (
                nop => sub { ++$pc },
                acc => sub { $acc += $_[0]; ++$pc },
                jmp => sub { $pc += $_[0] });
            $seen[$pc] = 1;
            push @trace, $pc;
            say "$pc: @{ $self->source->[$pc] } <$acc>" if $self->debug;
            $step{ $self->source->[$pc][0] }->( $self->source->[$pc][1] );
            die \@trace if $seen[$pc];
        }
        return $acc
    }
}

my @source = map [split], <>;

my $gc0 = 'Game::Console'->new(source => \@source);
eval { $gc0->run };
my $trace = $@;

my $last = $#$trace;
my $result;
while (1) {
    my $gc = 'Game::Console'->new(source => \@source);
    my $last = $#$trace;
    --$last until $gc->source->[ $trace->[$last] ][0] ne 'acc';
    $gc->fix($trace->[$last]);
    splice @$trace, $last;
    $result = eval { $gc->run };
    last if defined $result;
}
say $result;

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
