#!/usr/bin/perl
#
# this source came from:
# http://www.perlfect.com/articles/streaming.shtml
#
#
# but this script was modified and used to see what:
# - http://googlecodesamples.com/html5/sse/sse.html
# which calls:
# - http://googlecodesamples.com/html5/sse/sse.php
# was outputting...
#
# this resulted in [ sse.pl ] found next to this script.
#
#
# this was needed because:
# - http://www.html5rocks.com/en/tutorials/eventsource/basics/#toc-server-code
# (as the example shown) doesn't really work, nor was the link "Download the code"
# any useful since it was pointing to sse.php -- which wasn't a text file but a
# live php page...


use Socket;

#my $handler = 'splay';

my $url = shift @ARGV;
$url=~m/http\:\/\/([^\:^\/]*)(?:\:(\d+))?\/(.*)/;
my $host = $1;
my $port = $2;
$port = 80 unless($port);
my $file = '/'.$3;

my $proto = getprotobyname('tcp');
socket(SOCK, PF_INET, SOCK_STREAM, $proto);
print "Looking up $host..\n";
my $sin = sockaddr_in($port, inet_aton($host));
print "Connecting to $host:$port..\n";
connect(SOCK, $sin) || die "Connect failed: $!\n";

my $old_fh = select(SOCK);
$|=1;
select($old_fh);

print "Requesting $file..\n";
print SOCK "GET $file HTTP/1.0\n";
print SOCK "Accept: */*\n";
print SOCK "User-Agent: webamp $version\n\n";
print "Waiting for reply..\n";
my $header = <SOCK>;
print "$header\n";
exit unless($header=~m/200|OK/);

while($header = <SOCK>) {
       chomp;
       last unless(m/\S/);
}

my $content; 
#open(HANDLER, "|$handler") or die "Cannot pipe input to $handler: $!\n";
#print "Redirecting HTTP filestream to $handler..\n";
print "Redirecting HTTP filestream to stdout\n";
while(read(SOCK, $content, 512))
{
#        print HANDLER $content;
        print "$content\n";
}
close SOCK;

