#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant SIZE => 12;

my $joltage = 0;

while (<>) {
    chomp;
    my @batteries = split //;
    my @max_indices = (0);
    for my $i (1 .. SIZE) {
        for my $idx ($max_indices[-1] .. $#batteries - SIZE + $i) {
            $max_indices[-1] = $idx
                if $batteries[ $max_indices[-1] ] < $batteries[$idx];
        }
        push @max_indices, $max_indices[-1] + 1;
    }
    pop @max_indices;
    $joltage += join "", @batteries[@max_indices];
}

say $joltage;

__DATA__
987654321111111
811111111111119
234234234234278
818181911112111
