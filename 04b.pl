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

my $count_removed = 0;
my $was_removed = 1;
while ($was_removed) {
    undef $was_removed;

    my @to_remove;
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
            if ($neighbours < 4) {
                $was_removed = 1;
                ++$count_removed;
                push @to_remove, [$y, $x];
            }
        }
    }
    for my $yx (@to_remove) {
        $grid[ $yx->[0] ][ $yx->[1] ] = '.';
    }
}

say $count_removed;

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
