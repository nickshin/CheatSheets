#!/usr/bin/perl -w
#
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://www.nickshin.com/CheatSheets/
#
# to run:
#     perl 01_encode.pl
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


use strict;
use warnings;

use MIME::Base64 qw(encode_base64);

local($/) = undef; # slurp

my $filename = '90397__ehproductions__money1';

sub generate
{
	my $ext = shift;
	my $type = $ext eq 'mp3' ? 'mpeg' : $ext;

	open FH, "< $filename.$ext" || die "unable to open $filename.$ext : $!";
	my $results = "data:audio/$type;base64," .  encode_base64(<FH>);
	close FH;

	my $fn = $filename . "_$ext.txt";
	open FH, "> $fn" || die "unable to open $fn: $!";
	printf FH $results;
	close FH;
}


generate( 'mp3' );
generate( 'ogg' );
generate( 'wav' );


# note to self: generate HTML version with:
# source-highlight --tab=4 --src-lang=pm -i 01_encode.pl -o 01_encode_pl.html

