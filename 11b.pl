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

say paths('svr', 'fft') * paths('fft', 'dac') * paths('dac', 'out')
    || paths('svr', 'dac') * paths('dac', 'fft') * paths('fft', 'out');

__DATA__
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
