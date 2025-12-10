#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ max };


my $press_tally = 0;
while (<>) {
    my @machine;
    my @parts = split;
    for my $part (@parts) {
        if ($part =~ s/[()]//g) {
            push @machine, [split /,/, $part];
        } elsif ($part =~ s/[{}]//g) {
            unshift @machine, [split /,/, $part];
        }
    }

    my $input = join "\n",
                map "(declare-const b$_ Int)\n(assert (>= b$_ 0))",
                map $_ - 1,
                1 .. $#machine;
    $input .= "\n(minimize (+ "
            . join(' ', map "b$_", map $_ - 1, 1 .. $#machine)
            . '))';

    for my $i (0 .. $#{ $machine[0] }) {
        my $j = $machine[0][$i];
        my @indices = map $_ - 1,
                      grep { grep $i == $_, @{ $machine[$_] } }
                      1 .. $#machine;
        $input .= "\n(assert (= (+ "
                . (join ' ', map "b$_", @indices) . ") $j))";
    }
    $input .= "\n(check-sat)\n(get-model)\n";
    open my $out, '>', "$$.i" or die $!;
    print {$out} $input;
    close $out;
    my $z3 = qx{ z3 $$.i };
    unlink "$$.i";
    $press_tally += $1 while $z3 =~ /^\s+([0-9]+)\)$/mg;
}

say $press_tally;

__DATA__
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
