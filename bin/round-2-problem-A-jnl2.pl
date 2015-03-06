#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Data::Debug;
use File::Slurp;
use Getopt::Long;
use List::MoreUtils qw(natatime);
use Math::Base::Convert qw( :all );
use List::Util qw( sum all );
use Memoize;
use Math::NumSeq::HappyNumbers;

use v5.20.0;

my $data = "$FindBin::Bin/../data";

#memoize('factor');

my $size = "small";
my $starting_run = 1;
GetOptions ("size=s" => \$size,
            "run=i"  => \$starting_run);

my @lines = read_file( "$data/round-2-problem-A-$size.in", chomp => 1 );

my $num_cases = shift @lines;

open (my $out, ">", "$data/out/round-2-problem-A-$size.jayce.out");

my @solvers = map { Math::NumSeq::HappyNumbers->new(radix => $_) } (0..10);

my %memoizer;
my $row = 0;
foreach my $line (@lines) {
  my @bases = split(/\s/, $line);
  $row++;
  next if $row < $starting_run;
  #say join '-', @bases;
    my $solved = 0;
    my $i = 1;
    while( $solved != 1 ){
      $i++;
      if (all { $memoizer{ $_ }->{ $i } //= $solvers[ $_ ]->pred( $i ) } @bases) {
        say "Case #$row: $i";
        say $out "Case #$row: $i";
        $solved = 1;
      }
    }

}

sub factor {
  my $digit = shift;
  my $ret = sum map { $_ * $_ } map{ split('') } ($digit);
  if($ret > 4){
    $ret = factor($ret);
  }
  return $ret;
}
