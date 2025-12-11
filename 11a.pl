#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %g;
while (<>) {
    chomp;
    my ($from, @to) = split /:? /;
    @{ $g{$from} }{@to} = ();
}

my %agenda = (svr => 1);
my %seen;
while (keys %agenda) {
    my %next;
    for my $from (keys %agenda) {
        $seen{$from} += $agenda{$from};
        $next{$_} += $seen{$from} for keys %{ $g{$from} };
    }
    %agenda = %next;
}
say $seen{out};

__DATA__
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
