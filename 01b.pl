#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $dial = 50;
my $zeros = 0;

my $was_zero;
while (<>) {
    die "Invalid $_" unless /^([LR])([0-9]+)/;

    if ('L' eq $1) {
        $dial -= $2;
    } else {
        $dial += $2;
    }
    if ($dial > 99) {
        $zeros += int($dial / 100);
    } elsif ($dial < 1) {
        $zeros += int((100 - $dial) / 100);
        --$zeros if $was_zero;
    }
    $dial %= 100;
    $was_zero = $dial == 0;
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
