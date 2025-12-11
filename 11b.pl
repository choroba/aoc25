#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;

sub paths($g, $start, $end) {
    my %in;  # Only represent the reachable part of the graph.
    my %walk = ($start => undef);
    while (keys %walk) {
        my %next;
        for my $f (keys %walk) {
            for my $t (keys %{ $g->{$f} }) {
                undef $next{$t};
                undef $in{$t}{$f};
            }
        }
        %walk = %next;
    }

    my %agenda = ($start => 1);
    my %seen;
    while (keys %agenda) {
        my %next;
        my %delete;
        for my $from (keys %agenda) {
            if (keys %{ $in{$from} }) {
                $next{$from} += $agenda{$from};
                next
            }

            $seen{$from} += $agenda{$from};
            for my $to (keys %{ $g->{$from} }) {
                $next{$to} += $seen{$from};
                undef $delete{$to}{$from};
            }
            if ($end eq $from) {
                %agenda = %next = ();
                last
            }
        }
        for my $dt (keys %delete) {
            for my $df (keys %{ $delete{$dt} }) {
                delete $in{$dt}{$df};
            } 
        }
        %agenda = %next;
    }
    return $seen{$end} // 0
}

my %g;
while (<>) {
    chomp;
    my ($from, @to) = split /:? /;
    @{ $g{$from} }{@to} = ();
}

say paths(\%g, 'svr', 'fft')
    * paths(\%g, 'fft', 'dac')
    * paths(\%g, 'dac', 'out')
    ||
    paths(\%g, 'svr', 'dac')
    * paths(\%g, 'dac', 'fft')
    * paths(\%g, 'fft', 'out');

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
