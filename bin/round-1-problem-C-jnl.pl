#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Data::Debug;
use File::Slurp;
use Getopt::Long;
use List::MoreUtils qw(natatime);

use v5.20.0;

my $data = "$FindBin::Bin/../data";

my $size = "small";
GetOptions ("size=s" => \$size);

my @lines = read_file( "$data/round-1-problem-C-$size.in", chomp => 1 );

my $num_cases = shift @lines;

open (my $out, ">", "$data/out/round-1-problem-C-$size.jnl.out");
my $it = natatime 2, @lines;
while (my ($first, $second) = $it->()) {
    my ($runs, $seats, $groups) = split(/ /, $first);
    my @groups = split(/ /, $second);
    state $case++;
    my $total = 0;
    foreach my $run (1..$runs) {
        my $filled = 0;
        my $seen_groups = 0;
        while ($filled <= $seats && $seen_groups <= $groups - 1) {
            $seen_groups++;
            if ($filled + $groups[0] <= $seats) {
                my $g = shift @groups;
                $filled += $g;
                push(@groups, $g);
            } else {
                last;
            }
        }
        $total += $filled;
    }

    say "Case $case: $total";
    say $out "Case $case: $total";
}

