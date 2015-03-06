#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Data::Debug;
use File::Slurp;
use Getopt::Long;

use v5.20.0;

my $data = "$FindBin::Bin/../data";

my $size = "small";
GetOptions ("size=s" => \$size);

my @lines = read_file( "$data/round-1-problem-A-$size.in", chomp => 1 );

my ($L,$D,$N) = split(/ /, shift @lines);
my @words = @lines[0 .. $D-1];
my @patterns = @lines[$D .. $D+$N-1];

open (my $out, ">", "$data/round-1-problem-A-$size.jnl.out");
foreach my $pattern (@patterns) {
    $pattern =~ s/\(/[/g;
    $pattern =~ s/\)/]/g;
    state $line++;
    my $found = 0;
    foreach my $word (@words) {
        if ($word =~ qr/$pattern/) {
            $found++;
        }
    }
    say $out "Case #$line: $found";
}

