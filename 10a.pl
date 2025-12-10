#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @machines;
while (<>) {
    my @parts = split;
    for my $part (@parts) {
        if ($part =~ s/[\[\]]//g) {
            push @machines, [$part];
        } elsif ($part =~ s/[()]//g) {
            push @{ $machines[-1] }, [split /,/, $part];
        }
    }
}

my $press_tally = 0;
for my $machine (@machines) {
    my %agenda = ($machine->[0] =~ s/#/./gr => undef);
    my %seen;
    while (! exists $seen{ $machine->[0] }) {
        my %next;
        for my $lights (keys %agenda) {
            undef $seen{$lights};
            for my $buttons (@$machine[1 .. $#$machine]) {
                my $l = $lights;
                for my $pos (@$buttons) {
                    substr($l, $pos, 1) =~ tr/.#/#./;
                }
                undef $next{$l} unless exists $seen{$l};
            }
        }
        %agenda = %next;
        ++$press_tally;
    }
}

say $press_tally - @machines;

__DATA__
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
