#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my ($y, $x) = (0, 0);
my %tiles;
while (<>) {
    chomp;
    my ($j, $i) = split /,/;
    if (! exists $tiles{y}{$j}) {
        $tiles{y}{$j}{min} = $i;
        $tiles{y}{$j}{max} = $i;
    } else {
        my ($min, $max) = @{ $tiles{y}{$j} }{qw{ min max }};
        $tiles{y}{$j}{min} = $i if $i < $min;
        $tiles{y}{$j}{max} = $i if $i > $max;
    }
    if (! exists $tiles{x}{$i}) {
        $tiles{x}{$i}{min} = $j;
        $tiles{x}{$i}{max} = $j;
    } else {
        my ($min, $max) = @{ $tiles{x}{$i} }{qw{ min max }};
        $tiles{x}{$i}{min} = $j if $j < $min;
        $tiles{x}{$i}{max} = $j if $j > $max;
    }
    $y = $j if $j > $y;
    $x = $i if $i > $x;
}

my $max = 0;
for my $y0 (0 .. $y) {
    next unless exists $tiles{y}{$y0};

    for my $y1 ($y0 .. $y) {
        next unless exists $tiles{y}{$y1};

        for my $x0 ($tiles{y}{$y0}{min}, $tiles{y}{$y0}{max}) {
            for my $x1 ($tiles{y}{$y1}{min}, $tiles{y}{$y1}{max}) {
                my $area = ($y1 - $y0 + 1) * ($x1 - $x0 + 1);
                $max = $area if $max < $area;
            }
        }
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
