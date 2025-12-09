#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use GD;
use List::Util qw{ max };

use constant SCALE => 0.05;

my @coord;
my %point;
while (<>) {
    chomp;
    my ($x, $y) = split /,/;
    push @coord, [$y, $x];
    undef $point{y}{$y};
    undef $point{x}{$x};
}
my $Ym = max(map $_->[0], @coord);
my $Xm = max(map $_->[1], @coord);

my $i = 0;
for my $y (keys %{ $point{y} }) {
    $point{Y}{$i} = $y;
    $point{y}{$y} = $i++;

}
$i = 0;
for my $x (keys %{ $point{x} }) {
    $point{X}{$i} = $x;
    $point{x}{$x} = $i++;
}

for my $c (@coord) {
    $c->[0] = $point{y}{ $c->[0] };
    $c->[1] = $point{x}{ $c->[1] };
}

my $ym = max(map $_->[0], @coord);
my $xm = max(map $_->[1], @coord);

my $img    = 'GD::Image'->new(100 + SCALE * $Xm, 100 + SCALE * $Ym);
my $black  = $img->colorAllocate(0, 0, 0);
my $red    = $img->colorAllocate(255, 0, 0);
my $green  = $img->colorAllocate(0, 255, 0);
my $yellow = $img->colorAllocate(255, 255, 0);

my $last = $coord[-1];
for my $c (@coord) {
    $img->line(map(SCALE * $_, $point{X}{ $last->[1] }, $point{Y}{ $last->[0] },
                            $point{X}{ $c->[1] }, $point{Y}{ $c->[0] }),
               $green);
    $img->setPixel(SCALE * $point{X}{ $last->[1] },
                   SCALE * $point{Y}{ $last->[0] },
                   $red);
    $img->setPixel(SCALE * $point{X}{ $c->[1] }, SCALE * $point{Y}{ $c->[0] },
                   $red);
    $img->string(gdTinyFont,
                 SCALE * $point{X}{ $c->[1] }, SCALE * $point{Y}{ $c->[0] },
                 join(',', $point{X}{ $c->[1] }, $point{Y}{ $c->[0] }),
                 $yellow);
    $last = $c;
}
$img->rectangle(map(SCALE * $_, 5755, 67570, 94539, 50089), $yellow);
open my $png, '>', '09b.png' or die $!;
print {$png} $img->png;
close $png;

# 1552139370: 5755, 67570, 94539, 50089

__DATA__
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
