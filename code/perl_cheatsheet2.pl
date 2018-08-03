#!/usr/bin/perl -w
#
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://github.com/nickshin/CheatSheets/
#
#
# this file contains some uses of:
# - file IO
# - forking
# - arrays, arrays of arrays, etc.
# - hashes, hashes of arrays, etc.
# - references to functions
#
# and some of my other most used perl snipets, boiler plate, etc.
#
#
# to run:
#     perl perl_cheatsheet2.pl
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


use strict;
use warnings;

# bring in another perl file and using it
require "./perl_cheatsheet1.pl.inc";
use vars qw( @localtime_info $cur_time_full );


# test fileIO folder...
my $testdir = "test_X";


# FILE STUFF {{{
# ----------------------------------------
sub file_io_tests
{
	print "\n*** file_io_tests\n";

	my $param1 = shift;
	if ( ! $param1 ) { $param1 = "nothing"; }

	my $here_document = <<__END_COMMUNICATION__;
This is a here document section.
Also called: here-document, heredoc, hereis, here-string or here-script.

The quote ['], double quote ["], continue marker "\\" or the use of concatenation
operators are not needed for these multi line strings.
 
Note, when printing this "string" (either to stdout or to a file), certain
characters still needs to be escaped.  for example, using the \$ character,
will be considered as variable [$param1].

Take note of how the [%] is escaped below.

__END_COMMUNICATION__

	$here_document =~ s/%/%%/g;		# escape %

	if ( ! -d $testdir )			# check if directory exists
	{ `mkdir -p $testdir`; }

	my $filename = "$testdir/perl_testfile.txt";
	if ( -e $filename )				# check if file exists
	{ unlink $filename; }			# delete file

	# write out a file
	open FH, "> $filename" || die "unable to open $filename: $!";
	printf FH $here_document;
	close FH;

	# append to a file
	open FH, ">> $filename" || die "unable to open $filename: $!";
	printf FH $here_document;
	close FH;

	# read in a file
	open FH, "< $filename" || die "unable to open $filename : $!";
	my @lines_of_text = <FH>;
	close FH;


	# loop labels
	A_LOOP: foreach ( 0 .. 10 ) {
		print "before text: $_\n";
		THE_TEXT: foreach my $line ( @lines_of_text ) {
			print "$line";
			next if ( ! ( $line =~ /^Also/ ) );
			last A_LOOP if ( $_ > 1 );
			print "inside another loop: $_\n\n";
			last;
	}	}

	print "\nsearching for all test_* folders:\n";
	foreach( "A" .. "Z" ) {
		my $dir = "test_$_";
		if ( -d $dir )
		{ print "\t$dir found\n"; }
	}

	# file globbing
	print "\nglobbing all files...\n";
	my @files = glob "*";
	if ( @files ) {
		print "files found:\n";
		foreach my $file ( @files ) {
			print "\t$file\n";
	}	}
}


# FILE STUFF }}}
# FORK {{{
# ----------------------------------------
sub fork_tests
{
	print "\n*** fork_tests\n";

	my @wget_children = ();

	# parallel gets
	my $pid = fork(); if ( $pid != 0 ) { push(@wget_children, $pid); } else {
		wget_simple( "'http://www.google.com/'",	"$testdir/wget_test_google.html" );
	exit(0);} $pid = fork(); if ( $pid != 0 ) { push(@wget_children, $pid); } else {
		wget_simple( "'http://www.ipchicken.com/'",	"$testdir/wget_test_ipchicken.html" );
	exit(0);} $pid = fork(); if ( $pid != 0 ) { push(@wget_children, $pid); } else {
		wget_simple( "'http://www.dyndns.com/'",	"$testdir/wget_test_dyndns.html" );
	exit(0);}

	foreach (@wget_children) { waitpid($_, 0); }

	print "fork tests done\n";
}


# FORK }}}
# ARRAYS {{{
# ----------------------------------------
# push()	- adds an element to the end of an array.
# unshift()	- adds an element to the beginning of an array.
# pop()		- removes the last element of an array.
# shift()	- removes the first element of an array.
# delete $array[index]	- removes an element by index number

sub function_parameters
{
	my $param1 = shift;
	my ( $param2, @params ) = @_;

	print "function_parameters are:\n";
	print "param1 is: $param1\n";		# a
	print "param2 is: $param2\n";		# b
	print "params are:\n";
	foreach( @params )					# c d e f
	{ print "\t$_\n"; }
	print "\n";
}

sub array_reference_example
{
	$_[0] = "hh";						# this stomps on $item1 (i.e. $param1) even though not passed as reference

	my ( $item1, $item2, $an_array ) = @_;

	push @{$an_array}, $item1;
#	$$item1 = "ii";						# illegal with strict
	$$item2 = "zz";
}

sub array_tests
{
	print "\n*** array_tests\n";

	my @params = ( "a" .. "f" );
	function_parameters( @params );

	print "array_reference_example: ";
	my $param1 = "gg";
	my $param2 = "xx";
	array_reference_example( $param1, \$param2, \@params );
	foreach ( @params )
	{ print "$_ "; }
	print "\n\tparam1: $param1\tparam2: $param2\n\n";

	# the different ways of assigning to/from arrays
	my ( $year, $month, $day ) = split( /-/, $cur_time_full );		# string to array
	my @fake_timestamp = ( $year, $month, $day );
	my $localtime_smashed = join " ", @fake_timestamp;				# array to string
	print "assigning arrays results: $localtime_smashed\n\n";


	# arrays of arrays
	my @snp500	= ( "^GSPC",	"SP500",	"\$SPX",	"S&P 500" );
	my @nyse	= ( "^NYA",		"NYA",		"\$NYA",	"NYSE Composite Index" );
	my @array_of_arrays =
	(	# yahoo		bigcharts	stockcharts	fullname
		# dow
		[ "^DJI",	"DJIA",		"\$INDU",	"Dow Jones Industrial Average" ],
		# nyse
		[ @nyse ],
		# nasdaq
		[ "^IXIC",	"NASDAQ",	"\$COMPQ",	"NASDAQ Composite" ],
	);
	print "arrays_of_arrays are:\n";
	foreach ( @array_of_arrays ) {
		my ( $yahoo_sym, $mwatch_sym, $schart_sym, $fullname ) = @$_;
		print "bigchart $mwatch_sym symbol is for $fullname\n";
	}

	# replace an array element with an array
	@{ $array_of_arrays[1] } = @snp500;

	# push an array to an array
	push @{ $array_of_arrays[@array_of_arrays] }, @nyse;

	print "\narrays_of_arrays again are:\n";
	foreach ( @array_of_arrays ) {
		my ( $yahoo_sym, $mwatch_sym, $schart_sym, $fullname ) = @$_;
		print "bigchart $mwatch_sym symbol is for $fullname\n";
	}


	# slice n splice
	print "\nslice n splice:\n";
	my @nums = (1..201);
	my @slicenums = @nums[10..20,50..60,190..200];		# ranged slice
	print "@slicenums\n";

	@nums = ( 0 .. 10 );
	splice(@nums, 2,5,21..25);							# replaces
	print "@nums\n";
}


# ARRAYS }}}
# HASHES {{{
# ----------------------------------------
# subroutine with hash parameter:
#	http://www.troubleshooters.com/codecorn/littperl/perlsub.htm
#	o hash input argument only
#	o hash input/output argument
#	http://www.troubleshooters.com/codecorn/littperl/perlfuncorder.htm
#	o prototyped hash argument
sub hash_reference1_example
{
	print "\nhash_reference_example:\n";

	my %entries = %{$_[0]}; # input argument only
	my $item = "";

	# note $_ is pointing to an array
	# to print that array, note it as: @$_
	while ( ( $item, $_ ) = each( %entries ) )
	{ print "\t$item - @$_\n"; }
}


sub hash_reference2_example
{	# input/output
	${$_[0]}{"XXX"}	= [ "xxxing", "xxx", "Dummy Entry" ];
}

sub hash_tests
{
	print "\n*** hash_tests\n";

	my @an_array = ( "dmcing", "dmc");
	my %hash_of_arrays =
	(	# code		label			short		long description
		"AC"  => [ "alternating",	"alt",		"Alternating Current" ],
		"DC"  => [ "direcct",		"dir",		"Direct Current" ],
		"RUN" => [ "running",		"run",		"Running on Empty" ],
	);

	hash_reference1_example( \%hash_of_arrays );
	hash_reference2_example( \%hash_of_arrays );

	print "\nhash_of_arrays by key:\n";
	foreach my $key ( sort keys %hash_of_arrays ) {
		# array items by array assignment -- the short way
		my ( $labelname, $shortname, $longname ) = @{ $hash_of_arrays{ $key } };
		print "$key\t$labelname\t$shortname\t$longname\n";
		# array items by index -- the long way
		for my $i ( 0 .. $#{ $hash_of_arrays{$key} } ) {
			my @entry = split ' ', $hash_of_arrays{$key}[$i];
			foreach( @entry )
			{ print "\t$_"; }
			print "\n";
	}	}

	# replace
	my $ll = "Devastating Microphone Control";
	$hash_of_arrays{ "DC" } = [ @an_array, $ll ];

	# add new hash, and then push another element to the array at the end...
	# i.e. doing this the long way for an example...
	$hash_of_arrays{ "DMC" } = [ @an_array ];
	push @{ $hash_of_arrays{ "DMC" } }, $ll;

	print "\nhash_of_arrays by key again:\n";
	foreach my $key ( sort keys %hash_of_arrays ) {
		# array items by array assignment -- the short way
		my ( $labelname, $shortname, $longname ) = @{ $hash_of_arrays{ $key } };
		print "$key\t$labelname\t$shortname\t$longname\n";
	}
}


# HASHES }}}
# FUNCTION {{{
# ----------------------------------------
sub funcref_test
{
	print "\n*** function_reference\n";

	my $results = "";
	my $method = \&func_ref1;
	for ( 0 .. 2 ) { $method->( $_, \$results, \$method ); }
	print "results:\n$results\n";

	print "function_reference tests done\n";
}

sub func_ref1
{
	$_ = shift;
	my ( $results, $method ) = @_;

	$$results .= "$_: func_ref1\n";
	print "\t$_ - in func_ref1()\n";
	$$method = \&func_ref2;
}

sub func_ref2
{
	$_ = shift;
	my ( $results, $method ) = @_;

	$$results .= "$_: func_ref2\n";
	print "\t$_ - in func_ref2()\n";
	$$method = \&func_ref1;
}


# FUNCTION }}}
# HOUSEKEEPING {{{
# ----------------------------------------
sub usage
{
	print "USAGE:\n";
	print "\n";
	print "  $0 commands\n";
	print "\n";
	print "where commands are:\n";
	print "\n";
	print "  all       - run all test functions\n";
	print "              o this is equivalent to:\n";
	print "                $0 file fork array hash func\n";
	print "\n";
	print "  file      - file IO tests\n";
	print "\n";
	print "  fork      - fork tests\n";
	print "\n";
	print "  array     - array tests\n";
	print "\n";
	print "  hash      - hash tests\n";
	print "\n";
	print "  func      - function reference tests\n";
	print "\n";
	print "  test      - run test code\n";
	print "\n";
}


# HOUSEKEEPING }}}
# MAIN {{{
# ----------------------------------------
if ( $#ARGV < 0 ) {
	usage();
	exit;
}

# jic
if ( ! -d $testdir )			# check if directory exists
{ `mkdir -p $testdir`; }

foreach( @ARGV ) {
	if ( /all/i ) {
		file_io_tests();
		fork_tests();
		array_tests();
		hash_tests();
		funcref_test();
	}

	elsif ( /file/i ) {
		file_io_tests();
	}

	elsif ( /fork/i ) {
		fork_tests();
	}

	elsif ( /array/i ) {
		array_tests();
	}

	elsif ( /hash/i ) {
		hash_tests();
	}

	elsif ( /func/i ) {
		funcref_test();
	}

	elsif ( /test/i ) {
		print "this is a test\n";
	}

	# unknown
	else {
		usage();
		print "*** Unknown Option: [ $_ ]\n\n";
	}
}


# MAIN }}}
# ----------------------------------------
# ----------------------------------------

