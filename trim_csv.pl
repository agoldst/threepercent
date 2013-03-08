#!/usr/bin/env perl 

# filters STDIN by removing the first and last lines

use strict;
use warnings;

my $prev = <STDIN>;
undef $prev;
while(<STDIN>) {
    print $prev if $prev;
    $prev = $_;
}
