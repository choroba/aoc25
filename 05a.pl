#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @ranges;
my @ingredients;
my $fresh_tally = 0;
while (<>) {
    chomp;
    if (/(.+)-(.+)/) {
        push @ranges, [$1, $2];
    } elsif ("" ne $_) {
        my $id = $_;
        for my $range (@ranges) {
            ++$fresh_tally, last
                if $range->[0] <= $id && $id <= $range->[1];
        }
    }
}
say $fresh_tally;

__DATA__
3-5
10-14
16-20
12-18

1
5
8
11
17
32
