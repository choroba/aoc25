#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;
my ($sy, $sx) = (0, 0);
while (<>) {
    ($sy, $sx) = ($. - 1, pos() - 1) if /S/g;
    push @grid, [split //];
}

my $split_tally = 0;
my %beam = ($sx => undef);
for my $y ($sy .. $#grid - 1) {
    my %next;
    for my $x (keys %beam) {
        if ($grid[ $y + 1 ][$x] eq '.') {
            undef $next{$x};
        } else {
            ++$split_tally;
            undef $next{$_} for $x - 1, $x + 1;
        }
    }
    %beam = %next;
}
say $split_tally;


__DATA__
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
