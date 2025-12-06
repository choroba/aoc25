#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum product };

my @nums;
while (<>) {
    push @nums, [split ' '];
}
my @ops = @{ pop @nums };

my %DISPATCH = ('+' => \&sum,
                '*' => \&product);

my $sum = 0;
for my $i (0 .. $#ops) {
    $sum += $DISPATCH{ $ops[$i] }(map $_->[$i], @nums);
}

say $sum;

__DATA__
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +
