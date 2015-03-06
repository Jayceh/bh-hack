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

my @lines = read_file( "$data/round-2-problem-A-$size.in", chomp => 1 );

my $num_cases = shift @lines;

open (my $out, ">", "$data/out/round-2-problem-A-$size.jnl.out");

my %memoizer;

foreach my $line (@lines) {
    @bases = split(/ /, $line);
}

