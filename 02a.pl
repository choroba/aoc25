#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $count = 0;
for my $range (split /,/, <>) {
    my ($from, $to) = split /-/, $range;
    for my $n ($from .. $to) {
        $count += $n if $n =~ /^(.+)\1$/;
    }
}

say $count;

__DATA__
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
