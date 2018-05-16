#!/usr/bin/perl -w
#
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Creative Commons Attribution 3.0 License.
#
# this file is from https://www.nickshin.com/CheatSheets/
#
#
# to help reduce user error prone steps when creating .htaccess
# .htpassword and .htdigest
#
# use this script to generate:
#     + .htaccess
#     + .htpassword     + .htdigest
# and reminders for any additional configuration steps to take for either
#     + apache          + lighttpd
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


use strict;
use warnings;

use Cwd;


# CONFIGURE {{{
# ----------------------------------------
# ----------------------------------------
# edit the following to reflect your local settings

my $login = 'mylogin';				# HTTP username (used for .htaccess/.htdigest)
my $baseurl = '/path/to/folder';	# used with lighttpd
my $authtitle = 'authentication box title';

# the following MUST be FULL path -- .htaccess requires this
my $htpath = getcwd();			# -or- NOTE: REPLACE THIS WITH YOUR [ DOCUMENT_ROOT + $baseurl ]

#my $chown = 'chown';			# http://www.cyberciti.biz/faq/howto-linux-add-user-to-group/
 my $chown = 'sudo chown';		# brute force
 my $owner  = $ENV{"LOGNAME"};	# this is used with the chown command above


# ----------------------------------------
# ----------------------------------------
# no need to touch these...

my $webgroup = "";

my $chownsep = '.';
$_ = `uname`;
if ( /Darwin/ ) { $chownsep = ':'; }


# CONFIGURE }}}
# apache {{{
# ----------------------------------------
# ----------------------------------------

sub generate_files_apache
{
	my $filename = '/etc/apache2/httpd.conf'; # debian/ubuntu
	if ( -e $filename )
		{ $webgroup=`egrep ^Group $filename | sed 's/Group[ \\t]*//'`; }

	if ( $webgroup eq '' ) {
		$filename = '/etc/httpd/conf/httpd.conf'; # redhat/centos
		if ( -e $filename )
			{ $webgroup=`egrep ^Group $filename | sed 's/Group[ \\t]*//'`; }
	}

	if ( $webgroup eq '' ) {
		$filename = '/etc/apache2/envvars'; # OSX
		if ( -e $filename )
			{ $webgroup=`egrep APACHE_RUN_GROUP $filename | sed 's/[^=]\\+=//'`; }
	}

	if ( $webgroup eq '' ) { die 'unable to find apache appropriate conf file'; }
	chomp $webgroup;

	# generate .htaccess {{{2
	# ----------------------------------------
	my $lines = <<__EOF_HTACCESS_0__;
# login
# ---------------
AuthType Basic
AuthName "$authtitle"
AuthUserFile $htpath/.htpasswords
Require valid-user
__EOF_HTACCESS_0__

	$filename = "$htpath/.htaccess";
	open FH, "> $filename" || die "*** ERROR: unable to open $filename: $!";
	printf FH $lines;
	close FH;
	`chmod 660 $filename`;
	`$chown $owner$chownsep$webgroup $filename`;


	# generate .htaccess }}}2
	# generate .htpasswords {{{2
	# ----------------------------------------

	print "===== HTPASSWORD =====\n";
	$filename = "$htpath/.htpasswords";
	`htpasswd -c '$filename' $login`;
	exit if ( $? );
	`chmod 660 $filename`;
	`$chown $owner$chownsep$webgroup $filename`;

	# generate .htpasswords }}}2
	# print reminders {{{2
	# ----------------------------------------
	print <<__EOF_REMINDERS_0__;


# REMINDERS:
# Make sure the following is in your apache config file:

	<Directory $htpath>
		...
		AllowOverride All
		...
	</Directory>

__EOF_REMINDERS_0__


	# print reminders }}}2
	# ----------------------------------------
}

# apache }}}
# lighttpd {{{
# ----------------------------------------
# ----------------------------------------

sub generate_files_lighttpd
{
	$webgroup = `grep groupname /etc/lighttpd/lighttpd.conf  | awk '{ print \$3 }' | sed 's/"//g'`;
	chomp $webgroup;

	# generate .htdigest {{{2
	# ----------------------------------------

	print "===== HTDIGEST =====\n";
	my $filename = "$htpath/.htdigest";
	`htdigest -c '$filename' '$authtitle' $login`;
	exit if ( $? );
	`chmod 660 $filename`;
	`$chown $owner$chownsep$webgroup $filename`;


	# generate .htdigest }}}2
	# print reminders {{{2
	# ----------------------------------------
	print <<__EOF_REMINDERS_0__;


# REMINDERS:
# Make sure the following is in your lighttpd config file:
# (or lighttpd/conf-available/05-auth.conf)

	server.modules += ( "mod_auth" )
	auth.backend = "htdigest"
	auth.backend.htdigest.userfile = "$htpath/.htdigest"
	auth.require = (
		"$baseurl" => (
						"method" => "digest",
						"realm" => "$authtitle",
						"require" => "valid-user",
					)
			)

__EOF_REMINDERS_0__


	# print reminders }}}2
	# ----------------------------------------
}

# lighttpd }}}
# ----------------------------------------
# ----------------------------------------
