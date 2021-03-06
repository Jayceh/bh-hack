#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Data::Debug;
use File::Slurp;
use Getopt::Long;
use List::MoreUtils qw(natatime);
use List::Util qw(sum);

use v5.20.0;

my $data = "$FindBin::Bin/../data";

my $size = "small";
my $starting_run = 1;
GetOptions ("size=s" => \$size,
            "run=i"  => \$starting_run);

my @lines = read_file( "$data/round-1-problem-C-$size.in", chomp => 1 );

my $num_cases = shift @lines;

open (my $out, ">", "$data/out/round-1-problem-C-$size.jnl2.out");
my $it = natatime 2, @lines;
while (my ($first, $second) = $it->()) {
    #It's a new day
    my ($runs, $seats, $groups) = split(/ /, $first);
    my @groups = split(/ /, $second);
    state $case++;
    my $total = 0;
    next if $case < $starting_run;

    #find out if the number of people is less than the capacity
    if ($seats >= (my $sum = sum @groups)) { 
        say "shortcut";
        $total = $sum * $runs;
    } else {
        #Load up the coaster
        foreach my $run (1..$runs) {
            my $filled = 0;
            my $seen_groups = 0;

            #Load as many groups on to the coaster as possible
            #Don't let a group on the coaster more than once,
            while ($filled <= $seats && $seen_groups <= $groups - 1) {
                $seen_groups++;

                #Fill up the coaster, but not with more people than it can handle
                if ($filled + $groups[0] <= $seats) {
                    #Treat groups as a circular array by shifting and pushing
                    my $g = shift @groups;
                    $filled += $g;
                    push(@groups, $g);
                } else {
                    last;
                }
            }
            #whee!
            $total += $filled;
        }
    }

    say "Case #$case: $total";
    say $out "Case #$case: $total";
}

