#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

say 'strict digraph {';
say 'svr [color=green];';
say 'out [color=red];';
say 'dac [color=cyan, style=filled];';
say 'fft [color=orange, style=filled];';
say 'you [color=green, style=filled];';
while (<>) {
    chomp;
    my ($from, @to) = split /:? /;
    say "$from \-> $_;" for @to;
}
say '}';
