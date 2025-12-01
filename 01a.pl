#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $dial = 50;
my $zeros = 0;

while (<>) {
    die "Invalid $_" unless /^([LR])([0-9]+)/;

    if ('L' eq $1) {
        $dial -= $2;
    } else {
        $dial += $2;
    }
    $dial %= 100;
    ++$zeros if 0 == $dial;
}

say $zeros;

__DATA__
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
