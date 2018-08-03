<?php
/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 *
 * this file is from https://github.com/nickshin/CheatSheets/
 *
 *
 * this file contains some of my most used php snipets
 * - predefined variables: _GET _POST _SERVER _FILES
 * - binary and file handling
 *
 * and some uses of:
 * - passing by reference
 * - classes
 *
 *
 * best viewed in editor with tab stops set to 4
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */
echo "<pre>\n";


# test fileIO folder...
$testdir = "test_X";						# make sure this is webgroup writable...


# DUMP EVERYTHING THE CLIENT IS SENDING {{{
# ----------------------------------------

print_r($_SERVER);
print_r($_POST);
print_r($_GET);
print_r($_FILES);

# DUMP EVERYTHING THE CLIENT IS SENDING }}}
# PREDEFINED VARIABLES {{{
# ----------------------------------------

# GET submission:
# http://domain.name/submit_method_get.php?param1=value1&param2=value2
if ( ! empty($_GET) ) {
	$getvalue1 = $_GET['param1'];			# 'value1'
	$getvalue2 = $_GET['param2'];			# 'value2'
	echo "GET: $getvalue1 & $getvalue2\n";
}


# POST submission:
# http://domain.name/submit_method_post.php
else if ( ! empty($_POST) ) {
	$getvalue1 = $_POST['param1'];			# 'value1'
	$getvalue2 = $_POST['param2'];			# 'value2'
	echo "POST: $getvalue1 & $getvalue2\n";
}

else {

# here document
print <<<_END_FORM
Via GET:
<form action="submit_method_get.php" method="get">
	Name: <input type="text" name="param1" />
	Age:  <input type="text" name="param2" />
	<input type="submit" />
</form> 

Via POST:
<form action="submit_method_post.php" method="post">
	Name: <input type="text" name="param1" />
	Age:  <input type="text" name="param2" />
	<input type="submit" />
</form> 


_END_FORM;

}

# SERVER variables
# use PHPINFO to find out what's available to look at
#phpinfo();
# such as:
# if ( ! isset($_SERVER['HTTPS']) ) die;
# include( "$_SERVER[DOCUMENT_ROOT]/my_includes.php.inc" );



# PREDEFINED VARIABLES }}}
# SNIPETS {{{
# ----------------------------------------

function filesUpload()
{
	if ( empty( $_FILES ) ) {

print <<<_END_FILEFORM
<form action="submit_multipart.php" method="post" enctype="multipart/form-data">
File 1: <input type="file" name="file1"/>
File 2: <input type="file" name="file2"/>
<input type="submit" name="submit" value="Submit" />
</form>


_END_FILEFORM;
		return;
	}

	global $testdir;
	for ( $i = 1; $i <= 2; $i++ ) {
		if ( ! $_FILES["file$i"] ) continue;
		if ( $_FILES["file$i"]["error"] > 0 ) {
		    echo "Error Code: " . $_FILES["file$i"]["error"] . "\n";
			continue;
		}
		echo "Upload: "    .  $_FILES["file$i"]["name"] . "\n";
		echo "Type: "      .  $_FILES["file$i"]["type"] . "\n";
		echo "Size: "      . ($_FILES["file$i"]["size"] / 1024) . " Kb\n";
		echo "Temp file: " .  $_FILES["file$i"]["tmp_name"] . "\n";

		move_uploaded_file( $_FILES["file$i"]["tmp_name"],
							$testdir . "/" . $_FILES["file$i"]["name"] );
	}
}

function fileIOTests( $filename )
{
	global $testdir;
	$fname = "$testdir/$filename";

	# create/append/write
#	$f = fopen( $fname, "wb+" );		# this will zap the file to zero
	$f = fopen( $fname, "ab+" );
	if( $f ){
		fseek( $f, 0, SEEK_END );
		$data = pack( 'cV4', 1, 1234, 1234, 1234, 1234 );
		fwrite( $f, $data );
		fclose( $f);
	}

	# read
	if ( file_exists( $fname ) ) {
		if ( $f = fopen( $fname, "rb" ) ) {
			$data = 0;
			$size = filesize( $fname );
#			if ( ! $size ) goto doneread;
			if ( $size ) {
				echo "dumping: $fname:$size\n";
				$data = fread( $f, $size );
			}
#			if ( ! $data ) goto doneread;
			if ( $data ) {
				$subsize = 0;
				while ( $subsize < $size ) {
					$entry = substr( $data, $subsize, 17 );
					if ( ! $entry ) { echo ""; break; }
					$subsize += 17;
					$char1 = substr( $entry, 0, 1 );
					$charH = bin2hex( $char1 );
					$charD = ord( $char1 );
					$char16 = bin2hex( substr( $entry, 1, 16 ) );
					echo "\tentry: $char16 hex[$charH] dec[$charD]\n";
				}
			}
#doneread: #goto dne (til PHP:5.3)
			fclose($f);
			echo "\n";
		}
	}
}

function binaryRead()
{	# read Raw Post Data
	# php://input is not available with enctype='multipart/form-data'
	#             see filesUpload() to handle 'multipart/form-data'
	#             and can only be read once, this stream cannot seek
	$data = @file_get_contents('php://input'); 
	if ( $data ) {
		$results = unpack( 'V1int32_t/c4int8_t', $data );
		print_r( $results );
	}
#	else
#		echo "no data\n";
}

function binarySend()
{	# send raw data to client
    header( "Content-type: application/octet-stream" );
	echo pack( 'Vc*', 1234, 9, 8, 7, 6 );
}

filesUpload();
fileIOTests( "php_test_fileio.bin" );
binaryRead();
#binarySend(); # this can only be done before writing any text/html


# SNIPETS }}}
# PASSING BY REFERENCE {{{
# ----------------------------------------
# passing by reference

function foo( &$var )
{
	$var++;
}

$a = 5;
foo( $a );									# $a is 6
#foo($a = 5);								# expression, not variable
#foo(5);									# fatal error

function &bar()
{
	$a = 5;
	return $a;
}

foo(bar());									# valid


function noob() 							# Note the missing &
{
	$a = 5;
	return $a;
}

#foo( noob() );								# fatal error since PHP 5.0.5


# unsetting a reference, just breaks the binding between variable name and
# variable content. does not mean that variable content will be destroyed.
$b = &$a;
unset( $a );								# won't unset $b, just $a


# PASSING BY REFERENCE }}}
# CLASSES {{{
# ----------------------------------------
# use with PHP compiler to generate bytecodes via bcompiler

# PHP classes default properties to public

# classes
# with extends:   multiple inheritance is not supported.
# with interface: multiple inheritance is supported; however, methods are abstract.

class BaseClass
{
	# property declaration
	public    $public    = 'Public';
	protected $protected = 'Protected';
	private   $private   = 'Private';

	# method declaration
	function printProperties()
	{
		echo "\tBaseClass: " . $this->public . "\n";
		echo "\tBaseClass: " . $this->protected . "\n";
		echo "\tBaseClass: " . $this->private . "\n";
	}

	# using const
	const constant = 'constant value';
	protected function printConstant() { echo 'Base: ' .  self::constant . "\n"; }

	# using static
	static $singleton = null;
	function printStatic() {
		if ( ! self::$singleton )
		{ self::$singleton = 'am static'; }
		echo 'Base: ' . __CLASS__ . ': ' . self::$singleton . "\n";
	}

	# using constructors and destructors
	function __construct() { print "In BaseClass constructor\n"; }
	function __destruct()  { print "In BaseClass destructor\n"; }
}

class SubClass extends BaseClass
{
	# can redeclare the public and protected method but not private
	protected $protected = 'Protected2';
	
	# overrides BaseClass::printProperties()
	function printProperties()
	{
		echo "\tSubClass: " . $this->public . "\n";
		echo "\tSubClass: " . $this->protected . "\n";
#		echo "\tSubClass: " . $this->private . "\n";	# Undefined - warning messages
	}

	# override a protected method
	function printConstant() { echo  parent::printConstant(); }

	# using constructors and destructors
	function __construct() { print "In SubClass constructor\n"; }
	function __destruct()  { print "In SubClass destructor\n"; }
}

# testing extends usage
$obj1 = new BaseClass();
echo "\t" . $obj1->public . "\n";
#echo "\t" . $obj1->protected . "\n";		# Fatal Error
#echo "\t" . $obj1->private . "\n";			# Fatal Error
$obj1->printProperties();					# Shows Public, Protected and Private
#$obj1->printConstant();					# Fatal Error
echo $obj1::constant . "\n";				# As of PHP 5.3.0
$obj1->printStatic();
echo "\n";

$obj2 = new SubClass();
echo "\t" . $obj2->public . "\n";
#echo "\t" . $obj2->private . "\n";			# Undefined - warning messages
#echo "\t" . $obj2->protected . "\n";		# Fatal Error
$obj2->printProperties();					# Shows Public, Protected2, Undefined
$obj2->printConstant();						# SubClass::printConstant()
echo $obj2::constant . "\n";				# As of PHP 5.3.0
$obj2->printStatic();
echo $obj2::$singleton . "\n\n";

# cleanup
$obj1 = null;								# to see destructor in action
$obj2 = null;								# to see destructor in action
echo "\n";

# using named classes
# note: no constructors or destructors
$classname = "BaseClass";
echo $classname::constant."\n\n";				# As of PHP 5.3.0


# ----------------------------------------
# abstract class: requires the use of the abstract keyword on abstract methods.

# note visibility redeclarations
abstract class AbstractClass
{
	# Force Extending class to define these methods
	abstract protected function getValue();
	abstract protected function prefixValue($prefix);
	
	# Common method
	public function printOut() { print $this->getValue() . "\n"; }
}

class ConcreteClass1 extends AbstractClass
{
	protected function getValue() { return "ConcreteClass1"; }
	public function prefixValue($prefix) { return "{$prefix}ConcreteClass1"; }
}

class ConcreteClass2 extends AbstractClass
{
	public function getValue() { return "ConcreteClass2"; }
	public function prefixValue($prefix) { return "{$prefix}ConcreteClass2"; }
}

# testing abstract usage
$obj1 = new ConcreteClass1;
$obj1->printOut();
echo $obj1->prefixValue('FOO_') ."\n";

$obj2 = new ConcreteClass2;
$obj2->printOut();
echo $obj2->prefixValue('FOO_') ."\n\n";

# cleanup
$obj1 = null;
$obj2 = null;


# ----------------------------------------
# interface: for both extends and implements, multiple inheritance is supported.
#
# all interface methods must be public AND ABSTRACT.
#
# a class cannot implement two interfaces that share function names, since it
# would cause ambiguity.

interface iface1
{
	function printIFace1();
}

interface iface2
{
	function printIFace2();
}

interface iface3 extends iface1, iface2
{
	function printIFace3();
}

interface iface4
{
	function printIFace4();
}

# remember, classes can only extend a single class,
# but can implement more than one interface
class DerivedClass extends BaseClass implements iface3, iface4
{
	function printIFace1() { echo "IFace1\n"; }
	function printIFace2() { echo "IFace2\n"; }
	function printIFace3() {
		echo "IFace3\n";
#		printIFace2();						# Fatal Error
		$this->printIFace1();
		self::printIFace4();
	}
	function printIFace4() { echo "IFace4\n"; }
}

$obj1 = new DerivedClass;
$obj1->printIFace2();
$obj1->printIFace3();
$obj1->printProperties();					# Shows Public, Protected and Private

# cleanup
$obj1 = null;								# to see destructor in action
echo "\n";


# ----------------------------------------
# final keyword

class BaseClass1
{
	function test() { echo "Base1: test()\n"; }
	final function moreTesting() { echo "Base1: moreTesting()\n"; }
}

class SubClass1 extends BaseClass1
{
	function test() { echo "Sub1: test()\n"; }

	# the following results in Fatal error:
	# Cannot override final method BaseClass1::moreTesting()
#	function moreTesting() { echo "Child1: moreTesting()\n"; }
}

final class BaseClass2
{
	function test() { echo "Base2: test()\n"; }
	# use of final keyword here is redundant
	final function moreTesting() { echo "Base2: moreTesting()\n"; }
}

# Results in Fatal error: Class SubClass2 may not inherit from final class (BaseClass2)
#class SubClass2 extends BaseClass2 { }

$obj1 = new SubClass1;
$obj1->test();
$obj1->moreTesting();

# cleanup
$obj1 = null;								# to see destructor in action
echo "\n";


# ----------------------------------------

# # This example attempts to load the classes AnotherClass1 and AnotherClass2
# # from the files AnotherClass1.php and AnotherClass2.php respectively. 
# function __autoload($class_name) { require_once $class_name . '.php'; }
# $obj1 = new AnotherClass1();
# $obj2 = new AnotherClass2(); 

# CLASSES }}}
# ----------------------------------------

echo "</pre>\n";
?>
