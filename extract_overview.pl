#!/usr/bin/perl
use strict;
use Try::Tiny;

my @sentiments;
open(my $FH, "<article_sentiments.txt")
  or die "couldn't open sentiments file\n";
while(<$FH>) {
  chomp;
  push @sentiments, $_;
}
close $FH;

my $company;
my $neut;
my $pos;
my $neg;
my $prctPos;
my $prctNeg;
my %count;
my $prctDiff;
foreach my $line (@sentiments){
  if($line =~ /\{\"([a-z]+)[0-9]+/) {
    $company = $1;
    if($line =~ /Neutral.+?([0-9]+)/) {
      $neut = $1;
    }
    if($line =~ /Positive.+?([0-9]+)/) {
      $pos = $1;
    }
    if($line =~ /Negative.+?([0-9]+)/) {
      $neg = $1;
    }
    if($pos+$neg+$neut!=0) {
      $prctPos = 100*$pos/($pos+$neut+$neg);
      $prctNeg = 100*$neg/($pos+$neut+$neg);
    } else {$prctPos=0; $prctNeg=0;}
    $prctDiff = $prctPos-$prctNeg;
    $count{$company}+=$prctDiff;    
  }
    
}
print "Sum of difference between positive sentiment sentence percentages and negative setiment percentages in articles about corresponding tech company." . "\n\n";
foreach my $str (sort keys %count) {
  printf "%-21s %s\n", $str, $count{$str};
}
my $numArticles = scalar @sentiments;
print "\n\nThis overview was generated using $numArticles articles.";

# print join("\n", @sentiments);