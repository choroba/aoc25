#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use Set::IntSpan;  # S:IS::Fast can't be used, ids are "out of range".

my $set = 'Set::IntSpan'->new;
while (<>) {
    chomp;
    if (/-/) {
        $set->U($_);
    } elsif ("" eq $_) {
        last
    }
}
say $set->cardinality;

__DATA__
3-5
10-14
16-20
12-18
