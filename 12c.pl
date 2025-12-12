#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };
use experimental qw( signatures );

use ARGV::OrDATA;
use List::Util qw{ sum };
use Memoize;

sub flip_rotate($shape) {
    my %uniq;
    for (1, 2) {
        for (1 .. 4) {
            undef $uniq{$shape};
            # Rotate.
            $shape = join "", map substr($shape, $_, 1),
                              6, 3, 0, 7, 4, 1, 8, 5, 2;
        }
        # Flip.
        $shape = join "", map substr($shape, $_, 1),
                          2, 1, 0, 5, 4, 3, 8, 7, 6;
    }
    return keys %uniq
}

my @shapes;
my %pattern;

{   no warnings 'recursion';
    memoize('fill');
    sub fill($xyregion, $requirements) {
        undef $pattern{$xyregion}, return 1 if $requirements =~ /^(?:0 ?)+$/;

        my @req = split / /, $requirements;
        my ($w, $h, $region) = split / /, $xyregion;
        my $shape_i = (grep 0 != $req[$_], 0 .. $#req)[0];

        for my $shape (@{ $shapes[$shape_i] }) {
            for my $x (0 .. $w - 3) {
              POS:
                for my $y (0 .. $h - 3) {
                    my $region2 = $region;
                    for my $i (0 .. 8) {
                        next if '.' eq substr $shape, $i, 1;

                        my $sx = $i % 3;
                        my $sy = int($i / 3);
                        my $ir = ($y + $sy) * $w + $x + $sx;
                        next POS if '.' ne substr $region, $ir, 1;

                        substr $region2, $ir, 1, $shape_i;
                    }
                    my @req2 = @req;
                    --$req2[$shape_i];
                    my $recurse = fill("$w $h $region2", "@req2");
                    next POS if 1 == $recurse;
                }
            }
        }
        return 0
    }
}

while (<>) {
    chomp;
    if (/^[0-9]+:$/) {
        push @shapes, "";
    } elsif (/^([0-9]+)x([0-9]+): ([0-9 ]+)$/) {

        my ($w, $h, $r) = @{^CAPTURE};
        my $space = $w * $h;
        my @r = split / /, $r;
        my $need = sum(map $r[$_] * $shapes[$_][0] =~ tr/#//, 0 .. $#r);
        next if $space - $need < 0;

        fill("$1 $2 " . '.' x ($1 * $2), "$3");

    } elsif (/[#.]/) {
        $shapes[-1] .= $_;
    } else {
        $shapes[-1] = [flip_rotate($shapes[-1])];
    }
}

say 'Coloured: ', scalar keys %pattern;
my %no_colour;
undef $no_colour{ tr/012345/#####/r } for keys %pattern;
say 'No colour: ', scalar keys %no_colour;

__DATA__
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

8x6: 1 1 1 1 1 1
