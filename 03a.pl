#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $joltage = 0;

while (<>) {
    chomp;
    my @batteries = split //;
    my $max_idx = 0;
    for my $idx (1 .. $#batteries - 1) {
        $max_idx = $idx if $batteries[$max_idx] < $batteries[$idx];
    }
    my $max2_idx = $max_idx + 1;
    for my $idx2 ($max2_idx .. $#batteries) {
        $max2_idx = $idx2 if $batteries[$max2_idx] < $batteries[$idx2];
    }
    $joltage += $batteries[$max_idx] * 10 + $batteries[$max2_idx];
}

say $joltage;

__DATA__
987654321111111
811111111111119
234234234234278
818181911112111
