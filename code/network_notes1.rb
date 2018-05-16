#!/usr/bin/ruby

# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# Creative Commons Attribution 3.0 License
#
# this file is from https://www.nickshin.com/CheatSheets/
#
#
# this file covers the network sockets (open read write close)
# (both peer2peer and multi-users) in the following languages:
# - C/C++
# - C#
# - Java
# - Node.js (added Apr 04 2014)
# - Perl
# - Python
# - Ruby
#
# note: all programs/scripts can be tested from one language to any other one.
#       this helps to show that the codes are language (platform) independent...
#       tcp peer2peer will run on port 50000
#       udp peer2peer will run on port 51000
#       and tcp multi-users will run on port 52000
#
# note: select() was chosen to provide "asynchronous" like behavior.
#       threading is possible to provide the same feature, but select()
#       is one popular use in socket programming.  some programming
#       languages have different functionality with select() which will
#       be noted in this file (hence the cheatsheets).
#
#       threaded programming (or, most likely, event driven programming)
#       may show up in another cheatsheet/notes file...
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


# MAKEFILE {{{
# --------------------------------------------------------------------------------

# technically, this ($0) started as a notes "txt" file and then morphed to
# a sample ruby script.  this ($0) will:
# - first generate the script/code files (that are used to test the actual
#   networking mechansim for each respective programming languages)
# - next, the pretty printed HTML code are generated from each of those files
# - and then, all of HTML files are smash into a single "notes" file
#   which is uploaded as the "network notes #1" cheatsheet file.
#
# in other words, this ($0) is the MASTER file that generates all of that.
#
# the details on how this is done, is laid out here for your viewing pleasure.
#
#
# to run:
#     ruby network_notes1.rb
# is the same as:
#     ruby network_notes1.rb all
# which will generate both the pretty printed
# HTML files and the network code files
#
#
# to generate the network code files only:
#     ruby network_notes1.rb code
#
# to generate the pretty printed HTML files only:
#     ruby network_notes1.rb html


# virtual functions {{{2
# header_print_XXX {{{3
# ----------------------------------------

# ....................
def header_print_none()
	return '' # nothing extra to print
end


# ....................
def header_print_cs()
	return <<EOF


to compile:
    mcs #$basename.cs
	# the file #$basename.exe is created

to run:
    mono #$basename.exe
	# or
	./#$basename.exe
EOF
end


# ....................
def header_print_java()
	return <<EOF


to compile:
    javac #$basename.java
	# the file #$basename.class is created

to run:
    java #$basename
	# note, do not call: java #$basename.class
EOF
end


# ....................
def header_print_node()
	return <<EOF


to run:
    node #$basename.js
EOF
end


# the following are not ment to be used as virtual,
# but are related to this section...

$header_comment_marker = {
	'c'    => [ '/* ', " */\n", ' * ' ],
	'cs'   => [ '/* ', " */\n", ' * ' ],
	'java' => [ '/* ', " */\n", ' * ' ],
	'js'   => [ '/* ', " */\n", ' * ' ],
	'pl'   => [ '', '', '# ' ],
	'py'   => [ "\"\"\"\n", "\"\"\"\n", '' ],
	'rb'   => [ '', '', '# ' ],
}

$header_comment_extra = {
	'c'    => method( :header_print_none ),
	'cs'   => method( :header_print_cs ),
	'java' => method( :header_print_java ),
	'js'   => method( :header_print_node ),
	'pl'   => method( :header_print_none ),
	'py'   => method( :header_print_none ),
	'rb'   => method( :header_print_none ),
}

$header_comment_template = ""			# this will be place in all generated script/code files

def header_section_comment()
	results, cend, cmid = $header_comment_marker[ $extension ]
	spacer = results == '' ? cmid : ''
	$header_comment_template.each { |c|
		results += spacer
		results += c
		spacer = cmid
	}
	head = $header_comment_extra[ $extension ]
	extra_comments = head.call()
	extra_comments.each { |c|
		results += spacer
		results += c
	}
	results += cmid + "\n" + cmid + "\n" + cmid + "NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.\n"
	results += cend + "\n\n"
	return results
end


# header_print_XXX }}}3
# parse_file_XXX {{{3
# ----------------------------------------

# ....................
def parse_file_header( line )
	# using this ($0) file's headers as the source for the generated files headers
	$header_comment_template += line.gsub( /^#[ ]?/, '' )	# s/# //
	$header_comment_template = "" if line =~ /$^/			# split( '\n' ).slice!( 0, 2 )
	$func = method( :parse_file_begin ) if line =~ /cheatsheet\.php/
end


# ....................
def parse_file_begin( line )
	if line =~ /^FILE_BEGIN: (.*)\.(.*)/
		$func = method( :parse_file_end )
		$basename = "#$1"
		$filename = "#$1.#$2"
		$extension = "#$2"
		puts "\tgenerating: #$filename"
		$scriptcode = '';
	end
end


# ....................
$source_highlight = {
	'c'    => 'c',
	'cs'   => 'cs',
	'java' => 'java',
	'js'   => 'js',
	'pl'   => 'pm',		###
	'py'   => 'py',
	'rb'   => 'rb',
}

def parse_file_end( line )
	if line =~ /^FILE_END/
		$func = method( :parse_file_begin )

		# generate the file
		fname = "#{$folder}/#{$filename}"
		File.open( fname, 'w' ) { |f| f.write( $scriptcode ) }

		# run source-highlighter
		shext = $source_highlight[$extension]
		system( "source-highlight --tab=4 --src-lang=#{shext} -i #{fname} -o #{fname}.html" )

	elsif line =~ /^HEADER/
		$scriptcode += header_section_comment()

	else
		$scriptcode += line
	end
end


# parse_file_XXX }}}3
# generate HTML notes file {{{3
# ----------------------------------------

# ....................
def pass1_header_pre( line )
	# omitting the first two lines of this file...
	$func = method( :pass1_header ) if line =~ /$^/		# split( '\n' ).slice!( 0, 2 )
end

def pass1_header( line )
	if line =~ /MAKEFILE \{\{\{/
		$func = method( :pass1_start )
	else
		$scriptcode += line
	end
end


def pass1_start( line )
	$func = method( :pass1_begin ) if line =~ /MAKEFILE \}\}\}/
end


def pass1_begin( line )
	if line =~ /^SKIP_START/
		$func = method( :pass1_skip )
		return
	end
	$scriptcode += line
	$func = method( :pass1_end ) if line =~ /^FILE_BEGIN:/
end


def pass1_end( line )
	$func = method( :pass1_begin ) if line =~ /^FILE_END/
end


def pass1_skip( line )
	$func = method( :pass1_begin ) if line =~ /^SKIP_END/
end


# ....................
$generate_links = {
	'c'    => 'C/C++',
	'cs'   => 'C#',
	'java' => 'Java',
	'js'   => 'Node.js',
	'pl'   => 'Perl',
	'py'   => 'Python',
	'rb'   => 'Ruby',
}

def print_all_links()
	$scriptcode += "</pre>\n<p>\n<center>"
	$generate_links.keys.sort.each { |key|
		value = $generate_links[ key ]
		$scriptcode += "| <a href=\"\##{key}\">#{value}</a>\n"
	}
	$scriptcode += "|</center>\n<p>\n<pre>"
end

$map_links = {
	'c'    => 'cs',
	'cs'   => 'java',
	'java' => 'js',
	'js'   => 'pl',
	'pl'   => 'py',
	'py'   => 'rb',
	'rb'   => '',							# not used
}

def pass2_generate( line )
	if line =~ /^FILE_BEGIN/
		line = line.gsub( /<[^>]+>/, '' )	# strip HTML tags
		if line =~ /: (.*)\.(.*)/
			$filename = "#$1.#$2"
			$extension = "#$2"
			fname = "#{$folder}/#{$filename}"
			# inject generated HTML file
			lines = IO.readlines( "#{fname}.html" )
			lines.each { |l|
				l = l.gsub( /(<pre>)/, "#$1----- begin #{$filename} -----\n" )
				l = l.gsub( /(<\/pre>)/, "\n----- endof #{$filename} -----#$1" )
				if l =~ /(^<[^>]+)>(.+ (TCP|UDP) .+ (server|client)[^<]*)<(.+)/
					l = "#$1><blink>#$2</blink><#$5\n" # add blinking tag...
				end
				$scriptcode += l
			}
		end
	else
		if line =~ /# TCP<\/font>/
			# $extension contains the extension from a previous section
			# so, this will be converted via the map table
			print_all_links()
			aname = $map_links[ $extension ]
			$scriptcode += "<a name=\"#{aname}\"></a>\n"
		elsif line =~ /# (UDP|SELECT)<\/font>/
			print_all_links()
		elsif line =~ /^ANAME (.*)/
			# c doesn't have any code (including any work in progress code)
			# so, use ANAME label to support adding links to blank code
			ext = "#$1"
			print_all_links()
			$scriptcode += "<a name=\"#{ext}\"></a>\n"
			line = ''
		end
		$scriptcode += line
	end
end


# generate HTML notes file }}}3
# virtual functions }}}2
# MAIN {{{2
# ----------------------------------------


$generateCODE = false
generateHTML = false
ARGV.each { |opt|
	opt_up = opt.upcase
	case opt_up
		when 'ALL'
			$generateCODE = true
			generateHTML = true
		when 'CODE'
			$generateCODE = true
		when 'HTML'
			generateHTML = true
		else
			puts "UNKNOWN option encountered: [ " + opt + " ]"
			print <<USAGE_MSG

to run:
	ruby network_notes1.txt

is the same as:
	ruby network_notes1.txt all
which will generate both the pretty printed
HTML files and the network code files

to generate the network code files only:
	ruby network_notes1.txt code

to generate the pretty printed HTML files only:
	ruby network_notes1.txt html

USAGE_MSG
			exit
	end
}

if ( ! $generateCODE && ! generateHTML )
	$generateCODE = true
	generateHTML = true
end


# house keeping
# ....................
$folder = 'network'
Dir.mkdir( $folder ) if ! File.directory?( $folder )


# the meat of this script
# ....................
def parse_this_file()
	puts "parsing network notes..."
	$func = method( :parse_file_header )
	$head = method( :header_print_none )
	lines = IO.readlines( $0 )
	if ( $generateCODE )
		lines.each { |l| $func.call( l ) }
	end
	return lines
end
#XXX remove comment when done XXX
lines = parse_this_file()


exit if ( ! generateHTML )


# do it again, this time, generating the final uploadable notes file
# to keep things clean and simple, this will be done in two passes.
# first, to generate this ($0) source-highlighted file and then
# second, inject the generated HTML files from the previous step above
# into the first step's generated file.
def first_pass( lines )
	puts "\ncreating HTML network notes..."
	puts "\tfirst pass..."
	$func = method( :pass1_header_pre )
	$scriptcode = '';
	lines.each { |l| $func.call( l ) }
end
#XXX remove comment when done XXX
first_pass( lines )


# output to intermediary file
$filename = '0_rubyheader.rb'
fname = "#{$folder}/#{$filename}"
def intermediate_output( fname )
	File.open( fname, 'w' ) { |f| f.write( $scriptcode ) }
	# generate source-hightlighted file
	shext = 'rb'
	system( "source-highlight --tab=4 --src-lang=#{shext} -i #{fname} -o #{fname}.html" )
end
#XXX remove comment when done XXX
intermediate_output( fname )


def second_pass( fname )
	puts "\tsecond pass..."
	lines = IO.readlines( "#{fname}.html" )
	$func = method( :pass2_generate )
	$scriptcode = '';
	lines.each { |l| $func.call( l ) }
	print_all_links()					# throw on at the bottom of the file
	
	# finally...
	fname = "#{$0}.html"
	File.open( fname, 'w' ) { |f| f.write( $scriptcode ) }
end
#XXX remove comment when done XXX
second_pass( fname )


# MAIN }}}2
# ----------------------------------------
__END__


# MAKEFILE }}}
# C/C++ {{{
# --------------------------------------------------------------------------------

ANAME c
FILE_BEGIN: c_cpp_network.c
HEADER
// note: there are plenty of berkley socket programming information out there.
// and these are my cheat sheets.  so, as such, when i program c/c++ networking
// i normally use the SDL_net library.  <snip giant explaination about what i
// use it for and why, cross platform issues, how the other languages are fairly
// platform agnostic, etc. etc. etc...>

// and to be even lazier about this, go here...
// http://gpwiki.org/index.php/SDL:Tutorial:Using_SDL_net
FILE_END


# C/C++ }}}
# Csharp {{{
# --------------------------------------------------------------------------------



# TCP
# http://codeidol.com/csharp/csharp-network/Csharp-Network-Programming-Classes/Csharp-Socket-Programming/
# ........................................


FILE_BEGIN: csharp_tcp_server.cs
HEADER
// csharp: TCP echo server
using System;				// Console
using System.Text;			// Encoding
using System.Net;			// IPHostEntry IPEndPoint
using System.Net.Sockets;	// Socket SocketException

class Csharp_tcp_server
{
	public static void Main( string[] args ) {
		string host = "localhost";
		int port = 50000;
		int backlog = 5;
		int maxsize = 1024;

// if host has more than one NIC/IPaddresses
		IPHostEntry results = Dns.GetHostByName( host );
		IPAddress addr = results.AddressList[0];
//		IPAddress addr = IPAddress.Parse( "127.0.0.1" );
//		IPEndPoint iep = new IPEndPoint( IPAddress.Any, port );
		IPEndPoint iep = new IPEndPoint( addr, port );

		Socket sock;
		try {
			sock = new Socket( AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp );
		} catch( SocketException e ) {
			Console.WriteLine( "socket error: " + e.ToString() );
			return;
		}
		try {
			sock.Bind( iep );
			sock.Listen( backlog );
		} catch( SocketException e ) {
			Console.WriteLine( "unable to bind to port: {0} {1}", port, e.ToString() );
			return;
		}
		Console.WriteLine( "server started on port " + port );

		byte[] msg = new byte[maxsize];
		while ( true ) {
			Socket client = sock.Accept();					// blocking
			IPEndPoint client_iep = (IPEndPoint)client.RemoteEndPoint;
			string laddr = client_iep.ToString();

			if ( client.Receive( msg, maxsize, 0 ) != 0 ) {	// blocking
				Console.WriteLine( "connection from: {0} {1}", laddr, Encoding.ASCII.GetString( msg ) );
				client.Send( msg );			// sends even on a broken socket
				// csharp specific function that throws on error...
				// to "gracefully" shutdown buffers: in this case both Receive & Send
				try	{ client.Shutdown( SocketShutdown.Both ); } catch( SocketException ){}
			} else
				Console.WriteLine( "lost connection on recv: " + laddr );
			client.Close();
	}	}
}
FILE_END


# ........................................


FILE_BEGIN: csharp_tcp_client.cs
HEADER
// csharp: TCP echo client
using System;				// Console
using System.Text;			// Encoding
using System.Net;			// IPHostEntry IPEndPoint
using System.Net.Sockets;	// Socket SocketException

class Csharp_tcp_client
{
	public static void Main( string[] args ) {
		string host = "localhost";
		int port = 50000;
		int maxsize = 1024;

		Socket sock;
		try {
			sock = new Socket( AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp );
		} catch( SocketException e ) {
			Console.WriteLine( "socket error: " + e.ToString() );
			return;
		}
		IPHostEntry results = Dns.GetHostByName( host );
		IPEndPoint iep = new IPEndPoint( results.AddressList[0], port );
		try { sock.Connect( iep ); }
		catch( SocketException e ) {
			Console.WriteLine( "unable to connect to {0}:{1} {2}", host, port, e.ToString() );
			return;
		}
		Console.WriteLine( "connected to server, sending msg..." );

		sock.Send( Encoding.ASCII.GetBytes( "Howdy" ) );	// sends even on a broken socket

		Console.WriteLine( "server response:" );
		byte[] msg = new byte[maxsize];
		if ( sock.Receive( msg, maxsize, 0 ) != 0 ) {		// blocking
			Console.WriteLine( "Received " + Encoding.ASCII.GetString( msg ) );
			// csharp specific function that throws on error...
			// to "gracefully" shutdown buffers: in this case both Receive & Send
			try	{ sock.Shutdown( SocketShutdown.Both ); } catch( SocketException ){}
		} else
			Console.WriteLine( "lost connection on recv" );
		sock.Close();
	}
}
FILE_END


# UDP
# http://www.java2s.com/Code/CSharp/Network/SimpleUdpServer.htm
# ........................................


FILE_BEGIN: csharp_udp_server.cs
HEADER
// csharp: UDP echo server
using System;				// Console
using System.Text;			// Encoding
using System.Net;			// IPHostEntry IPEndPoint
using System.Net.Sockets;	// Socket SocketException

class Csharp_udp_server
{
	public static void Main( string[] args ) {
		string host = "localhost";
		int port = 51000;
		int maxsize = 1024;

		IPHostEntry results = Dns.GetHostByName( host );
		IPEndPoint iep = new IPEndPoint( results.AddressList[0], port );
		Socket sock;
		try {
			sock = new Socket( AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp );
		} catch( SocketException e ) {
			Console.WriteLine( "socket error: " + e.ToString() );
			return;
		}
		try { sock.Bind( iep ); }
		catch( SocketException e ) {
			Console.WriteLine( "unable to bind to port: {0} {1}", port, e.ToString() );
			return;
		}
		Console.WriteLine( "server started on port " + port );

		byte[] msg = new byte[maxsize];
		IPEndPoint remote_iep = new IPEndPoint( IPAddress.Any, 0 );
		EndPoint remote_ep = (EndPoint)(remote_iep);
		while ( true ) {
			int recv = sock.ReceiveFrom( msg, ref remote_ep );	// blocking
			if ( recv != 0 ) {
				Console.WriteLine( "msg from: {0} {1}", remote_ep.ToString(),
									Encoding.ASCII.GetString( msg, 0, recv ) );
				sock.SendTo( msg, recv, SocketFlags.None, remote_ep );
			} else
				Console.WriteLine( "empty msg from: " + remote_ep.ToString() );
	}	}
}
FILE_END


# http://www.java2s.com/Code/CSharp/Network/UdpClientSample.htm
# ........................................


FILE_BEGIN: csharp_udp_client.cs
HEADER
// csharp: UDP echo client
using System;				// Console
using System.Text;			// Encoding
using System.Net;			// IPHostEntry IPEndPoint
using System.Net.Sockets;	// Socket SocketException

class Csharp_udp_client
{
	public static void Main( string[] args ) {
		string host = "localhost";
		int port = 51000;
		int maxsize = 1024;
		byte[] msg = new byte[maxsize];

		UdpClient sock;
		try { sock = new UdpClient( host, port ); }
		catch( SocketException e ) {
			Console.WriteLine( "socket error: " + e.ToString() );
			return;
		}
		Console.WriteLine( "sending msg to server..." );

		msg = Encoding.ASCII.GetBytes( "Howdy" );
		sock.Send( msg, msg.Length );

		Console.WriteLine( "server response:" );
		IPEndPoint remote_iep = new IPEndPoint( IPAddress.Any, port );
		msg = sock.Receive( ref remote_iep );				// blocking
		sock.Close();
		// note, this msg may not have come from the "server"
		if ( msg.Length != 0 )
			Console.WriteLine( "msg from {0} {1}", remote_iep.ToString(),
								Encoding.ASCII.GetString( msg, 0, msg.Length ) );
		else
			Console.WriteLine( "empty msg from:", remote_iep.ToString() );
	}
}
FILE_END


# SELECT
# http://codeidol.com/csharp/csharp-network/Csharp-Network-Programming-Classes/Csharp-Socket-Programming/#254
# WARNING: CSHARP Select() HAS A TIMEOUT PARAMETER THAT CANNOT BE SET TO "forever"
#          which means it acts more like poll() -- so using threads...
# ........................................


FILE_BEGIN: csharp_tcp_server_select.cs
HEADER
// csharp: TCP chat server with select()
// entering ANY line of input will exit the server
// -- and yes, this is technically a blocking threaded server solution...
using System;				// Console
using System.Text;			// Encoding
using System.Net;			// IPHostEntry IPEndPoint
using System.Net.Sockets;	// Socket SocketException Select
using System.Threading;		// Thread
using System.Collections;	// ArrayList

class ClientWatcher
{
	private static ArrayList clients;
	public Socket client;
	public IPEndPoint iep;
	public Thread thread;

	public ClientWatcher( Socket c, ref ArrayList l ) {
		client = c;
		clients = l;
		clients.Add( this );
		iep = (IPEndPoint)c.RemoteEndPoint;

		thread = new Thread( new ThreadStart( this.run ) );
		thread.Start();
	}

	private void run() {
		int maxsize = 1024;
		byte[] data = new byte[maxsize];

		string tosend;
		int size;
		while ( true ) {
			try { size = client.Receive( data, maxsize, 0 ); }	// blocking
			catch( SocketException ) { size = 0; }
			if ( size != 0 ) {
				string msg = Encoding.ASCII.GetString( data );
				tosend = "msg from " + iep.ToString() + " " + msg;
				echo_and_send_to_clients( tosend );
				continue;
			}
			// csharp specific function that throws on error...
			// to "gracefully" shutdown buffers: in this case both Receive & Send
			try	{ client.Shutdown( SocketShutdown.Both ); } catch( SocketException ){}
			client.Close();
			clients.Remove( this );
			tosend = "client leaving: " + iep.ToString();
			echo_and_send_to_clients( tosend );
			return;
	}	}

	public void echo_and_send_to_clients( string tosend ) {
		byte[] data = Encoding.ASCII.GetBytes( tosend );
		Console.WriteLine( tosend );
		foreach( ClientWatcher c in clients )
			c.client.Send( data );			// sends even on a broken socket
	}
}

class Csharp_tcp_server_select
{
	private Socket sock;
	private ArrayList clients = new ArrayList();

	public static void Main( string[] args ) {
		Csharp_tcp_server_select demo = new Csharp_tcp_server_select();
		demo.csharp_tcp_server_select();
	}

	public void csharp_tcp_server_select() {
		string host = "localhost";
		int port = 52000;
		int backlog = 5;

		IPHostEntry results = Dns.GetHostByName( host );
		IPEndPoint iep = new IPEndPoint( results.AddressList[0], port );
		try {
			sock = new Socket( AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp );
		} catch( SocketException e ) {
			Console.WriteLine( "socket error: " );
			Console.WriteLine( e.ToString() );
			return;
		}
		try {
			sock.Bind( iep );
			sock.Listen( backlog );
		} catch( SocketException e ) {
			Console.WriteLine( "unable to bind to port: " + port );
			Console.WriteLine( e.ToString() );
			return;
		}
		Console.WriteLine( "server started on port " + port );

		// Select() does NOT return a list of ready to read objects...
		// so, spin off threads to prevent main loop from being blocked.
		Thread networkThread = new Thread( networkWatcher );
		networkThread.Start();

		// think of the following as the main loop...
		Console.ReadLine();									// blocking

		Console.WriteLine( "shutting down server..." );
		// terminate any live threads -- or else program keeps running...
		networkThread.Abort();
		foreach( ClientWatcher c in clients ) {
			// csharp specific function that throws on error...
			// to "gracefully" shutdown buffers: in this case both Receive & Send
			try	{ c.client.Shutdown( SocketShutdown.Both ); } catch( SocketException ){}
			c.client.Close();
			c.thread.Abort();
		}

		sock.Shutdown( SocketShutdown.Both );				// both: Receive & Send buffers
		sock.Close();
	}

	private void networkWatcher() {
		while ( true ) {
			Socket client;
			try { client = sock.Accept(); }					// blocking
			catch { return; }	// catch all: chances are, server is shutting down now...
			ClientWatcher c = new ClientWatcher( client, ref clients );
			string tosend = "connection from: " + c.iep.ToString();
			c.echo_and_send_to_clients( tosend );
	}	}
}
FILE_END


# ........................................


FILE_BEGIN: csharp_tcp_client_select.cs
HEADER
// csharp: TCP chat client with select()
// entering ANY line of input will exit the server
// try this with more than one client...
using System;				// Console
using System.Text;			// Encoding
using System.Net;			// IPHostEntry IPEndPoint
using System.Net.Sockets;	// Socket SocketException /* -Select */
using System.Threading;		// Thread

class Csharp_tcp_client_select
{
	private bool running = true;
	private Socket sock;

	public static void Main( string[] args ) {
		Csharp_tcp_client_select demo = new Csharp_tcp_client_select();
		demo.csharp_tcp_client_select();
	}

	public void csharp_tcp_client_select() {
		string host = "localhost";
		int port = 52000;

		try {
			sock = new Socket( AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp );
		} catch( SocketException e ) {
			Console.WriteLine( "socket error: " + e.ToString() );
			return;
		}
		IPHostEntry results = Dns.GetHostByName( host );
		IPEndPoint iep = new IPEndPoint( results.AddressList[0], port );
		try { sock.Connect( iep ); }
		catch( SocketException e ) {
			Console.WriteLine( "unable to connect to {0}:{1} {2}", host, port, e.ToString() );
			return;
		}
		Console.WriteLine( "connected to server" );

		Console.Write( "% " );
		Console.Out.Flush();

		// Select() does NOT return a list of "ready to read" objects...
		// instead, sockets (which needs to be set to non-blocking)
		// needs to be polled for any data.
		//
		// also, keyboard (STDIN) cannot be added to the (polling) ArrayList
		// or else, during ReadLine() will block...
		// so, spin off threads to prevent main loop from being blocked.
		Thread networkThread = new Thread( networkWatcher );
		networkThread.Start();
		Thread keyboardThread = new Thread( keyboardWatcher );
		keyboardThread.Start();

//		ArrayList input = new ArrayList();
//		input.add( sock );
//		input.add( STDIN... );

		while ( running ) {
// NOTE: csharp Select() acts more like poll()
//			Socket.Select( input, null, null, 1000 );
			Thread.Sleep( 100 );		// meh...
		}

		// terminate any live threads -- or else program keeps running...
		networkThread.Abort();
		keyboardThread.Abort();

		// csharp specific function that throws on error...
		// to "gracefully" shutdown buffers: in this case both Receive & Send
		try	{ sock.Shutdown( SocketShutdown.Both ); } catch( SocketException ){}
		sock.Close();
	}

	private void networkWatcher() {
		int maxsize = 1024;
		byte[] data = new byte[maxsize];
		int size;
		while ( true ) {
			try { size = sock.Receive( data, maxsize, 0 ); }	// blocking
			catch( SocketException ) { size = 0; }
			if ( size != 0 ) {
				Console.WriteLine( Encoding.ASCII.GetString( data ) );
				Console.Write( "% " );
				Console.Out.Flush();
				continue;
			}
			Console.WriteLine( "server has left the building..." );
			running = false;
			return;
	}	}

	private void keyboardWatcher() {
		while ( true ) {
			string msg = Console.ReadLine();				// blocking
			msg = msg.Replace("\n","").Replace("\r","");	// chomp( msg );
			if ( msg.Length != 0 ) {
				sock.Send( Encoding.ASCII.GetBytes( msg ) );	// sends even on a broken socket
				continue;
			}
			Console.WriteLine( "leaving..." );
			running = false;
			return;
	}	}
}
FILE_END


# csharp's alternative "asynchronous" functionality uses CALLBACK mechanisms:
# http://codeidol.com/csharp/csharp-network/Asynchronous-Sockets/Sample-Programs-Using-Asynchronous-Sockets/
# ........................................


FILE_BEGIN: csharp_tcp_server_select_alt.cs
HEADER
// csharp: TCP chat server with select() alternative...
// entering ANY line of input will exit the server
using System;				// Console
using System.Text;			// Encoding
using System.Net;			// IPHostEntry IPEndPoint
using System.Net.Sockets;	// Socket SocketException
using System.Threading;		// Thread
using System.Collections;	// ArrayList

class Csharp_tcp_server_select_alt
{
	private bool running = true;
	private Socket sock;
	private ArrayList clients = new ArrayList();
	private static int maxsize = 1024;
	private byte[] data = new byte[maxsize];

	public static void Main( string[] args ) {
		Csharp_tcp_server_select_alt demo = new Csharp_tcp_server_select_alt();
		demo.csharp_tcp_server_select_alt();
	}

	public void csharp_tcp_server_select_alt() {
		string host = "localhost";
		int port = 52000;
		int backlog = 5;

		IPHostEntry results = Dns.GetHostByName( host );
		IPEndPoint iep = new IPEndPoint( results.AddressList[0], port );
		try {
			sock = new Socket( AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp );
		} catch( SocketException e ) {
			Console.WriteLine( "socket error: " + e.ToString() );
			return;
		}
		try {
			sock.Bind( iep );
			sock.Listen( backlog );
		} catch( SocketException e ) {
			Console.WriteLine( "unable to bind to port: {0} {1}", port, e.ToString() );
			return;
		}
		sock.BeginAccept( new AsyncCallback( AcceptConn ), sock );
		Console.WriteLine( "server started on port " + port );

		// think of the following as the main loop...
		Console.ReadLine();									// blocking

		running = false;
		Console.WriteLine( "shutting down server..." );
		foreach( Socket c in clients ) {
			// csharp specific function that throws on error...
			// to "gracefully" shutdown buffers: in this case both Receive & Send
			try	{ c.Shutdown( SocketShutdown.Both ); } catch( SocketException ){}
			c.Close();
		}
		sock.Shutdown( SocketShutdown.Both );				// both: Receive & Send buffers
		sock.Close();
	}

	private void AcceptConn( IAsyncResult iar ) {
		Socket socky = (Socket)iar.AsyncState;	// note: socky == this.sock
		Socket client = socky.EndAccept(iar);
		if ( running == false )
			return;

		clients.Add( client );
		IPEndPoint client_iep = (IPEndPoint)client.RemoteEndPoint;
		string tosend = "connection from: " + client_iep.ToString();
		echo_and_send_to_clients( tosend );

		client.BeginReceive( data, 0, maxsize, SocketFlags.None,
					new AsyncCallback( ReceiveData ), client );

		// "loop" back to this function
		socky.BeginAccept( new AsyncCallback( AcceptConn ), socky );
	}

	private void ReceiveData( IAsyncResult iar ) {
		Socket client;
		int recv;
		string msg;
		lock ( data ) { // jic
			client = (Socket)iar.AsyncState;
			recv = client.EndReceive(iar);
			msg = ( recv <= 0 ) ? "" : Encoding.ASCII.GetString( data, 0, recv );
		}
		if ( running == false )
			return;

		IPEndPoint client_iep = (IPEndPoint)client.RemoteEndPoint;
		if (recv <= 0) {
			string tosend = "client leaving: " + client_iep.ToString();
			clients.Remove( client );
			// csharp specific function that throws on error...
			// to "gracefully" shutdown buffers: in this case both Receive & Send
			try	{ client.Shutdown( SocketShutdown.Both ); } catch( SocketException ){}
			client.Close();
			echo_and_send_to_clients( tosend );
		} else {
			string tosend = "msg from " + client_iep.ToString() + " " + msg;
			echo_and_send_to_clients( tosend );
			// "loop" back to this function
			client.BeginReceive( data, 0, maxsize, SocketFlags.None,
						new AsyncCallback( ReceiveData ), client );
	}	}

	private void echo_and_send_to_clients( string tosend ) {
		Console.WriteLine( tosend );
		byte[] datamsg = Encoding.ASCII.GetBytes( tosend );
		foreach( Socket c in clients )
			// sends even on a broken socket
			c.BeginSend( datamsg, 0, datamsg.Length, SocketFlags.None,
						new AsyncCallback( SendData ), c );
	}

	private void SendData(IAsyncResult iar) {
		Socket client = (Socket)iar.AsyncState;
		/* int sent = */ client.EndSend(iar);
		// do something here after send was "successful"
	}
}
FILE_END


# ........................................


FILE_BEGIN: csharp_tcp_client_select_alt.cs
HEADER
// csharp: TCP chat client with select() alternative...
// entering ANY line of input will exit the server
// try this with more than one client...
using System;				// Console
using System.Text;			// Encoding
using System.Net;			// IPHostEntry IPEndPoint
using System.Net.Sockets;	// Socket SocketException
using System.Threading;		// Thread

class Csharp_tcp_client_select_alt
{
	private bool running = true;
	private Socket sock;
	private static int maxsize = 1024;
	private byte[] data = new byte[maxsize];

	public static void Main( string[] args ) {
		Csharp_tcp_client_select_alt demo = new Csharp_tcp_client_select_alt();
		demo.csharp_tcp_client_select_alt();
	}

	public void csharp_tcp_client_select_alt() {
		string host = "localhost";
		int port = 52000;

		try {
			sock = new Socket( AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp );
		} catch( SocketException e ) {
			Console.WriteLine( "socket error: " );
			Console.WriteLine( e.ToString() );
			return;
		}

		IPHostEntry results = Dns.GetHostByName( host );
		IPEndPoint iep = new IPEndPoint( results.AddressList[0], port );
		// WARNING: this call will NOT error out or time out if server port is not opened...
		// need to make a "timer" to watch for this... meh...
		sock.BeginConnect( iep, new AsyncCallback( Connected ), sock );

		// spin off thread to prevent main loop from being blocked.
		Thread keyboardThread = new Thread( keyboardWatcher );
		keyboardThread.Start();

// uncomment the following to handle "BeginConnect" issue properly...
//		int timer = 2000;
//		while ( ! sock.Connected ) {	// see warning note above for this check...
//			Thread.Sleep( 100 );
//			timer -= 100;
//			if ( timer < 0 ) {
//				Console.WriteLine( "time out: Connection Refused" );
//				running = false;
//				break;
//		}	}

		while ( running ) {
			Thread.Sleep( 100 );		// meh...
// uncomment the following to handle "BeginReceive" issue properly...
//			if ( ! sock.Connected )		// see warning note in ReceivedData() for this check...
//				networkServerDown();
		}

		// terminate any live threads -- or else program keeps running...
		keyboardThread.Abort();

		// csharp specific function that throws on error...
		// to "gracefully" shutdown buffers: in this case both Receive & Send
		try	{ sock.Shutdown( SocketShutdown.Both ); } catch( SocketException ){}
		sock.Close();
	}

	private void networkServerDown() {
		Console.WriteLine( "server has left the building..." );
		running = false;
	}

	private void Connected( IAsyncResult iar ) {
		Socket socky = (Socket)iar.AsyncState;				// note: socky == sock
		try { socky.EndConnect(iar); }
		catch ( SocketException ) {
			Console.WriteLine( "unable to connect to {0}", socky.RemoteEndPoint.ToString() );
			running = false;
			return;
		}
		Console.WriteLine( "connected to server" );
		Console.Write( "% " );
		Console.Out.Flush();
		socky.BeginReceive( data, 0, maxsize, SocketFlags.None,
					new AsyncCallback( ReceiveData ), socky );
	}

	private void ReceiveData( IAsyncResult iar ) {
		// WARNING: if connection terminates abnormally, this function will never be awaken...
		Socket socky;
		int recv;
		string msg;
		lock ( data ) {
			socky = (Socket)iar.AsyncState;					// note: socky == sock
			recv = socky.EndReceive(iar);
			msg = ( recv <= 0 ) ? "" : Encoding.ASCII.GetString( data, 0, recv );
		}
		if ( running == false )
			return;

		if ( recv <= 0 ) {
			networkServerDown();
			return;
		}
		Console.WriteLine( msg );
		Console.Write( "% " );
		Console.Out.Flush();
		// "loop" back to this function
		socky.BeginReceive( data, 0, maxsize, SocketFlags.None,
					new AsyncCallback( ReceiveData ), socky );
	}

	private void keyboardWatcher() {
		byte[] datamsg;
		while ( true ) {
			string msg = Console.ReadLine();				// blocking
			msg = msg.Replace("\n","").Replace("\r","");	// chomp( msg );
			if ( msg.Length == 0 ) {
				Console.WriteLine( "leaving..." );
				running = false;
				return;
			}
			datamsg = Encoding.ASCII.GetBytes( msg );
			try {
				// sends even on a broken socket
				sock.BeginSend( datamsg, 0, datamsg.Length, SocketFlags.None,
						new AsyncCallback( SendData ), sock );
			} catch( SocketException ) {
				networkServerDown();
				return;
	}	}	}

	private void SendData( IAsyncResult iar ) {
		Socket socky = (Socket)iar.AsyncState;				// note: socky == sock
		/* int sent = */ socky.EndSend(iar);
		// do something here after send was "successful"
   }
}
FILE_END


# Csharp }}}
# Exlixir {{{
# --------------------------------------------------------------------------------



# TCP
# http: reference
# ........................................


FILE_BEGIN: exlixir_tcp_server.ex
#!/usr/bin/iex

HEADER
# exlixir: TCP echo server - plain ol Socket


FILE_END


FILE_BEGIN: exlixir_tcp_client.ex
#!/usr/bin/iex

HEADER
# exlixir: TCP echo client - plain ol Socket


FILE_END


# UDP
# http: reference
# ........................................


FILE_BEGIN: exlixir_udp_server.ex
#!/usr/bin/iex

HEADER
# exlixir: UDP echo server - plain ol Socket


FILE_END


FILE_BEGIN: exlixir_udp_client.ex
#!/usr/bin/iex

HEADER
# exlixir: UDP echo client -- plain ol Socket


FILE_END


# SELECT
# http: referene
# ........................................


FILE_BEGIN: exlixir_tcp_server_select.ex
#!/usr/bin/iex

HEADER
# exlixir: TCP chat server with select()
# entering ANY line of input will exit the server


FILE_END


FILE_BEGIN: exlixir_tcp_client_select.ex
#!/usr/bin/iex

HEADER
# exlixir: TCP chat client with select()
# entering ANY line of input will exit the server
# try this with more than one client...


FILE_END


# Exlixir }}}
# GoLang {{{
# --------------------------------------------------------------------------------



# TCP
# http: reference
# ........................................


FILE_BEGIN: NEXT_tcp_server.go
HEADER
# go: TCP echo server - plain ol Socket


FILE_END


FILE_BEGIN: NEXT_tcp_client.go
HEADER
# go: TCP echo client - plain ol Socket


FILE_END


# UDP
# http: reference
# ........................................


FILE_BEGIN: NEXT_udp_server.go
HEADER
# go: UDP echo server - plain ol Socket


FILE_END


FILE_BEGIN: NEXT_udp_client.go
HEADER
# go: UDP echo client -- plain ol Socket


FILE_END


# SELECT
# http: referene
# ........................................


FILE_BEGIN: NEXT_tcp_server_select.go
HEADER
# go: TCP chat server with select()
# entering ANY line of input will exit the server


FILE_END


FILE_BEGIN: NEXT_tcp_client_select.go
HEADER
# go: TCP chat client with select()
# entering ANY line of input will exit the server
# try this with more than one client...


FILE_END


# GoLang }}}
# Java {{{
# --------------------------------------------------------------------------------


# TCP
# http://gpwiki.org/index.php/Java:Tutorials:Simple_TCP_Networking
# ........................................


FILE_BEGIN: java_tcp_server.java
HEADER
// java: TCP echo server
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.IOException;

import java.net.Socket;
import java.net.ServerSocket;
import java.net.InetAddress;

class java_tcp_server
{
	public static void main( String argv[] ) throws Exception {
		String host = "localhost";
		int port = 50000;
		int backlog = 5;
		int maxsize = 1024;

// if host has more than one NIC/IPaddresses
//		byte [] b = new byte[] {(byte)127,(byte)0,(byte)0,(byte)1};
//		InetAddress addr = InetAddress.getByAddress(b);
		InetAddress addr = InetAddress.getByName( host );

		ServerSocket sock;
//public ServerSocket(int port) throws IOException
//public ServerSocket(int port, int backlog) throws IOException
//public ServerSocket(int port, int backlog, InetAddress bindAddr) throws IOException
		try { sock = new ServerSocket( port, backlog, addr ); }
		catch( IOException e ) {
			System.err.println( "socket error:" + e );
			return;
		}
		System.out.println( "server started on port " + port );

		while ( true ) {
			Socket client = sock.accept();			// blocking
			addr = client.getInetAddress();
			port = client.getPort();

			BufferedReader in = new BufferedReader( new InputStreamReader( client.getInputStream() ) );
//			String msg = in.readLine();				// this waits for newline...
			char[] data = new char[maxsize];
			int size = in.read( data, 0, maxsize );	// blocking & doesn't need newline to return...
			if ( size > 0 ) {
				String msg = new String( data );
				System.out.println( "connection from: " + addr + ":" + port + " " + msg );

				PrintWriter out = new PrintWriter( client.getOutputStream(), true );
				out.print( msg );					// sends even on a broken socket
				out.flush();
				out.close();
			} else
			{ System.out.println( "lost connection on recv: " + addr + ":" + port ); }
			in.close();
			client.close();
	}	}
}
FILE_END


# ........................................


FILE_BEGIN: java_tcp_client.java
HEADER
// java: TCP echo client
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.IOException;

import java.net.Socket;
import java.net.SocketException;
//import java.net.UnknownHostException;

class java_tcp_client
{
	public static void main(String argv[]) throws Exception {
		String host = "localhost";
		int port = 50000;

		Socket sock;
//public Socket(String host, int port) throws UnknownHostException, IOException
//public Socket(InetAddress address, int port) throws IOException
//public Socket(String host, int port, InetAddress localAddr, int localPort) throws IOException
//public Socket(InetAddress address, int port, InetAddress localAddr, int localPort) throws IOException
		try { sock = new Socket( host, port ); }
		catch( IOException e ) {
			System.err.println( "socket error: " + e );
			return;
		}
		System.out.println( "connected to server, sending msg..." );

		PrintWriter out = new PrintWriter( sock.getOutputStream(), true );
		out.print( "Howdy" );				// sends even on a broken socket
		out.flush();
//		out.close(); // WARNING: closing here, will terminate the connection...

		System.out.println( "server response:" );
		try {
			BufferedReader in = new BufferedReader(new InputStreamReader( sock.getInputStream() ) );
			String msg = in.readLine();		// blocking: server will close connection after sending msg, so can use readLine() here...
			in.close(); // note: this will also terminate the connection...
			if ( msg != null && msg.length() > 0 )
				System.out.println( "Received: " + msg );
			else
				throw new SocketException();
		} catch( SocketException e )
		{ System.out.println( "lost connection on recv" ); }

//		out.close();
		sock.close();
	}
}
FILE_END


# UDP
# ........................................


FILE_BEGIN: java_udp_server.java
HEADER
// java: UDP echo server
import java.net.DatagramSocket;
import java.net.DatagramPacket;
import java.net.InetAddress;

class java_udp_server
{
	public static void main(String args[]) throws Exception {
		String host = "localhost";
		int port = 51000;
		int maxsize = 1024;

//public DatagramSocket(int port) throws SocketException
//public DatagramSocket(int port, InetAddress laddr) throws SocketException
		DatagramSocket sock = new DatagramSocket( port, InetAddress.getByName( host ) );
		System.out.println( "server started on port" + port );

		byte[] data = new byte[maxsize];
		while(true) {
			DatagramPacket packet = new DatagramPacket( data, data.length );
			sock.receive( packet );			// blocking
			InetAddress addr = packet.getAddress();
			port = packet.getPort();
			if ( packet.getLength() > 0 ) {
				String msg = new String( packet.getData(), 0, packet.getLength() );
				System.out.println( "msg from: " + addr + ":" + port + " " + msg );
				sock.send( packet );		// [packet] already has remote address and port set
			} else
				System.out.println( "empty msg from: " + addr + ":" + port );
	}	}
}
FILE_END


# ........................................


FILE_BEGIN: java_udp_client.java
HEADER
// java: UDP echo client
import java.net.DatagramSocket;
import java.net.DatagramPacket;
import java.net.InetAddress;

class java_udp_client
{
	public static void main(String args[]) throws Exception {
		String host = "localhost";
		int port = 51000;
		
		DatagramSocket sock = new DatagramSocket();
		System.out.println( "sending msg to server..." );

		String msg = "Howdy";
		byte[] data = msg.getBytes();
		InetAddress addr =  InetAddress.getByName( host );
		DatagramPacket packet = new DatagramPacket( data, data.length, addr, port );
		sock.send( packet );

		System.out.println( "server response:" );
		sock.receive( packet );				// blocking
		sock.close();
		// note, this packet may not have come from the "server"
		addr = packet.getAddress();
		port = packet.getPort();
		if ( packet.getLength() > 0 ) {
			msg = new String( packet.getData(), 0, packet.getLength() );
			System.out.println( "msg from: " + addr + ":" + port + " " + msg );
		} else
			System.out.println( "empty msg from: " + addr + ":" + port );
	}
}
FILE_END


# SELECT
# http://www.java2s.com/Code/JavaAPI/java.nio.channels/SelectorselectedKeys.htm
# WARNING: JAVA Selector acts more like poll() when there's anything to process...
# ........................................


FILE_BEGIN: java_tcp_server_select.java
HEADER
// java: TCP chat server with select()
// entering ANY line of input will exit the server
import java.io.IOException;

import java.net.Socket;
import java.net.InetAddress;
import java.net.InetSocketAddress;

import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;

// see note about STDIN in main() below
// http://jcs.mobile-utopia.com/jcs/1928_SystemInPipe.java
//import java.nio.channels.SelectableChannel;
//import java.nio.channels.ReadableByteChannel;

import java.util.List;
import java.util.ArrayList;

class java_tcp_server_select extends Thread
{
	class Client_data
	{
		InetAddress addr;
		int port;
		SocketChannel channel;
	
		public Client_data( InetAddress a, int p, SocketChannel c ) {
			addr = a;
			port = p;
			channel = c;
		}
	}

	private Selector selector;
	private SelectionKey serverkey;
	private Boolean running;
	private List<Client_data> clients;
    private CharsetDecoder decoder;


	public static void main( String argv[] ) throws Exception {
		String host = "localhost";
		int port = 52000;

		// NOTE: "channel" and not just ServerSocket
		ServerSocketChannel server = ServerSocketChannel.open();
		InetAddress addr = InetAddress.getByName( host );
		InetSocketAddress iaddr = new InetSocketAddress( addr, port );
		server.socket().bind( iaddr );
		// WARNING: setting blocking to false means that the selector will
		// [ wake up when / trigger on ] "ANYTHING" is ready for processing.
		// i.e. it doesn't return a set of keys with "pending" data, but
		// rather all keys that has been registered.  in other words, all
		// keys needs to be polled (non-blocking) for any live (pending) data...
		server.configureBlocking( false );

		// Selector() does NOT return a list of "ready to read" objects...
		// instead, sockets (which needs to be set to non-blocking)
		// needs to be [ POLLED ] for any data.
		Selector selector = Selector.open();
		SelectionKey serverkey = server.register( selector, SelectionKey.OP_ACCEPT );
		System.out.println( "server started on port " + port );

		// STDIN: one possible way to make it a SelectableChannel
		// http://jcs.mobile-utopia.com/jcs/1928_SystemInPipe.java
//		SystemInPipe stdinPipe = new SystemInPipe();
//		SelectableChannel stdin = stdinPipe.getStdinChannel();
//		SelectionKey stdinkey = stdin.register( selector, SelectionKey.OP_READ );
//		stdinPipe.start();
		// but, trying to keep these cheatsheets runnable from the standard packages
		java_tcp_server_select networkThread = new java_tcp_server_select( selector, serverkey );
		networkThread.start();

		// think of the following as the main loop...
		System.console().readLine();		// blocking

		System.out.println( "shutting down server..." );
		// terminate any live threads -- or else program keeps running...
		networkThread.shutdown();

		// all client sockets are closed during networkThread.shutdown();
		server.close();
	}

	public java_tcp_server_select( Selector selector, SelectionKey serverkey ) {
		this.selector = selector;
		this.serverkey = serverkey;
		clients = new ArrayList<Client_data>();

		Charset charset = Charset.forName("ISO-8859-1");
		decoder = charset.newDecoder();

		running = true;
	}

	public void shutdown() {
		running = false;
		for ( Client_data client: clients )
			try { client.channel.close(); }
			catch( IOException e ) { System.out.println( "*** close socket error: " + e ); }
		clients.clear();
		interrupt();
	}

	public void run() {
		int maxsize = 1024;
		ByteBuffer data = ByteBuffer.allocate( maxsize );
		InetAddress addr;
		int port;
		String tosend;

		while( running ) {
			try { selector.select(); }		// blocking
			catch( IOException e ) { System.out.println( "*** selector select error: " + e ); }
			for ( SelectionKey key: selector.selectedKeys() ) {
				if ( key == serverkey ) {
					// handle the server socket
					if ( key.isAcceptable() ) {					// POLLING...
						ServerSocketChannel server = (ServerSocketChannel) key.channel();
						SocketChannel client;
						SelectionKey clientkey;
						try {
	/* throws */			client = server.accept();			// was set to non-blocking...
							if ( client == null )				// POLLING again...
								continue;
	/* throws */			client.configureBlocking( false );	// !!!
	/* throws */			clientkey = client.register( selector, SelectionKey.OP_READ );
						} catch( IOException e ) {
							System.out.println( "*** server socket error: " + e );
							continue;
						}
						addr = client.socket().getInetAddress();
						port = client.socket().getPort();
						Client_data c = new Client_data( addr, port, client );
						clients.add ( c );
						clientkey.attach( c );
						tosend = "connection from: " + addr + ":" + port;
						echo_and_send_to_clients( tosend );
					}
					continue;
				}

// if STDIN was a SelectableChannel
//				if ( key == stdinkey ) {
//					// handle standard input
//					ReadableByteChannel channel = (ReadableByteChannel) key.channel();
//					int count = channel.read( data );			// PENDING data:
//					key.cancel();
//					channel.close();
//					System.out.println( "shutting down server..." );
//					running = false;		// break while loop
//					break;					// break for loop
//				}

				// handle all other sockets
				SocketChannel client = (SocketChannel) key.channel();
				Client_data cdata = (Client_data) key.attachment();
				if ( key.isReadable() ) {						// POLLING...
					int bytesread;
					try { bytesread = client.read( data ); }	// was set to non-blocking...
					catch( IOException e ) {
						//System.out.println( "*** read socket error: " + e );

						// key.isReadable() will be false the "next" time around
						// however, pre-emptively force a close() "this" time around
						bytesread = -1;
					}
					if ( bytesread > 0 ) {						// POLLING again...
						data.flip();
						try {
	/* throws */			String msg = decoder.decode( data ).toString();
							tosend = "msg from " + cdata.addr + ":" + cdata.port + " " + msg;
							echo_and_send_to_clients( tosend );
						} catch( IOException e ) {
							System.out.println( "*** ByteBuffer decode error: " + e );
						}
						data.clear();
					}
					if ( bytesread >= 0 ) // 0 still means connection is still alive...
						continue;
				}
//				key.cancel(); // this will be automatically done when channel closes...
				try { client.close(); }
				catch( IOException e ) { System.out.println( "*** close socket error: " + e ); }
				clients.remove( cdata );
				tosend = "client leaving: " + cdata.addr;
				echo_and_send_to_clients( tosend );
	}	}	}

	private void echo_and_send_to_clients( String tosend ) {
		// DO NOT CACHE ByteBuffer
//		ByteBuffer data = ByteBuffer.wrap( tosend.getBytes() );
		// java clears the ByteBuffer data after channel.write() all the time...

		System.out.println( tosend );
		for ( Client_data client: clients ) {
//			try{ client.channel.write( data ); }				// sends even on a broken socket
			try{ client.channel.write( ByteBuffer.wrap( tosend.getBytes() ) ); }
			catch( IOException e ) { System.out.println( "*** write socket error: " + e ); }
	}	}
}
FILE_END


# ........................................


FILE_BEGIN: java_tcp_client_select.java
HEADER
// java: TCP chat client with select()
// entering ANY line of input will exit the server
// try this with more than one client...
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

import java.net.Socket;
import java.net.InetAddress;
import java.net.InetSocketAddress;

import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.channels.ClosedChannelException;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;

class java_tcp_client_select extends Thread
{
	private Boolean running = true;
	private SocketChannel channel;
	private Selector selector;
	private ByteBuffer data;
    private CharsetDecoder decoder;

	public static void main( String argv[] ) throws Exception {
		java_tcp_client_select demo = new java_tcp_client_select();
		demo.run();
	}

	public java_tcp_client_select() {
		String host = "localhost";
		int port = 52000;
		int maxsize = 1024;

		try { // everything here throws...
			InetAddress addr = InetAddress.getByName( host );
			channel = SocketChannel.open( new InetSocketAddress( addr, port ) );
			// WARNING: see server.configureBlocking() note in class java_tcp_server_select above
			channel.configureBlocking( false );

			// NOTE: see Selector() notes in class java_tcp_server_select above
			selector = Selector.open();
			SelectionKey sockkey = channel.register( selector, SelectionKey.OP_READ );
		} catch( IOException e ) {
			System.out.println( "socket error: " + e );
			return;
		}
		System.out.println( "connected to server" );

		System.out.print( "% " );
		System.out.flush();

		// spin off threads to prevent main loop from being blocked.
//		Thread keyboardThread = new Thread( keyboardWatcher() );
//		keyboardThread.start();
		// it seems that blocking reads cannot be interrupted
		// need to do this in a round about way...
		// http://www.javaspecialists.eu/archive/Issue153.html
		BufferedReader br = new BufferedReader( new InputStreamReader( System.in ) );

		Charset charset = Charset.forName("ISO-8859-1");
		decoder = charset.newDecoder();
		data = ByteBuffer.allocate( maxsize );
		while ( running ) {
			networkWatcher();				// polls
			keyboardWatcher( br );			// polls
			try { Thread.sleep( 100 ); }	// meh...
			catch( InterruptedException e ) { }
		}

		// terminate any live threads -- or else program keeps running...
//		keyboardThread.interrupt();

		try { channel.close(); } catch( IOException e ) { }
	}

	private void networkWatcher() {
		// using a non-blocking version of the selector
		try { selector.selectNow(); } catch( IOException e ) { }

		for ( SelectionKey key: selector.selectedKeys() ) {	// ITERATOR...
			SocketChannel channel = (SocketChannel) key.channel();
			// the following is not needed here, selector has been registered with only 1 channel
			//if ( key.isReadable() )
			int bytesread;
			try { bytesread = channel.read( data ); }		// was set to non-blocking...
			catch( IOException e ) {
				System.out.println( "*** read socket error: " + e );
				bytesread = 0;
			}
			if ( bytesread > 0 ) {			// POLLING...
				data.flip();
				try {
						String msg = decoder.decode( data ).toString();
						System.out.println( msg );
					} catch( IOException e ) {
						System.out.println( "*** ByteBuffer decode error: " + e );
					}
					System.out.print( "% " );
					System.out.flush();
				data.clear();
			}
			if ( bytesread >= 0 ) // 0 still means connection is still alive...
				continue;
		    System.out.println( "server has left the building..." );
			running = false;
	}	}

	// this is the "inlined" (during while loop above) version
	private void keyboardWatcher( BufferedReader br ) {
		try {
			if ( ! br.ready() )					// POLLING...
				return;
		} catch( IOException e ) {
			System.out.println( "*** BufferedReader error: " + e );
			return;
		}
		String msg;
		try { msg = br.readLine(); }
		catch( IOException e ) {
			System.out.println( "*** readLine error: " + e );
			return;
		}
		msg = msg.trim();
		if ( msg.length() != 0 ) {
			try{ channel.write( ByteBuffer.wrap( msg.getBytes() ) ); }
			catch( IOException e ) { System.out.println( "*** write socket error: " + e ); }
		} else {
			System.out.println( "leaving..." );
			running = false;
	}	}

	// keeping this here for reference...
	// this is the "threaded - runnable" version
//	private Runnable keyboardWatcher() {
//		return new Runnable() {
//			public void run() {
//				while( true ) {
//					String msg = System.console().readLine();	// blocking
//					msg = msg.trim();
//					if ( msg.length() != 0 ) {
//						try{ channel.write( ByteBuffer.wrap( msg.getBytes() ) ); }
//						catch( IOException e ) { System.out.println( "*** write socket error: " + e ); }
//						continue;
//					}
//					System.out.println( "leaving..." );
//					running = false;
//					return;
//	}	}	};	}
}
FILE_END


SKIP_START
# note: "event based" network IO - based on the documentation from:
# http://www.cs.uiuc.edu/class/fa07/cs438/slides/CS438-03.JavaNetworking.pdf
# this is really a threaded socket handler in disguise with a lot of
# unnecessary "callback" function jumping back n forth...
#
# keeping this here for reference...
# ........................................


FILE_BEGIN: java_tcp_server_select_alt.java
HEADER
// java: TCP chat server with select() alternative...
// entering ANY line of input will exit the server
import java.io.*;
import java.net.*;
import java.util.*;

class java_tcp_server_select_alt
{
	class Client_data
	{
		Socket sock;
	
		public Client_data( Socket s ) {
			sock = s;
		}
	}

	private List<ServerListener> listeners;
//	private IOThread loop;
	private ServerSocket sock;

	// --------------------
	public static void main( String argv[] ) throws Exception {
		java_tcp_server_select_alt demo = new java_tcp_server_select_alt();
		demo.demo();
	}

	public void demo() {
//		String host = "localhost";
//		int port = 52000;

// put threaded keyboardWatcher here...
//		IOThread loop = new IOThread();
//		loop.start();

		// "the" event trigger
////		java_tcp_server_select_alt c = new java_tcp_server_select_alt( loop, host, port );
//		java_tcp_server_select_alt c = new java_tcp_server_select_alt();
//		s.addListener( new ServerListener() /* "the" event handler */ );
//		s.startAccepting();

		addListener( new ServerListener() /* "the" event handler */ );
		startAccepting();
	}
	// --------------------

	// event trigger
//	public java_tcp_server_select_alt( IOThread loop, String host, int port ) {
	public java_tcp_server_select_alt() {
		listeners = new ArrayList<ServerListener>();
	}

	public synchronized void addListener( ServerListener cl ) {
		listeners.add( cl );
	}
	
	public synchronized void removeListener( ServerListener cl ) {
		listeners.remove( cl );
	}

	public void startAccepting() {
		// "the" event object
		Socket client = null; // sock.accept();
		Client_data c = new Client_data( client );
//		ServerEvent s = new ServerEvent( this, sock );
		for ( ServerListener sl: listeners )
			sl.clientConnectCallback( c );
	}

	// --------------------
	// event handler + trigger interface
	public interface ServerCallbacks {
		public void clientConnectCallback( Client_data c );
		public void clientDisconnectCallback( Client_data c );
		public void readCallback( Client_data c, byte[] data );
	}

	// --------------------
	// event handler
	public class ServerListener implements ServerCallbacks {
		public void clientConnectCallback( Client_data c ) {
			// a new client has connected
			// initialize any client context
		    System.out.println( "clientConnectCallback triggered..." );
		}

		public void clientDisconnectCallback( Client_data c ) {
			// the client disconnected. cleanup
		}

		public void readCallback( Client_data c, byte[] data ) {
			// client sent some data, can do something now.
			// but what if it’s not a whole message?
			// what if it’s three messages?
		}
	}

	// --------------------
	// event object
	// this is traditionally used when writting event based programming
	// "source" can be obtained via getsource() -- which in this case
	// would return the event trigger object (class java_tcp_client_select_alt)
	// during the event handler functions (class ClientListener )
//	public class ServerEvent extends EventObject {
//		Socket sock;
//		public ServerEvent( Object source, Socket s ) {
//			super(source);
//			sock = s;
//		}
//	}
}
FILE_END


# ........................................


FILE_BEGIN: java_tcp_client_select_alt.java
HEADER
// java: TCP chat client with select() alternative...
// entering ANY line of input will exit the server
// try this with more than one client...
import java.io.*;
import java.net.*;
import java.util.*;

class java_tcp_client_select_alt
{
	private List<ClientListener> listeners;
//	private IOThread loop;

	// --------------------
	public static void main( String argv[] ) throws Exception {
		java_tcp_client_select_alt demo = new java_tcp_client_select_alt();
		demo.demo();
	}

	public void demo() {
//		String host = "localhost";
//		int port = 52000;

// put threaded keyboardWatcher here...
//		IOThread loop = new IOThread();
//		loop.start();

		// "the" event trigger
////		java_tcp_client_select_alt c = new java_tcp_client_select_alt( loop, host, port );
//		java_tcp_client_select_alt c = new java_tcp_client_select_alt();
//		c.addListener( new ClientListener() /* "the" event handler */ );
//		c.startConnect(); // asynchronous

		addListener( new ClientListener() /* "the" event handler */ );
		startConnect(); // asynchronous
	}
	// --------------------

	// event trigger
//	public java_tcp_client_select_alt( IOThread loop, String host, int port ) {
	public java_tcp_client_select_alt() {
		listeners = new ArrayList<ClientListener>();
	}

	public synchronized void addListener( ClientListener cl ) {
		listeners.add( cl );
	}
	
	public synchronized void removeListener( ClientListener cl ) {
		listeners.remove( cl );
	}

	public void startConnect() {
		// "the" event object
//		ClientEvent clientEvent = new ClientEvent( this, sock );
		for ( ClientListener sl: listeners )
//			sl.connectCallback( clientEvent );
			sl.connectCallback();
	}
	
	// seems a read socket watcher is needed here and then
	// readCallback() would be called on success else a
	// disconnectCallabck()...
	//
	// the keyboardWatcher would do the send and then call sendDone()...

	// --------------------
	// event handler + trigger interface
	public interface ClientCallbacks {
		public void connectCallback();
		public void disconnectCallback();
		public void readCallback( byte[] data );
		public void sendDone();
	}

	// --------------------
	// event handler
	public class ClientListener implements ClientCallbacks {
		public void connectCallback() {
			// connection is established, send login data
			// or first message
		    System.out.println( "connectCallback triggered..." );
		}

		public void disconnectCallback() {
			// the server disconnected. what can we do
			// other than log an error?
		}

		public void readCallback(byte[] data) {
			// data arrived, can do something now.
			// but what if it’s not a whole message?
			// what if it’s three messages?
		}

		public void sendDone() {
			// in case you’re wondering
		}
	}

	// --------------------
	// event object
	// this is traditionally used when writting event based programming
	// "source" can be obtained via getsource() -- which in this case
	// would return the event trigger object (class java_tcp_client_select_alt)
	// during the event handler functions (class ClientListener )
//	public class ClientEvent extends EventObject {
//		Socket sock;
//		public ClientEvent( Object source, Socket s ) {
//			super(source);
//			sock = s;
//		}
//	}
}
FILE_END
SKIP_END


# Java }}}
# Node.js {{{
# --------------------------------------------------------------------------------


# TCP
# ........................................


FILE_BEGIN: node_tcp_server.js
HEADER
// Node.js: TCP echo server - 'pipe'
"use strict";

var net = require('net');
var server = net.createServer(function (socket) {
  console.log( "connection from: " + socket.remoteAddress + ":" + socket.remotePort );
  socket.saveRemote = { addr:socket.remoteAddress, port:socket.remotePort };
  socket.on('end', function() {
    console.log('lost connection on ' + socket.saveRemote.addr + ':' + socket.saveRemote.port);
    socket.end();
  });
  socket.pipe(socket);
});
server.listen(50000,function(){
  var address = server.address();
  console.log( "server started on port "+ address.port );
});
FILE_END


FILE_BEGIN: node_tcp_client.js
HEADER
// Node.js: TCP echo client - 'canned'
"use strict";

var client = require('net').Socket();
client.connect({port:50000,host:'localhost'}, function(){
  client.write('Howdy');
});
client.on('error', function(err){
  console.log('socket error: ' + err);
  client.end();
});
client.on('data', function(data){
  console.log(data.toString());
  client.end();
});
FILE_END


# UDP
# ........................................


FILE_BEGIN: node_udp_server.js
HEADER
// Node.js: UDP echo server - 'on("some_event")'
"use strict";

var dgram = require("dgram");
var server = dgram.createSocket("udp4");

server.on("message", function (msg, rinfo) {
  console.log("msg from: " + rinfo.address + ":" + rinfo.port + " " + msg);
  server.send(msg, 0, msg.length, rinfo.port, rinfo.address, function(err, bytes) {
    // ignore if sender is not listening anymore...
  });
});

server.on("listening", function () {
  var address = server.address();
  console.log("server listening " + address.address + ":" + address.port);
});

server.bind(51000, 'localhost');
FILE_END


FILE_BEGIN: node_udp_client.js
HEADER
// Node.js: UDP echo client -- 'canned'
"use strict";

var dgram = require('dgram');
var message = new Buffer("Howdy");
var client = dgram.createSocket("udp4");

console.log('sending msg to server...');
client.send(message, 0, message.length, 51000, "localhost", function(err, bytes) {
    // do nothing for now...
});

client.on("message", function (msg, rinfo) {
  console.log('server response:');
  console.log("msg from: " + rinfo.address + ":" + rinfo.port + " " + msg);
  client.close();
});
FILE_END


# TCP
# ........................................


FILE_BEGIN: node_tcp_server_chat.js
HEADER
// Node.js: TCP chat server
"use strict";

var net = require('net');
var clients = {};
var server = net.createServer(function (socket) {
  var addr = socket.remoteAddress + ":" + socket.remotePort;
  socket.addr = addr;
  clients[addr] = socket;
  var msg = "connection from: " + addr;
  console.log( msg );
  for ( var i in clients ) {
    var client = clients[i];
    client.write( msg );
  }
  socket.on('end', function() {
    delete clients[socket.addr];
    console.log('client leaving: ' + socket.addr );
  });
  socket.on('data', function(data) {
    var d = '[' + socket.addr + '] ' + data;
    for ( var i in clients ) {
      var client = clients[i];
      client.write( d );
    }
  });
});
server.listen(52000,function(){
  console.log( "server started on port "+ server.address().port );
});
process.stdin.on('readable', function(){
  var chunk = process.stdin.read();
  if (chunk !== null) {
    console.log( "shutting down server..." );
    process.exit();
  }
});
FILE_END


FILE_BEGIN: node_tcp_client_chat.js
HEADER
// Node.js: TCP chat client
"use strict";

var client = require('net').Socket();
client.connect({ port:52000, host:'localhost' }, function() { //'connect' listener
  console.log('connected to server...');
});
client.on('error', function(err){
  console.log('socket error: ' + err);
  client.end();
});
client.on('close', function(){
  console.log( "server has left the building..." );
  process.exit();
});

//client.pipe(process.stdout); // this does not make it easy to add a newline...
client.on('data', function(data){
  console.log(''+data); // note type coercion, data is Buffer() object
  process.stdout.write('% ');
});

process.stdin.on('readable', function() {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    var msg = chunk.toString();
    msg = msg.replace(/(\n|\r)+$/, ''); // chomp()
    if ( msg == '' ) {
      console.log('leaving....');
      process.exit();
    }
    client.write( msg );
    process.stdout.write('% ');
  }
});
process.stdout.write('% ');
FILE_END


# Node.js }}}
# Perl {{{
# --------------------------------------------------------------------------------


# TCP
# ........................................


FILE_BEGIN: perl_tcp_server.pl
#!/usr/bin/perl -w

HEADER
# perl: TCP echo server - plain ol Socket
use strict;
use Socket;

my $host = 'localhost';
my $port = 50000;
my $backlog = 5;
my $maxsize = 1024;
my $proto = getprotobyname('tcp');

socket( SOCK, PF_INET, SOCK_STREAM, $proto ) || die "socket error: $!\n";
setsockopt( SOCK, SOL_SOCKET, SO_REUSEADDR, 1 ) || die "socket option SO_REUSEADDR error: $!\n";

# if host has more than one NIC/IPaddresses
#my $addr = inet_aton( '127.0.0.1' );
#my $addr = INADDR_ANY; # a.k.a. inet_aton( '0.0.0.0' );
my $addr = gethostbyname( $host ); # note: inet_aton( $host ) also works...

my $local_addr = sockaddr_in( $port, $addr );
bind( SOCK, $local_addr ) || die "unable to bind to port $port $!\n";
listen( SOCK, $backlog ) || die "listen error: $!\n";
print "server started on port $port\n";

my $msg;
while ( my $client_addr = accept( NEW_SOCK, SOCK ) ) {	# blocking
	my ( $client_port, $client_ip ) = sockaddr_in( $client_addr );
	my $dotted_quad = inet_ntoa( $client_ip );
	my $client_host = gethostbyaddr( $client_ip, AF_INET );

	# note: perl cookbook shows the following examples, but <> will block until
	# the socket is terminated, which is too late to send a response back...
	# also, <> sometimes looks like it can be used AFTER a recv() or a send() was used first,
	# BUT, the code does not reliably continue properly -- so DO NOT READ from <>
#	if ( defined $msg = <NEW_SOCK> )
#	$msg = <NEW_SOCK>;
	my $sock = recv( NEW_SOCK, $msg, $maxsize, 0 );		# blocking: $msg will be cleared if fail recv
	if ( $msg ) {
		print "connection from: [$client_host] $dotted_quad:$client_port $msg\n";
		# DO NOT PRINT to a network handle for the same reasons ( do not read from <> ) as noted above ...
#		print NEW_SOCK $msg;				# send msg
		send( NEW_SOCK, $msg, 0 );			# sends even on a broken socket
	} else
	{ print "lost connection on recv: $dotted_quad:$client_port\n"; }
	close NEW_SOCK;
}
FILE_END


FILE_BEGIN: perl_tcp_client.pl
#!/usr/bin/perl -w

HEADER
# perl: TCP echo client - plain ol Socket
use strict;
use Socket;

my $host = 'localhost';
my $port = 50000;
my $maxsize = 1024;
my $proto = getprotobyname('tcp');

socket( SOCK, PF_INET, SOCK_STREAM, $proto ) || die "socket error: $!\n";

my $remote_ip = gethostbyname( $host );
my $remote_addr = sockaddr_in( $port, $remote_ip );
connect( SOCK, $remote_addr ) || die "unable to connect to $remote_addr $!\n";
print "connected to server, sending msg...\n";

send( SOCK, 'Howdy', 0 );					# sends even on a broken socket

print "server response:\n";
my $msg;
recv( SOCK, $msg, $maxsize, 0 );			# blocking: $msg will be cleared if fail recv
close SOCK;
if ( $msg )
{ print "Received: $msg\n"; }
else
{ print "lost connection on recv\n"; }
FILE_END


# ........................................


FILE_BEGIN: perl_tcp_server2.pl
#!/usr/bin/perl -w

HEADER
# perl: TCP echo server - using IO::Socket
use strict;
use IO::Socket;

my $host = 'localhost';
my $port = 50000;
my $backlog = 5;
my $maxsize = 1024;

my $sock = new IO::Socket::INET (
	LocalHost => $host,		# if omitted, will bind to INADDR_ANY
	LocalPort => $port,
	Proto => 'tcp',
	Listen => $backlog,
	Reuse => 1
) || die "socket error: $!\n";
print "server started on port $port\n";

my $msg;
while ( my $client_sock = $sock->accept ) {	# blocking
	my $addr = $client_sock->peerhost . ':'. $client_sock->peerport;

	$client_sock->recv( $msg, $maxsize );	# blocking: $msg will be cleared if fail recv
	if ( $msg ) {
		print "connection from: $addr $msg\n";
		$client_sock->send( $msg );			# sends even on a broken socket
	} else
	{ print "lost connection on recv: $addr\n"; }
	close $client_sock;
}
FILE_END


FILE_BEGIN: perl_tcp_client2.pl
#!/usr/bin/perl -w

HEADER
# perl: TCP echo client - using IO::Socket
use strict;
use IO::Socket;

my $host = 'localhost';
my $port = 50000;
my $maxsize = 1024;

my $sock = new IO::Socket::INET (
	PeerAddr  => $host,
	PeerPort  => $port,
	Proto => 'tcp',
) || die "socket error: $!\n";
print "connected to server, sending msg...\n";

$sock->send( 'Howdy' );						# sends even on a broken socket

print "server response:\n";
my $msg;
$sock->recv( $msg, $maxsize );				# blocking: $msg will be cleared if fail recv
close $sock;
if ( $msg )
{ print "Received: $msg\n"; }
else
{ print "lost connection on recv\n"; }
FILE_END


# UDP
# ........................................


FILE_BEGIN: perl_udp_server.pl
#!/usr/bin/perl -w

HEADER
# perl: UDP echo server - plain ol Socket
use strict;
use Socket;

my $host = 'localhost';
my $port = 51000;
my $maxsize = 1024;
my $proto = getprotobyname('udp');

socket( SOCK, PF_INET, SOCK_DGRAM, $proto ) || die "socket error: $!\n";
my $addr = gethostbyname( $host );
my $local_addr = sockaddr_in( $port, $addr );
bind( SOCK, $local_addr ) || die "unable to bind to port $port $!\n";
print "server started on port $port\n";

my $msg;
while( my $client_addr = recv( SOCK, $msg, $maxsize, 0 ) ) { # blocking
	my ( $client_port, $client_ip ) = sockaddr_in( $client_addr );
	my $dotted_quad = inet_ntoa( $client_ip );
	if ( $msg ) {
		print "msg from: $dotted_quad:$client_port $msg\n";
		send( SOCK, $msg, 0, $client_addr );	# sends even on a non-opened port
	} else
	{ print "empty msg from: $dotted_quad:$client_port\n"; }
}
FILE_END


FILE_BEGIN: perl_udp_client.pl
#!/usr/bin/perl -w

HEADER
# perl: UDP echo client -- plain ol Socket
use strict;
use Socket;

my $host = 'localhost';
my $port = 51000;
my $maxsize = 1024;
my $proto = getprotobyname('udp');

socket( SOCK, PF_INET, SOCK_DGRAM, $proto ) || die "socket error: $!\n";
print "sending msg to server...\n";

my $remote_ip = gethostbyname( $host );
my $remote_addr = sockaddr_in( $port, $remote_ip );
send( SOCK, 'Howdy', 0, $remote_addr );		# sends even on a non-opened port

print "server response:\n";
my $msg;
$remote_addr = recv( SOCK, $msg, $maxsize, 0 );	# blocking
close SOCK;
# note, this msg may not have come from the "server"
( my $remote_port, $remote_ip ) = sockaddr_in( $remote_addr );
my $dotted_quad = inet_ntoa( $remote_ip );
if ( $msg )
{ print "msg from: $dotted_quad:$remote_port $msg\n"; }
else
{ print "empty msg from: $dotted_quad:$remote_port\n"; }
FILE_END


# ........................................


FILE_BEGIN: perl_udp_server2.pl
#!/usr/bin/perl -w

HEADER
# perl: UDP echo server - using IO::Socket
use strict;
use IO::Socket;

my $port = 51000;
my $maxsize = 1024;

my $sock = new IO::Socket::INET (
	# binding to INADDR_ANY
	LocalPort => $port,
	Proto => 'udp'
) || die "socket error: $!\n";
print "server started on port $port\n";

my $msg;
while( $sock->recv( $msg, $maxsize ) ) {	# blocking
	my $addr = $sock->peerhost . ':'. $sock->peerport;
	if ( $msg ) {
		print "msg from: $addr $msg\n";
		$sock->send( $msg );				# sends even on a non-opened port
	} else
	{ print "empty msg from: $addr\n"; }
}
FILE_END


FILE_BEGIN: perl_udp_client2.pl
#!/usr/bin/perl -w

HEADER
# perl: UDP echo client -- using IO::Socket
use strict;
use IO::Socket;

my $host = 'localhost';
my $port = 51000;
my $maxsize = 1024;

my $sock = new IO::Socket::INET (
	PeerAddr => $host,
	PeerPort => $port,
	Proto => 'udp'
) || die "socket error: $!\n";
print "sending msg to server...\n";

$sock->send( 'Howdy' );						# sends even on a non-opened port

print "server response:\n";
my $msg;
$sock->recv( $msg, $maxsize );				# blocking
# note, this msg may not have come from the "server"
my $addr = $sock->peerhost . ':'. $sock->peerport;
close $sock;
if ( $msg )
{ print "msg from: $addr $msg\n"; }
else
{ print "empty msg from: $addr\n"; }
FILE_END


# SELECT
# http://perldoc.perl.org/IO/Select.html
# ........................................


FILE_BEGIN: perl_tcp_server_select.pl
#!/usr/bin/perl -w

HEADER
# perl: TCP chat server with select()
# entering ANY line of input will exit the server
use strict;
use IO::Socket;
use IO::Select;

my $host = 'localhost';
my $port = 52000;
my $backlog = 5;
my $maxsize = 1024;

my $sock = new IO::Socket::INET (
	LocalHost=> $host,
	LocalPort=> $port,
	Proto => 'tcp',
	Listen => $backlog,
	Reuse => 1
) || die "socket error: $!\n";
my $sel = new IO::Select( $sock );
print "server started on port $port\n";

$sel->add( \*STDIN );
my @ready = ();
my %clients = ();
my $msg = '';
my $tosend = '';
my $addr;
SELECT: while ( @ready = $sel->can_read ) {	# blocking
	foreach my $s ( @ready ) {

		if ( $s == $sock ) { # handle the server socket
			my $client = $s->accept;		# PENDING data:
			$sel->add( $client );
			$addr = $client->peerhost . ':' . $client->peerport;
			# perl doesn't like keys anything other than text...
			$clients{ $addr } = $client;
			$tosend = 'connection from: ' . $addr;
			print $tosend . "\n";
#			foreach ( $sel->can_write )		# WARNING: STDIN is in here...
			foreach ( values %clients )
			{ $_->send( $tosend ); }		# sends even on a broken socket
			next;
		}

		if ( $s == \*STDIN ) { # handle standard input
			print "shutting down server...\n";
			last SELECT;
		}

		# handle all other sockets
		$s->recv( $msg, $maxsize );			# PENDING data: $msg will be cleared if fail recv
		# if socket terminated abonormally,
		#     $s->peerhost & $s->peerport will be NULL
		#     and the following line will FAIL:
		# $addr = $s->peerhost . ':' . $s->peerport;
		# do this the long way:
		while ( my ( $key, $value ) = each %clients ) {
			next if ( $value != $s );
			$addr = $key;
			last;
		}
		if ( $msg ) {
			$tosend = "[$addr] $msg";
			print $tosend . "\n";
			foreach ( values %clients )
			{ $_->send( $tosend ); }		# sends even on a broken socket
			next;
		}
		$tosend = "client leaving: $addr";
		delete $clients{ $addr };
		$sel->remove( $s );
		$s->close;
		print $tosend . "\n";
		foreach ( values %clients )
		{ $_->send( $tosend ); }			# sends even on a broken socket
	}
}

foreach ( values %clients )
{ $_->close; }
$sock->close;
FILE_END


FILE_BEGIN: perl_tcp_client_select.pl
#!/usr/bin/perl -w

HEADER
# perl: TCP chat client with select()
# entering ANY line of input will exit the server
# try this with more than one client...
use strict;
use IO::Socket;
use IO::Select;

$|++;	# turn on auto flush

my $host = 'localhost';
my $port = 52000;
my $maxsize = 1024;

my $sock = new IO::Socket::INET (
	PeerAddr  => $host,
	PeerPort  => $port,
	Proto => 'tcp',
) || die "socket error: $!\n";
my $sel = new IO::Select( $sock );
print "connected to server...\n";

print '% ';

$sel->add( \*STDIN );
my @ready = ();
my $msg = '';
SELECT: while ( @ready = $sel->can_read ) {	# blocking
	foreach my $client ( @ready ) {
		if ( $client == \*STDIN ) {
			$msg = <>;
			chomp $msg;
			if ( $msg eq '' ) {
				print "leaving....\n";
				last SELECT;
			}
			$sock->send( $msg );			# sends even on a broken socket
			next;
		}

		$client->recv( $msg, $maxsize );	# PENDING data: $msg will be cleared if fail recv
		if ( $msg ) {
			print $msg . "\n% ";
			next;
		}
		print "server has left the building...\n";
		last SELECT;
}	}
$sock->close;
FILE_END


# Perl }}}
# Python {{{
# --------------------------------------------------------------------------------


# TCP
# ........................................


FILE_BEGIN: python_tcp_server.py
#!/usr/bin/python

HEADER
# python: TCP echo server
import socket
import sys

host, port = 'localhost', 50000
backlog = 5
maxsize = 1024

# if host has more than one NIC/IPaddresses
#addr = '127.0.0.1';
addr = host;

try:
	sock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
except socket.error, msg:
	print 'socket error:', msg
	sys.exit(1)
try:
	sock.setsockopt( socket.SOL_SOCKET, socket.SO_REUSEADDR, 1 )
	sock.bind( ( addr, port ) )
	sock.listen( backlog )
except socket.error, msg:
	sock.close()
	print 'unable to bind to port :', port, ' ', msg
	sys.exit(1)
print 'server started on port ', port

while 1:
	client, address = sock.accept()			# blocking
#	client, ( addr, port ) = sock.accept()
	msg = client.recv( maxsize )			# blocking
	if msg:
		print 'connection from: ', address, ' ', msg
		client.send( msg )					# sends even on a broken socket
	else:
		print 'lost connection on recv: ', address
	client.close()
FILE_END


# ........................................


FILE_BEGIN: python_tcp_client.py
#!/usr/bin/python

HEADER
# python: TCP echo client
import socket
import sys

host, port = 'localhost', 50000
maxsize = 1024

try:
	sock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
except socket.error, msg:
	print 'socket error:', msg
	sys.exit(1)
try:
	sock.connect( ( host, port ) )
except socket.error, msg:
	sock.close()
	print 'unable to connect to ', host, ':', port, ' ', msg
print 'connected to server, sending msg...'

sock.send( 'Howdy' )						# sends even on a broken socket

print 'server response:'
msg = sock.recv( maxsize )					# blocking
sock.close()
if msg:
	print 'Received: ', msg
else:
	print 'lost connection on recv'
FILE_END


# UDP
# http://www.ibm.com/developerworks/linux/tutorials/l-pysocks/section4.html
# ........................................


FILE_BEGIN: python_udp_server.py
#!/usr/bin/python

HEADER
# python: UDP echo server
import socket
import sys

host, port = 'localhost', 51000
maxsize = 1024

try:
	sock = socket.socket( socket.AF_INET, socket.SOCK_DGRAM )
except socket.error, msg:
	print 'socket error:', msg
	sys.exit(1)
try:
	sock.bind( ( host, port ) )
except socket.error, msg:
	sock.close()
	print 'unable to bind to port :', port, ' ', msg
	sys.exit(1)
print 'server started on port ', port

while 1:
	msg, (addr, port) = sock.recvfrom( maxsize ) # blocking
	if msg:
		print 'msg from: ', addr, ':', port, ' ', msg
		sock.sendto( msg, (addr, port) )	# sends even on a non-opened port
	else:
		print 'empty msg from: ', addr, ':', port
FILE_END


# ........................................


FILE_BEGIN: python_udp_client.py
#!/usr/bin/python

HEADER
# python: UDP echo client
import socket
import sys

host, port = 'localhost', 51000
maxsize = 1024

try:
	sock = socket.socket( socket.AF_INET, socket.SOCK_DGRAM )
except socket.error, msg:
	print 'socket error:', msg
	sys.exit(1)
print 'sending msg to server...'

sock.sendto( 'Howdy', ( host, port ) )		# sends even on a non-opened port

print 'server response:'
# note, this msg may not have come from the "server"
msg, (addr, port) = sock.recvfrom( maxsize ) # blocking
sock.close()
if msg:
	print 'msg from: ', addr, ':', port, ' ', msg
else:
	print 'empty msg from: ', addr, ':', port
FILE_END


# SELECT
# http://ilab.cs.byu.edu/python/selectmodule.html
# ........................................


FILE_BEGIN: python_tcp_server_select.py
#!/usr/bin/env python

HEADER
"""
python: TCP chat server with select()
entering ANY line of input will exit the server
"""

import select
import socket
import sys

host, port = 'localhost', 52000
backlog = 5
maxsize = 1024

try:
	sock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
except socket.error, msg:
	print 'socket error:', msg
	sys.exit(1)
try:
	sock.bind( ( host, port ) )
	sock.listen( backlog )
except socket.error, msg:
	sock.close()
	print 'unable to bind to port :', port, ' ', msg
	sys.exit(1)
print 'server started on port ', port

input = [ sock, sys.stdin ]
clients = {}
running = 1
while running:
	inputready, outputready, exceptready = select.select( input, [], [] )

	for s in inputready:
	
		if s == sock:
			# handle the server socket
			client, address = sock.accept()	# PENDING data:
			input.append( client )
			clients[ client ] = address
			tosend = 'connection from: ' + str( address )
			print tosend
			for c in clients:
				c.send( tosend )			# sends even on a broken socket

		elif s == sys.stdin:
			# handle standard input
			junk = sys.stdin.readline()
			print 'shutting down server...'
			running = 0						# break while loop
			break							# break for loop

		else:
			# handle all other sockets
			try:
				msg = s.recv( maxsize )		# PENDING data:
				# on listening socket during select(), if remote socket terminated abonormally,
				#     recv() will actually raise an exception
				#     and the following line will FAIL
				# addr = str( s.getpeername() )
			except:
				msg = 0
			addr = str( clients[ s ] )

			if msg:
				tosend = 'msg from ' + addr + ': ' + msg
				print tosend
				for c in clients:
					c.send( tosend )		# sends even on a broken socket
			else:
				tosend = 'client leaving: ' + addr
				input.remove( s )
				del clients[ s ]
				s.close()
				print tosend
				for c in clients:
					c.send( tosend )		# sends even on a broken socket

for c in clients:
	c.close()
sock.close()
FILE_END


# ........................................


FILE_BEGIN: python_tcp_client_select.py
#!/usr/bin/env python

HEADER
"""
python: TCP chat client with select()
entering ANY line of input will exit the server
try this with more than one client...
"""

import select
import socket
import sys

host, port = 'localhost', 52000
maxsize = 1024

try:
	sock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
except socket.error, msg:
	print 'socket error:', msg
	sys.exit(1)
try:
	sock.connect( ( host, port ) )
except socket.error, msg:
	sock.close()
	print 'unable to connect to ', host, ':', port, ' ', msg
print 'connected to server...'

print '% ',
sys.stdout.flush()

input = [ sock, sys.stdin ]
running = 1
while running:
	inputready, outputready, exceptready = select.select( input, [], [] )

	for s in inputready:

		if s == sys.stdin:
			line = sys.stdin.readline().strip("\n\r")
			if line == '':
				print 'leaving....'
				running = 0					# break while loop
				break						# break for loop
			sock.send( line )				# sends even on a broken socket

		else:
			msg = sock.recv( maxsize )		# PENDING data:
			if msg:
				print msg
				print '% ',
				sys.stdout.flush()
			else:
				print 'server has left the building...'
				running = 0					# break while loop
				break						# break for loop

sock.close()
FILE_END


# Python }}}
# Ruby {{{
# --------------------------------------------------------------------------------


# TCP
# ........................................


FILE_BEGIN: ruby_tcp_server.rb
#!/usr/bin/ruby

HEADER
# ruby: TCP echo server
require 'socket'

host, port = 'localhost', 50000
backlog = 5
maxsize = 1024

# if host has more than one NIC/IPaddresses
#addr = '127.0.0.1';
addr = host;

sock = TCPServer::new( addr, port )
sock.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1 )
sock.listen( backlog )
puts "server started on port #{port}"

while 1
	s = sock.accept							# blocking
	msg = s.recv( maxsize )					# blocking: $msg will be cleared if fail recv
	port = s.peeraddr[1]
    name = s.peeraddr[2]
    addr = s.peeraddr[3]
	if msg.length != 0
		puts "connection from: [#{name}] #{addr}:#{port} #{msg}"
		s.write( msg )						# sends even on a broken socket
	else
		puts "lost connection on recv: [#{name}] #{addr}:#{port}"
	end
	s.close
end
FILE_END


FILE_BEGIN: ruby_tcp_client.rb
#!/usr/bin/ruby

HEADER
# ruby: TCP echo client
require 'socket'

host, port = 'localhost', 50000
maxsize = 1024

sock = TCPSocket::new( host, port )
puts 'connected to server, sending msg...'

sock.write( 'Howdy' )						# sends even on a broken socket

puts 'server response:'
msg = sock.recv( maxsize )					# blocking: $msg will be cleared if fail recv
sock.close
if msg.length != 0
	puts "Received: #{msg}"
else
	puts 'lost connection on recv'
end
FILE_END


# UDP
# ........................................


FILE_BEGIN: ruby_udp_server.rb
#!/usr/bin/ruby

HEADER
# ruby: UDP echo server
require 'socket'

host, port = 'localhost', 51000
maxsize = 1024

sock = UDPSocket::new
sock.bind( host, port )
puts "server started on port #{port}"

while 1
	msg, from = sock.recvfrom( maxsize )	# blocking: $msg will be cleared if fail recv
	port = from[1]
    name = from[2]
    addr = from[3]
	if msg.length != 0
		puts "msg from: [#{name}] #{addr}:#{port} #{msg}"
		sock.send( msg, 0, name, port )		# sends even on a non-opened port
	else
		puts "empty msg from: [#{name}] #{addr}:#{port}"
	end
end
FILE_END


FILE_BEGIN: ruby_udp_client.rb
#!/usr/bin/ruby

HEADER
# ruby: UDP echo client
require 'socket'

host, port = 'localhost', 51000
maxsize = 1024

sock = UDPSocket::new
sock.connect( host, port )
puts 'sending msg to server...'

sock.send( 'Howdy', 0 )						# sends even on a non-opened port

puts 'server response:'
msg, from = sock.recvfrom( maxsize, 0 )		# blocking: $msg will be cleared if fail recv
sock.close
# note, this msg may not have come from the "server"
port = from[1]
name = from[2]
addr = from[3]
if msg.length != 0
	puts "msg from: [#{name}] #{addr}:#{port} #{msg}"
else
	puts 'empty msg from: [#{name}] #{addr}:#{port}'
end
FILE_END


# SELECT
# ........................................


FILE_BEGIN: ruby_tcp_server_select.rb
#!/usr/bin/ruby

HEADER
# ruby: TCP chat server with select()
# entering ANY line of input will exit the server
require 'socket'

host, port = 'localhost', 52000
backlog = 5
maxsize = 1024

sock = TCPServer::new( host, port )
sock.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1 )
sock.listen( backlog )
puts "server started on port #{port}"

input = [ sock, STDIN ]
clients = {}
running = true
while running
	result = select( input, nil, nil )
	for s in result[0]
		if s == sock
			# handle the server socket
			client = sock.accept						# PENDING data:
			port = client.peeraddr[1]
			name = client.peeraddr[2]
			addr = client.peeraddr[3]
			input.insert( -1, client )
			clients[ client ] = "#{addr}:#{port}";
			tosend = "connection from: #{addr}:#{port}"
			puts tosend
			clients.each { |c,v| c.write( tosend ) }	# sends even on a broken socket

		elsif s == STDIN
			# handle standard input
			junk = STDIN.gets
			puts 'shutting down server...'
			running = false								# break while loop
			break										# break for loop

		else
			# handle all other sockets
			begin
				msg = s.recv( maxsize )					# PENDING data:
				# on listening socket during select(), if socket terminated abonormally,
				#     recv() will actually raise an exception
				# also, s.addr[1] thru s.addr[3] will be set to NULL
				#     and the following will FAIL
				# addr = "#{s.addr[3]}:#{s.addr[1]}"
			rescue
				msg = ""
			end
			addr = clients[s]
			if msg.length != 0
				tosend = "msg from #{addr} #{msg}"
				puts tosend
				clients.each { |c,v| c.write( tosend ) }	# sends even on a broken socket
			else
				tosend = "client leaving: #{addr}"
				input.delete( s )
				clients.delete( s )
				s.close
				puts tosend
				clients.each { |c,v| c.write( tosend ) }	# sends even on a broken socket
			end
		end
	end
end
clients.each { |c,v| c.close }
sock.close
FILE_END


FILE_BEGIN: ruby_tcp_client_select.rb
#!/usr/bin/ruby

HEADER
# ruby: TCP chat client with select()
# entering ANY line of input will exit the server
# try this with more than one client...
require 'socket'

STDOUT.sync = true	# turn on auto flush

host, port = 'localhost', 52000
maxsize = 1024

sock = TCPSocket::new( host, port )
puts 'connected to server...'

print '% '

input = [ sock, STDIN ]
running = true
while running
	result = select( input, nil, nil )
	for s in result[0]
		if s == STDIN
			line = STDIN.gets.chomp
			if line == ''
				puts 'leaving...'
				running = false				# break while loop
				break						# break for loop
			end
			sock.write( line )				# sends even on a broken socket

		else
			msg = sock.recv( maxsize )		# PENDING data:
			if msg.length != 0
				puts msg
				print '% '
			else
				puts 'server has left the building...'
				running = false				# break while loop
				break						# break for loop
			end
		end
	end
end
sock.close
FILE_END


# Ruby }}}
# Scala {{{
# --------------------------------------------------------------------------------



# TCP
# http: reference
# ........................................


FILE_BEGIN: NEXT_tcp_server.scala
#!/usr/bin/env scala

HEADER
# scala: TCP echo server - plain ol Socket


FILE_END


FILE_BEGIN: NEXT_tcp_client.scala
#!/usr/bin/env scala

HEADER
# scala: TCP echo client - plain ol Socket


FILE_END


# UDP
# http: reference
# ........................................


FILE_BEGIN: NEXT_udp_server.scala
#!/usr/bin/env scala

HEADER
# scala: UDP echo server - plain ol Socket


FILE_END


FILE_BEGIN: NEXT_udp_client.scala
#!/usr/bin/env scala

HEADER
# scala: UDP echo client -- plain ol Socket


FILE_END


# SELECT
# http: referene
# ........................................


FILE_BEGIN: NEXT_tcp_server_select.scala
#!/usr/bin/env scala

HEADER
# scala: TCP chat server with select()
# entering ANY line of input will exit the server


FILE_END


FILE_BEGIN: NEXT_tcp_client_select.scala
#!/usr/bin/env scala

HEADER
# scala: TCP chat client with select()
# entering ANY line of input will exit the server
# try this with more than one client...


FILE_END


# Scala }}}
# NEXT {{{
# --------------------------------------------------------------------------------



# TCP
# http: reference
# ........................................


FILE_BEGIN: NEXT_tcp_server.nx
#!/usr/bin/nxt

HEADER
# NEXT: TCP echo server - plain ol Socket


FILE_END


FILE_BEGIN: NEXT_tcp_client.nx
#!/usr/bin/nxt

HEADER
# NEXT: TCP echo client - plain ol Socket


FILE_END


# UDP
# http: reference
# ........................................


FILE_BEGIN: NEXT_udp_server.nx
#!/usr/bin/nxt

HEADER
# NEXT: UDP echo server - plain ol Socket


FILE_END


FILE_BEGIN: NEXT_udp_client.nx
#!/usr/bin/nxt

HEADER
# NEXT: UDP echo client -- plain ol Socket


FILE_END


# SELECT
# http: referene
# ........................................


FILE_BEGIN: NEXT_tcp_server_select.nx
#!/usr/bin/nxt

HEADER
# NEXT: TCP chat server with select()
# entering ANY line of input will exit the server


FILE_END


FILE_BEGIN: NEXT_tcp_client_select.nx
#!/usr/bin/nxt

HEADER
# NEXT: TCP chat client with select()
# entering ANY line of input will exit the server
# try this with more than one client...


FILE_END


# NEXT }}}
# --------------------------------------------------------------------------------


