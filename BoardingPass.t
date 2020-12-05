#! /usr/bin/perl
use warnings;
use strict;

use FindBin;
use lib $FindBin::Bin;
use BoardingPass;

use Test::More;
use Test::Exception;

throws_ok { 'BoardingPass'->new(code => 'XYZ') } qr/Invalid code/;

{   my $o = 'BoardingPass'->new(code => 'FBFBBFFRLR');
    is $o->row, 44;
    is $o->column, 5;
    is $o->id, 357;
}
{   my $o = 'BoardingPass'->new(code => 'BFFFBBFRRR');
    is $o->row, 70;
    is $o->column, 7;
    is $o->id, 567;
}
{   my $o = 'BoardingPass'->new(code => 'FFFBBBFRRR');
    is $o->row, 14;
    is $o->column, 7;
    is $o->id, 119;
}
{   my $o = 'BoardingPass'->new(code => 'BBFFBBFRLL');
    is $o->row, 102;
    is $o->column, 4;
    is $o->id, 820;
}

done_testing();
