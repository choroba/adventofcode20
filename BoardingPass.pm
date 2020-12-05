package BoardingPass;
use warnings;
use strict;
use Moo;

has code => (is => 'ro', required => 1, isa => \&_validate_code);
has [qw[ row column id ]] => (is => 'lazy', init_arg => undef);


sub _validate_code {
    my ($code) = @_;
    die "Invalid code $code.\n" unless $code =~ /^[BF]{7}[RL]{3}$/;
}

sub _from_binary {
    my ($self, $from, $length, $div) = @_;
    local $_ = substr $self->code, $from, $length;
    tr/FBLR/0101/;
    substr $_, 0, 0, '0' x (8 - length);
    return unpack 'C', pack 'B*', $_
}

sub _build_row    { $_[0]->_from_binary(0, 7, 2) }
sub _build_column { $_[0]->_from_binary(7, 3, 1) }

sub _build_id {
    my ($self) = @_;
    8 * $self->row + $self->column
}

__PACKAGE__
