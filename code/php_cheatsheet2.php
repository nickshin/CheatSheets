<?php
/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 *
 * this file is from https://github.com/nickshin/CheatSheets/
 *
 *
 * this file contains some of my most used php snipets
 * - user agent detection
 * - crafted GET/POST headers
 * - memcache
 * - NoSQL
 *
 *
 * best viewed in editor with tab stops set to 4
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */


# ================================================================================
# user agent detection {{{
# ================================================================================

# redirect to mobile friendly crafted pages on first time visit
# but, make sure there's an option (in javascript) for 'view full site'
# version and vice versa ('view mobile site')

# NOTE: this is FIRST PASS -- make sure to do another check client side
# NOTE: this is FIRST PASS -- make sure to do another check client side
# NOTE: this is FIRST PASS -- make sure to do another check client side

$isMobile = 0;

# DIY:
	$ua = $_SERVER['HTTP_USER_AGENT'];
	if ( preg_match( '/iOS|Android|Mobile|Phone|Opera Mini/i', $ua ) )
		$isMobile = 1;

# if using https://github.com/serbanghita/Mobile-Detect
#	include 'Mobile_Detect.php';
#	$detect = new Mobile_Detect();
#	$isMobile = $detect->isMobile();


# in 'view full site'
# ----------------------------------------
if ( $isMobile ) {
	if (   ! isset( $_COOKIE['mobile'] )		# first time here
		|| $_COOKIE['mobile'] == 'y' )			# yes, view mobile version
	{
		header('Location: http://m.example.com/');
		exit;
	}
}
setcookie("mobile","n", time()+3600, "/","example.com");

# in 'view mobile site'
# ----------------------------------------
setcookie("mobile","y", time()+3600, "/","example.com");




# ================================================================================
# user agent detection }}}
# crafted headers {{{
# ================================================================================

# http://php.net/manual/en/function.header.php
#
# LOOK HERE for more header() options:
# - http://en.wikipedia.org/wiki/List_of_HTTP_header_fields#Responses


# WARNING: THESE FUNCTION MUST BE CALLED BEFORE ANY OUTPUT (including newlines)


# redirect
header('Location: http://m.example.com/');
exit;

# another redirect - NON standard: but supported by most browsers
header('Refresh: 5; url=http://m.example.com/');

# 404 normal
header("HTTP/1.0 404 Not Found");

# 404 FastCGI
header("Status: 404 Not Found");


# ----------------------------------------


# download dialog
# ...............

# outputting a PDF, suggest filename as "downloaded.pdf" and datadump 'original.pdf'
header('Content-type: application/pdf');
header('Content-Disposition: attachment; filename="downloaded.pdf"');
readfile('original.pdf');
exit;


# ----------------------------------------


# many proxies and clients can be forced to disable caching with

header("Cache-Control: no-cache, must-revalidate");		# HTTP/1.1
header("Expires: Sat, 26 Jul 1997 05:00:00 GMT");		# Date in the past




# ================================================================================
# crafted headers }}}
# memcache {{{
# ================================================================================

# nice PHP PDO SQLite3 example at:
# http://www.if-not-true-then-false.com/2012/php-pdo-sqlite3-example/
#
# and don't forget:
# http://www.phpro.org/tutorials/Introduction-to-PHP-PDO.html
# ! WATCH OUT ! some SQL statements will NOT work with some DB drivers
#               for example, 'SHOW TABLES' will not work on sqlite

function db_setup()
#function db_setup( $hostname, $username, $password, $dbname )
{
	try {
		$dbh = new PDO("sqlite::memory:");
#		$dbh = new PDO("sqlite:/path/to/database.sdb");
#		$dbh = new PDO("mysql:host=$hostname;dbname=$dbname", $username, $password);
#		$dbh = new PDO("pgsql:dbname=$dbname;host=$hostname", $username, $password );
#		$dbh = new PDO('odbc:Driver={Microsoft Access Driver (*.mdb)};Dbq=C:\accounts.mdb;Uid=Admin');

		$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$dbh->exec("CREATE TABLE animals (
					animal_id INTEGER PRIMARY KEY,
					animal_type TEXT,
					animal_name TEXT 
					)");
		return $dbh;

	} catch(PDOException $e)
		{ echo $e->getMessage(); }

	return null;
}

function db_warmup( $dbh, $dbname )
{
	echo "\nwarming up DB\n";
	$insert = "INSERT INTO $dbname(animal_type, animal_name) VALUES ('kiwi', 'troy')";
	$count = $dbh->exec( $insert );
	echo "DB insert results: $count\n"; # should be 1
}

function memcache_setup($qry)
{
	echo "\nmcsetup\n";
	$mc = new Memcache;

	echo "good, looks like Memcache works with your PHP setup\n"; # else install memcache for your system and for php
	$mc->connect( '127.0.0.1', 11211 ) or die ( 'unable to connect to memcached' );

	# comment out the delete and rerun this code -- you should see difference immediately
	$id = md5($qry);
	$mc->delete($id);
	return $mc;
}

function findValue( $qry, $dbh, $mc )
{
	echo "\nfetching\n";
	$id = md5($qry);
	
	if ( $result = $mc->get($id) ) {
		echo "memcached: $id\n";
		echo "$result\n";
		return;
	}

	echo "DB lookup (was NOT cached)\n";
	$result = '';
	$results = $dbh->query( $qry );
	foreach( $results as $row )
		$result .= $row['animal_type'] .' - '. $row['animal_name'];
	echo "$result\n";

	# now, cache it
	$mc->set( $id, $result );
}

function test()
{
	$dbh = db_setup();
	$dbname = 'animals';
	db_warmup( $dbh, $dbname );

	$qry = "SELECT * FROM $dbname";
	$mc  = memcache_setup($qry);

	$result = findValue( $qry, $dbh, $mc );

	echo "\nagain\n";
	$result = findValue( $qry, $dbh, $mc );


	# done with test, house keeping...
    $dbh->exec("DROP TABLE animals");
	$dbh = null; # close the database connection
}
echo "<pre>\n";
test();
echo "</pre>\n";



# ================================================================================
# memcache }}}
# NoSQL {{{
# ================================================================================

/*
http://nosql-database.org/
http://ontwik.com/php/nosql-databases-what-why-and-when-lorenzo-alberton/


what to look for:
* map/reduce
* multi dimensions
* construct different ways to store data
  o replication (redundancy(alternative version)/precalculated/secondary sets/etc.)
  o disk space is cheaper and more scalable than CPU


k-v
o redis
o couchbase

column
o google: big table
o multi dimensional sorted map
  - row_key
  - column_key
  - timestamp
o hadoop/hbase
o cassandra

document
o mongoDB
  - http://www.phpclasses.org/blog/post/118-Developing-scalable-PHP-applications-using-MongoDB.html
o couchDB

graph
o new4j


coming soon, my most used snippets...
*/

# ================================================================================
# NoSQL }}}
# ================================================================================

?>
