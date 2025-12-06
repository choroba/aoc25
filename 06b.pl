#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum product };

my @lines;
while (<>) {
    chomp;
    push @lines, $_;
}
my @ops = split ' ', pop @lines;

my %DISPATCH = ('+' => \&sum,
                '*' => \&product);

my $sum = 0;
my @numbers;
for my $i (0 .. length($lines[0])) {
    my $n = join "", map substr($_, $i, 1), @lines;
    if ($n !~ /[0-9]/) {
        $sum += $DISPATCH{ shift @ops }(@numbers);
        @numbers = ();
    } else {
        push @numbers, $n;
    }
}

say $sum;

__DATA__
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +
