#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: find-missing.pl
#
#        USAGE: ./find-missing.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Andrew Goldstone (agoldst), andrew.goldstone@gmail.com
# ORGANIZATION: Rutgers University, New Brunswick
#      VERSION: 1.0
#      CREATED: 03/17/2013 10:27:57
#     REVISION: ---
#===============================================================================
use v5.14;                                  # entails strict, unicode_strings 
use autodie;
use utf8;                                   # source code itself is in utf-8
use warnings;
use warnings FATAL => "utf8";               # Unicode encode errors are fatal
use open qw( :std :utf8 );                  # default utf8 layer

my $threep_file = "threepct_countries.txt";
# my $unesco_file = "unesco-book/unesco_countries.txt";
my $who_file = "who-pop/who-countries.csv";


my %threep = hash_read($threep_file);
my %who = hash_read($who_file);

say 'In 3%, missing from WHO:';
compare_hash(\%threep,\%who);

say '-----------------';

#say 'In WHO, missing from 3%';
#compare_hash(\%who,\%threep);

sub hash_read {
    my $filename = shift;
    open my $fh,$filename or die;
    my %result = ();
    while(<$fh>) {
        chomp;
        $result{$_} = 1; 
    }
    close $fh or die;
    return %result; 
}

sub compare_hash {
    my ($a,$b) = @_;

    my $count = 0;
    foreach(keys %$a) {
        unless ($b->{$_}) {
            say $_;
            ++$count;
        }
    }
    say "TOTAL: $count missing";
}
