#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my @boxes;
while (<>) {
    chomp;
    push @boxes, [split /,/];
}

my %by_distance;
for my $i (0 .. $#boxes - 1) {
    for my $j ($i + 1 .. $#boxes) {
        my $distance = sqrt sum(map +($boxes[$i][$_] - $boxes[$j][$_]) ** 2,
                                0 .. 2);
        undef $by_distance{$distance}{"$i $j"};
    }
}

my %connected;
my %circuit;
my $step;
my @last;

LOOP:
for my $d (sort { $a <=> $b } keys %by_distance) {
    for my $pair (keys %{ $by_distance{$d} }) {
        my ($i, $j) = split ' ', $pair;
        my $are_connected = 2 * exists($connected{$i}) + exists $connected{$j};
        if (! $are_connected) {
            $connected{$i} = $connected{$j} = $i;
            undef $circuit{$i}{$j};
            undef $circuit{$i}{$i};
            delete $circuit{$j};
            @last = ($i, $j);

        } elsif (1 == $are_connected) {
            $connected{$i} = $connected{$j};
            undef $circuit{ $connected{$i} }{$i};
            @last = ($i, $j);
            
        } elsif (2 == $are_connected) {
            $connected{$j} = $connected{$i};
            undef $circuit{ $connected{$j} }{$j};

        } elsif ($connected{$i} != $connected{$j}) {
            my $delete_circuit = $connected{$i};
            @{ $circuit{ $connected{$j} } }{
                keys %{ $circuit{ $delete_circuit } } } = ();
            for my $k (keys %{ $circuit{ $delete_circuit } }) {
                $connected{$k} = $connected{$j};
            }
            delete $circuit{$delete_circuit};
            @last = ($i, $j);
        }
        last LOOP if @boxes == keys %connected && 1 == keys %circuit;
    }
}

say $boxes[ $last[0] ][0] * $boxes[ $last[1] ][0];

__DATA__
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
