# no shebang #! -- this is an example file when including it to another perl file
#
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://github.com/nickshin/CheatSheets/
#
#
# this file contains some of my most used perl snipets
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


# UTILITIES {{{
# ----------------------------------------
sub sort_and_unique
{
	my $last = 0;
	return grep( ($last eq $_ ? 0 : ($last = $_, 1)), sort @_ );
}


# UTILITIES }}}
# TIME STAMPS {{{
# ----------------------------------------
# my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime(time);
our @localtime_info		= localtime(time);

our $todays_timestamp	= `date`; chomp $todays_timestamp;
our $cur_time_secs		= `date +%s`;
our $timestamp_1yr		= $cur_time_secs - (360 * 24 * 60 * 60);		# subtract 1 year

our $cur_time_full		= `date +%F`; chomp $cur_time_full;
our $cur_time_smash		= $cur_time_full; $cur_time_smash =~ s/ //g;

our %month_name_to_num	= (	"Jan", 1, "Feb", 2, "Mar", 3, "Apr", 4,  "May", 5,  "Jun", 6,
							"Jul", 7, "Aug", 8, "Sep", 9, "Oct", 10, "Nov", 11, "Dec", 12 );
our %month_num_to_name	= ( 1, "Jan", 2, "Feb", 3, "Mar", 4,  "Apr", 5,  "May", 6,  "Jun",
							7, "Jul", 8, "Aug", 9, "Sep", 10, "Oct", 11, "Nov", 12, "Dec" );
our @daysinmonth		= ( 30, 27, 30, 29, 30, 29, 30, 30, 29, 30, 29, 30 );

sub days_since_1972
{
	my ( $year, $month, $day ) = @_;
	$month -= 1;		# use zero base calculations

	# starting reference date is: 1972-01-01 - find number of days since then
	my $years			= $year - 1972;
	my $leapdays		= int $years / 4;			# there are no [ no-leap-years ] between 1901 and 2099  :-)
	my $total			= ( $years * 365 ) + $leapdays + $day;
	for my $i ( 0 .. $month )
	{ $total += $daysinmonth[$i]; }
	return $total;
}


# TIME STAMPS }}}
# FILE STUFF {{{
# ----------------------------------------
# http://perldoc.perl.org/functions/-X.html
#	-r $file	File is readable by effective uid/gid.
#	-w $file	File is writable by effective uid/gid.
#	-x $file	File is executable by effective uid/gid.
#	-o $file	File is owned by effective uid.
#	-R $file	File is readable by real uid/gid.
#	-W $file	File is writable by real uid/gid.
#	-X $file	File is executable by real uid/gid.
#	-O $file	File is owned by real uid.
#	-e $file	File exists.
#	-z $file	File has zero size (is empty).
#	-s $file	File has nonzero size (returns size in bytes).
#	-f $file	File is a plain file.
#	-d $file	File is a directory.
#	-l $file	File is a symbolic link.
#	-p $file	File is a named pipe (FIFO), or Filehandle is a pipe.
#	-S $file	File is a socket.
#	-b $file	File is a block special file.
#	-c $file	File is a character special file.
#	-t $file	Filehandle is opened to a tty.
#	-u $file	File has setuid bit set.
#	-g $file	File has setgid bit set.
#	-k $file	File has sticky bit set.
#	-T $file	File is an ASCII text file (heuristic guess).
#	-B $file	File is a "binary" file (opposite of -T).
#	-M			Script start time minus file modification time, in days.
#	-A			Same for access time.
#	-C			Same for inode change time (Unix, may differ for other platforms)
#
# http://perldoc.perl.org/functions/stat.html
# my ( $dev, $ino, $mode, $nlink, $uid, $gid, $rdev,
#   $size, $atime, $mtime, $ctime,
#   $blksize, $blocks ) = stat( $filename );
#	dev			device number of filesystem
#	ino			inode number
#	mode		file mode (type and permissions)
#	nlink		number of (hard) links to the file
#	uid			numeric user ID of file's owner
#	gid			numeric group ID of file's owner
#	rdev		the device identifier (special files only)
#	size		total size of file, in bytes
#	atime		last access time in seconds since the epoch
#	mtime		last modify time in seconds since the epoch
#	ctime		inode change time in seconds since the epoch (*)
#	blksize		preferred block size for file system I/O
#	blocks		actual number of blocks allocated


# FILE STUFF }}}
# WGET SNIPETS {{{
# ----------------------------------------
# some sites have begun checking for wget user agents...
my  $useragent	= "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.18) Gecko/2010021501 Firefox/3.0.18";
our $wgetcmd	= "wget --waitretry=4 -U \"$useragent\"";

sub wget_new_cookies_postdata
{
	my $username    = "somecallmetim";
	my $accesscode  = "bluenoyellow";
	my $referer_url = "http://domain.name/index.php";
	my $link_url	= "http://domain.name/submit_form.php";
	my $cookies     = "cookies_for_domain_name.txt";
	my $postdata    = "login=$username&password=$accesscode";
	my $output      = "output_filename.html";

	# wget $link								\ # source
	#		-S									\ # server connection response headers
	#		-o $logfile							\ # stdout message captured
	#		-O $outfilename						\ # target
	#		--header "Cookie: $sessionname=$sessionid"	# craft custom http headers

	# use [ -o 'filename.txt' ] to log all output -- that's small "o"
	$wgetstr = "$wgetcmd --no-check-certificate -S --referer=$referer_url
			--keep-session-cookies --save-cookies $cookies
			--post-data '$postdata' '$link_url' -O '$output'";
	$wgetstr =~ s/\n//g;		# make one long string
	$wgetstr =~ s/\s+/ /g;
#	print "wget_new_cookies_postdata: $wgetstr\n";
	`$wgetstr`;
}

sub wget_with_cookies
{
	my $referer_url = "http://domain.name/index.php";
	my $link_url	= "http://domain.name/dynamic.php";
	my $cookies     = "cookies_for_domain_name.txt";
	my $output      = "output_filename.html";

	# use [ -o 'filename.txt' ] to log all output -- that's small "o"
	my $wgetstr = "$wgetcmd -S --referer=$referer_url --keep-session-cookies
			--save-cookies $cookies --load-cookies $cookies '$link_url' -O '$output'";
	$wgetstr =~ s/\n//g;		# make one long string
	$wgetstr =~ s/\s+/ /g;
#	print "wget_with_cookies: $wgetstr\n";
	`$wgetstr`;
}

sub wget_simple
{
	my ( $url, $output ) = @_;

	my $wgetstr = "$wgetcmd -S '$url' -O '$output'";
	`$wgetstr`;
}


# WGET SNIPETS }}}
# ----------------------------------------
# ----------------------------------------

1; # script return

# ----------------------------------------
# ----------------------------------------
# vim:filetype=perl
