#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;
while (<>) {
    chomp;
    push @grid, [split //];
}

my $accessible = 0;
for my $y (0 .. $#grid) {
    for my $x (0 .. $#{ $grid[$y] }) {
        next if '.' eq $grid[$y][$x];

        my $neighbours = 0;
        for my $j ($y - 1 .. $y + 1) {
            next if $j < 0 || $j > $#grid;

            for my $i ($x - 1 .. $x + 1) {
                next if $i < 0 || $i > $#{ $grid[$j] };
                next if $i == $x && $j == $y;

                ++$neighbours if '@' eq $grid[$j][$i];
            }
        }
        ++$accessible if $neighbours < 4;
    }
}

say $accessible;

__DATA__
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
