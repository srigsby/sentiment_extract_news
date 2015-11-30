#!/usr/bin/perl
use HTML::Parser;
use Try::Tiny;
use HTML::Scrubber;

my @articles;
open(my $fh, "<article_files")
  or die "failed to open file: $!\n";
while(<$fh>) { 
  chomp;
  push @articles, $_;
}
close $fh;

foreach my $article (@articles){
  my $file = "articles/" . $article;
  unless(open FILE, $file) {die "\nUnable to open $file\n";}
  #remove line separator to allow for one read
  undef $/;
  my $contents = <FILE>;
  # print "Read " . length($contents) . "bytes\n";
  my $scrubber = HTML::Scrubber->new(deny=> [ qw[ script] ]);
  my $noscript = $scrubber->scrub($contents);
  my $p = HTML::Parser->new(text_h => [\my @accum, "text"])->parse($noscript);
  $scrubparse = join(' ', map $_->[0], @accum);
  $scrubparse =~ s/\R//g;
  $scrubparse =~ s/\t/ /g;
  $scrubparse =~ s/&nbsp;/ /g;
  $scrubparse =~ s/\s\s+/ /g;
  $scrubparse =~ s/[&#8221|&#8217]/\"/g;
  $scrubparse =~ s/[&#39]/\'/g;
  # perhaps not clean, but at least clean-er
  my $outfile = "articles/" . $article . "_clean.txt";
  unless(open OUTFILE, '>' . "$outfile") {
    die "\nUnable to create $outfile\n";}
  try{
    print OUTFILE $scrubparse;
  } catch {print "$outfile write failed"};
  close OUTFILE;
  close FILE;
}
