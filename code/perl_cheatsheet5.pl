#!/usr/bin/perl -w
#
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://www.nickshin.com/CheatSheets/
#
#
# part 3 of 3 - writting perl modules
# - testing the perl module
# - import module with [ use ]
#
#
# to run:
#     perl perl_cheatsheet5.pl
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


use strict;
use warnings;

# note: must call out what to import when using [ use ]
use perl_cheatsheet3 qw( module_1a module_1b $test_variable );


print "\nPERL CHEATSHEET 5\n";
module_1a( "main" );
$test_variable = "string set in main";
module_1b( "main" );

