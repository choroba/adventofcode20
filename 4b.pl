#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $FOUR_DIGITS = qr/^[0-9]{4}$/;
my %HEIGHT_RANGE = (cm => [150, 193], in => [59, 76]);

my %valid = (
    byr => sub {
        return unless /$FOUR_DIGITS/ && $_ >= 1920 && $_ <= 2002 },
    iyr => sub {
        return unless /$FOUR_DIGITS/ && $_ >= 2010 && $_ <= 2020 },
    eyr => sub {
        return unless /$FOUR_DIGITS/ && $_ >= 2020 && $_ <= 2030 },
    hgt => sub {
        return unless /^([0-9]+)(cm|in)$/
            && $HEIGHT_RANGE{$2}[0] <= $1
            && $1 <= $HEIGHT_RANGE{$2}[1] },
    hcl => sub {
        return unless /^#[0-9a-f]{6}$/ },
    ecl => sub {
        return unless /^(?:amb|blu|brn|gry|grn|hzl|oth)$/ },
    pid => sub {
        return unless /^[0-9]{9}$/ },
);

my $valid = 0;
local $/ = "";
RECORD:
while (<>) {
    my %record = split /[\s:]+/;
    for my $field (keys %valid) {
        local $_ = $record{$field};
        next RECORD unless defined && $valid{$field}->();
    }
    ++$valid;
}
say $valid;

__DATA__
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007

pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
