#!/usr/bin/perl
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://www.nickshin.com/CheatSheets/


# this file contains the perl script port of sse.php originally found at:
# - http://www.html5rocks.com/en/tutorials/eventsource/basics/#toc-server-code
# (as the example shown) doesn't really work, nor was the link "Download the code"
# any useful since it was pointing to sse.php -- which wasn't a text file but a
# live php page...
#
#
# the sse_fetch.pl script (found next to this one) was used to see how a
# live eventsource session looked.
#
#
# the only thing "new" in this script is the Reconnection-timeout section
# not found in the sse.php example.
#
#
# it was later that a working version of [ sse.php ] was found at:
# - http://code.google.com/r/javijimenezvillar-tapquo/source/browse/www.html5rocks.com/content/tutorials/eventsource/basics/demo/sse.php
# note: the php version may not always flush if certain php.ini options
# are not setup/configured to be flush() friendly...
# - http://php.net/manual/en/function.flush.php


# data payload can be single line stream:
#		data: this is a data\n\n
#
# multi line stream:
#		data: first data line\n
#		data: second data line\n\n
#
# even multi line JSON data:
#		data: {\n
#		data: "msg": "hello world",\n
#		data: "id": 12345\n
#		data: }\n\n


# ** WARNING ** WARNING ** WARNING ** WARNING ** WARNING ** WARNING ** WARNING **
#
# poor EventSource streamer implimentation (server) will not
# be processed by the browser properly
#
# ** WARNING ** WARNING ** WARNING ** WARNING ** WARNING ** WARNING ** WARNING **


# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 

# ----------------------------------------
use strict;
use warnings;

$| = 1; 



# ----------------------------------------
# craft headers
print "Cache-Control: no-cache\n";
print "Content-Type: text/event-stream\n";
print "Age: 0\n";
print "\n";


sub test_extra_features
{
	# ----------------------------------------
	# 'event name' messages
	print "event: login\n";
	print "data: hello world\n\n";
	
	my $time = localtime();
	print "event: server-time\n";
	print "data: $time\n\n";
	
	
	# ----------------------------------------
	# Controlling the Reconnection-timeout
	#
	# The browser attempts to reconnect to the source roughly 3 seconds after
	# each connection is closed. The timeout can be changed by including a
	# line beginning with "retry:", followed by the number of milliseconds to
	# wait before trying to reconnect.
	
	my $timeout = ( 5 + int(rand( 5 ) )) * 1000; # millisecs
	print "retry: $timeout\n";
	print "data: setting timeout to $timeout\n\n";
}
test_extra_features();

# ----------------------------------------
# periodic sends
for ( my $end = 3; $end > 0; $end-- ) {		# force a reconnect by the browser
#while(true){								# send forever
	my $time = localtime();
	print "id: 123456789\n";
	print "data: $time\n\n";
	sleep(2);
}


