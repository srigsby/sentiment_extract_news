#!/usr/bin/perl
use warnings;
use WWW::Mechanize;
#my $dir = '/home/rigsby/srigsby.github.io/sources';
#foreach my $file (glob("$dir/.*+")) {
#        print "$file";
#}

opendir(DIR, ".") or die "can't open dir";
my @docs = grep(/.{20,}/,readdir(DIR));
foreach $file (@docs) {
    print "$file\n";
    open THEA, "$file" or die $!;
    my @lines = <THEA>;
    print @lines;
}
