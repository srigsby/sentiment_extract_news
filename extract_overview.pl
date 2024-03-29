#!/usr/bin/perl
use strict;
use Try::Tiny;
use POSIX;

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
print "Sum of \(\% sentences containing positive sentiments minus \%   sentences containing negative setiment\) for each article concerning corresponding tech company." . "<br><br>";
print "<table style=\"width:100%\">";
my $roundscore;
foreach my $str (sort keys %count) {
  print "<tr>";
  $roundscore = floor($count{$str}*100)/100;
  print "<td>$str</td> <td>$roundscore</td>" . "</tr>";
}
print "</table>";
my $numArticles = scalar @sentiments;
print "<br><br>This overview was generated using $numArticles articles.";
print ' With sources that can be found <a href="https://github.com/srigsby/srigsby.github.io/blob/master/link_sources">here</a>.';
print ' Looking for and analizing references to <a href="https://github.com/srigsby/srigsby.github.io/blob/master/tech_companies">these companies</a>.';
print ' Codebase <a href="https://github.com/srigsby/srigsby.github.io">here</a>.';

my $datestring;
$datestring = gmtime();
print " <br><br> Last run: $datestring GMT\n";
# print join("\n", @sentiments);