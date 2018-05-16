#!/usr/bin/perl -w
#
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://www.nickshin.com/CheatSheets/
#
#
# part 1 of 3 - writting perl modules
# - a perl module
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


use strict;
use warnings;

# ----------------------------------------

package perl_cheatsheet3;

# ----------------------------------------

BEGIN
{	# this is run after perl script is loaded and during compilation.
	# more than one BEGIN block is allowed and is run FIFO.

	# Exporter allows a package to push (export) its names up
	# into the caller's namespace in a controlled fashion.
	require Exporter;
	
	# Scripts could become a problem as (compiled) programs scale up into the
	# 10K-100K line range.  [ Autoloader ] is best used by modules that define
	# a large number of infrequently used subroutines.
	# i.e. compiles subroutines at run time, on demand.
	#use AutoLoader qw(AUTOLOAD);
	
	
	# The following controls method inheritance in Perl modules.
	# If a method isn't found in the current package, then Perl searches for
	# it in the packages named in the @ISA array. (recursively, depth first).
	our @ISA = qw(Exporter);
	
	# Names listed in the @EXPORT array are unconditionally exported to the caller's namespace.
	our @EXPORT = qw( module_1a module_1b );
	
	# Names listed in the @EXPORT_OK array are exported only if the caller
	# explicitly asks for them by listing them in the [ use ] statement.
	our @EXPORT_OK = qw( $test_variable );
}

# ----------------------------------------


our $test_variable = "initial string";


sub module_1x	# this will not be exported outside of this module!!!
{
	print "    inside module_1x $_[0]\n";
}

sub module_1a
{
	print "inside module_1a $_[0]\n";
	module_1x("[from module_1a: $test_variable]");
}

sub module_1b
{
	print "inside module_1b $_[0]\n";
	module_1x("[from module_1b: $test_variable]");
}

# ----------------------------------------

# CHECK
# this is run after perl script is compiled.
# more than one CHECK block is allowed and is run LIFO.
CHECK
{
	print "CHECK test_variable after [ $test_variable ]\n";
}
CHECK
{
	print "CHECK test_variable before [ $test_variable ]\n";
	$test_variable = "initialized during CHECK";
}


# INIT
# this is run right after CHECK and right before run time
# more than one INIT block is allowed and is run FIFO.
INIT
{
	print "INIT test_variable before [ $test_variable ]\n";
	$test_variable = "initialized during INIT";
}
INIT
{
	print "INIT test_variable after [ $test_variable ]\n";
}


# inside a MODULE all of this is still considered "compile" time
$test_variable = "compile time string";
print "COMPILE TIME: [ $test_variable ]\n";


# END
# this is run right before perl interpreter exits.
# more than one EXIT block is allowed and is run LIFO.
# useful for things like saving/logging things to a file
# or final "clean up" steps.
END
{
	print "good bye from [ An_Example_Module ]\n";
}

# ----------------------------------------

1; # return from package

