#!/usr/bin/perl -w
#
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://github.com/nickshin/CheatSheets/
#
#
# part 2 of 3 - writting perl modules
# - testing the perl module
# - using fully qualified names
#
#
# to run:
#     perl perl_cheatsheet4.pl
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


use strict;
use warnings;

require perl_cheatsheet3;
# the following is not automatically exported
# and compiler will complain if missing
use perl_cheatsheet3 qw( $test_variable );


print "\nPERL CHEATSHEET 4\n";
perl_cheatsheet3::module_1a( "main" );
$perl_cheatsheet3::test_variable = "string set in main";
perl_cheatsheet3::module_1b( "main" );

