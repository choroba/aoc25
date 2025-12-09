#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @coord;
while (<>) {
    chomp;
    my ($x, $y) = split /,/;
    push @coord, [$y, $x];
}

my $max = 0;
for my $c0 (@coord) {
    my ($y0, $x0) = @$c0;
  OUTER:
    for my $c1 (@coord) {
        next if $c0 == $c1;

        my ($y1, $x1) = @$c1;
        next if ($y0 <=> 48701) != ($y1 <=> 48701);

        for my $in (@coord) {
            next if $in->[0] == $y0 && $in->[1] == $x0
                 || $in->[0] == $y1 && $in->[1] == $x1;

            if ($in->[0] == (sort { $a <=> $b } $y0, $y1, $in->[0])[1]
                && $in->[1] == (sort { $a <=> $b } $x0, $x1, $in->[1])[1]
            ) {
                next OUTER
                    unless $in->[0] == $y0 || $in->[0] == $y1
                        || $in->[1] == $x0 || $in->[1] == $x1;
            }
        }
        my $area = (1 + abs($y1 - $y0)) * (1 + abs($x1 - $x0));
        $max = $area if $area > $max;
    }
}

say $max;

__DATA__
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
