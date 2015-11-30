#!/usr/bin/perl
use strict;
# use warnings;
use WWW::Mechanize;
use Try::Tiny;
use HTML::Parser;

my @sources;
open(my $fh, "<link_sources")
    or die "Failed to open file: $!\n";
while(<$fh>) { 
    chomp; 
    push @sources, $_;
} 
close $fh;
# print join " ", @sources;

my @tech;
open(my $fh2, "<tech_companies")
  or die "nope";
while(<$fh2>) {
  chomp;
  push @tech, $_;
}
close $fh2;

my $mech = WWW::Mechanize->new();
# slink: links from source sites 
foreach my $slink (@sources) {
  $mech->get($slink);
  my @slinks = $mech->links();
  foreach my $link1 (@slinks){
    my $linkTXT = $link1->text;
    if(length($linkTXT)>17 && length($linkTXT)<200) {
      foreach my $company (@tech) {
        if(index(lc($link1->text), lc($company))!=-1) {
          my $min = 1111111;
          my $max = 9999999;
          my $rndind = $min + int(rand($max - $min));
          my $endName;
          ($endName = lc($company)) =~ s/\s+//g;
          my $file = "$endName" . "$rndind";
          unless(open FILE, '>'. 'articles/' ."$file") {
            die "\nUnable to create $file\n";}
          try{
            $mech->get($link1->url_abs);
            print FILE $mech->content();
            } catch {print "$file get failed"};
          #printf "%s, %s\n", $company, $link1->url_abs();
          close FILE;
        }
      }
    }
    # printf "%s, %s\n", $link1->text, $link1->url;
  }

#$mech->follow_link( n => 3);
}

# # opendir(DIR, ".") or die "can't open dir";
# # my @docs = grep(/.{20,}/,readdir(DIR));
# foreach $link (@sources) {
#   print $link;
# }