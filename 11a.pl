#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;
use Memoize;
use List::Util qw{ sum0 };

my %g;
while (<>) {
    chomp;
    my ($from, @to) = split /:? /;
    undef $g{$_}{$from} for @to;
}

memoize('paths');
sub paths($from, $to) {
    return 1 if $from eq $to;
    return sum0(map paths($from, $_), keys  %{ $g{$to} })
}

say paths('you', 'out');

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
