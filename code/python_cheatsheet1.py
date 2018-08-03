#!/usr/bin/python
#
# written by Nick Shin - nick.shin@gmail.com
# the code found in this file is licensed under:
# - Unlicense - http://unlicense.org/
#
# this file is from https://github.com/nickshin/CheatSheets/
#
#
# this file contains some of my most used python snipets
#
# and some uses of:
# - file IO
# - dictionary
# - lists, tuples and arrays
# - classes
#
#
# to run:
#     python python_cheatsheet1.py
#
#
# best viewed in editor with tab stops set to 4
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.


import getopt				# getopt GetoptError
import sys				    # exit stdin argv

import array				# array
import numpy				# array
from ctypes import *		# c_int


# SNIPETS {{{
# ----------------------------------------

def usage():
	print "Usage: " + sys.argv[0] + " [options]"
	print """
Options are:
\t-h --help                This usage message.

\t-o filename              Output results to [ filename ]
\t--output=filename        or else, output to [ stdout ].

\t-i filename              Read JSON data from [ filename ]
\t--input=filename         or else, read data from [ stdin ].
"""


def main():
	# ........................................
	# process options and arguments
	try:
		opts, args = getopt.getopt( sys.argv[1:],
									"ho:i:",
									[ "help",
									"output=", "input="
									] )
	except getopt.GetoptError, err:
		print str(err)
		usage()
		sys.exit(2)

	dataout = None
	datain = None
	for o, a in opts:
		if o in ( "-h", "--help" ):
			usage()
			sys.exit()
		elif o in ( "-o", "--output" ):
			dataout = a
		elif o in ( "-i", "--input" ):
			datain = a
		else:
			assert False, "unhandled option"

	# ........................................
	# read in data
	data = ""
	if datain == None:
		data = sys.stdin.readlines()
#		for line in sys.stdin:
#			if not line.startswith( '#' ):		# strip out "comment" lines
#				data += line.strip()			# and newlines...
	else:
		with open( datain, 'r' ) as f:
			data = f.read()
#			for line in f:
#				if not line.startswith( '#' ):	# strip out "comment" lines
#					data += line.strip()		# and newlines...
			f.close()
	
	# ........................................
	# write out data
	if dataout == None:
		print data
	else:
		with open( dataout, 'w' ) as f:
			f.write( data )
			f.close()

	# ........................................
	return

	# ........................................
	# more FILE IO notes
	# the following two are the same
	data += f.readline()		# one line at a time
	data  = f.readlines()		# returns a list of all lines in the file

	data  = f.read()			# read in the entire file


# for demonstration purposes these are commented out...
#if __name__ == "__main__":
#	main()

# but show this:
usage()


# SNIPETS }}}
# DICTIONARY {{{
# ----------------------------------------

def dictionary_demo():

	sample_dictionary = { 'spam' : 1.25, 'ham' : 1.99, 'eggs' : 0.99 }

	print "dict full: ", sample_dictionary									# order is scrambled
	print "dict spam: ", sample_dictionary.get( 'spam', 'Bad choice' )		# return results
	print "dict bacon:", sample_dictionary.get( 'bacon', 'Bad choice' )		# alternative results

	sample_dictionary[ 'ham' ] = [ 'grill', 'bake', 'fry' ]		# change entry
	del sample_dictionary[ 'eggs' ]								# delete entry
	sample_dictionary[ 'brunch' ] = 'Bacon'						# add new entry
	print "dict full: ", sample_dictionary

	print "dict key: ", sample_dictionary.has_key( 'ham' )		# key membership test
	print "dict key: ", 'ham' in sample_dictionary				# key membership test alternative

dictionary_demo()
print ""


# DICTIONARY }}}
# LISTS TUPLES ARRAYS {{{
# ----------------------------------------

def lists_typles_arrays():
	a_list  = [ 'grill', 'bake', 'fry' ]

	# is just like a list, but is immutable
	a_tuple1 = ( 'spam', 'ham', 'eggs' )
	a_tuple2 = ()				# an empty tuple
	a_tuple3 = ( 50, )			# a tuple with a single value, trailing comma is REQUIRED
	
	# accessing either a list or a tuple:
	print "a_list[0]: ",    a_list[0]
	print "a_list[1:3]: ",  a_list[1:3]
	print "a_tuple1[0]: ",  a_tuple1[0]
	print "a_tuple1[1:]: ", a_tuple1[1:]

	# a_tuple1[0] = 'bam'				# immutable
	a_tuple1 = a_tuple2 + a_tuple3 * 3	# can be completely replaced though
	print "a_tuple: ", a_tuple1
	a_tuple1 = tuple( a_list )			# convert a list to a tuple
	print "a_tuple: ", a_tuple1


	# arrays are NOT found in python unless using an imported module.
	# there are a few modules that provides this feature:
	#     import array		# http://docs.python.org/library/array.html
	#     import numpy		# http://www.scipy.org/Tentative_NumPy_Tutorial
	#     import ctypes		# http://docs.python.org/library/ctypes.html
	#
	# they all operate a little differently; each with their strength and weaknesses...
	# otherwise, need to treat arrays as lists of lists...

# import array
	# "typecode" is the first parameter,
	# then the "array" is initialized in the second parameter
	print ""
	print "[ array ]"
	an_array1 = array.array( "i", [ 1, 2, 3 ] )
	an_array2 = array.array( "i", [ 10, 20, 30 ] )
	an_array3 = an_array1 + an_array2
	print "an_array1: ", an_array1
	print "an_array2: ", an_array2
	print "an_array3: ", an_array3
	print "an_array1 + an_array2: ", an_array1 + an_array2
	print "an_array1[1]: ", an_array1[1]
	# multidimensional array not possible with [ array ] module

# import numpy
	print ""
	print "[ numpy ]"
	an_array1 = numpy.array( [ 1, 2, 3 ] )
	an_array2 = numpy.array( [ 10, 20, 30 ] )
	an_array3 = an_array1 + an_array2
	print "an_array1: ", an_array1
	print "an_array2: ", an_array2
	print "an_array3: ", an_array3
	print "an_array1 + an_array2: ", an_array1 + an_array2
	print "an_array1[1]: ", an_array1[1]
	# multidimensional array:
	an_array1 = numpy.array( [ [ 1, 2 ], [ 3, 4 ] ] )	# note: square brackets
	print "multidimensional: "
	print an_array1
	print "an_array1[1][0]: ", an_array1[1][0]
	# multi to single dimension - pointer offset not possible with [ numpy ] module
#	print "an_array1[3]: ", an_array1[3]

# import ctypes
	print ""
	print "[ ctypes ]"
	three_ints = c_int * 3					# one way to allocate 3 ints
	an_array1 = three_ints( 1, 2, 3 )		# an array initialized
	an_array2 = (c_int*3)( 10, 20, 30 )		# another way to allocate 3 ints and initialized
#	an_array3 = an_array1 + an_array2		# array "add" not possible with [ ctypes ] module
	print "an_array1: ",
	for i in an_array1: print i,
	print ""
	print "an_array2: ",
	for i in an_array2: print i,
	print ""
	print "an_array1[1]: ", an_array1[1]
	# multidimensional array
	an_array1 = (c_int * 2 * 2)( ( 1, 2 ), ( 3, 4 ) )	# note: parentheses
	print "multidimensional: "
	print "[",
	for i in range(2):
		print "[",
		for j in range(2):
			print an_array1[i][j],
		print "]",
	print "]"
	print "an_array1[1][0]: ", an_array1[1][0]
	# multi to single dimension - pointer offset
	p = cast( an_array1, POINTER(c_int) )
	print "an_array1[3]: ", p[3]


	# ctypes also allows you to build struct and unions and interface with
	# (dynamically link to) libraries, call those library functions and
	# pass pointers to them and/or obtain return values from them....
	# these may be covered in another (C/C++ with python) cheatsheet. =)


lists_typles_arrays()
print ""


# LISTS TUPLES ARRAYS }}}
# CLASSES {{{
# ----------------------------------------

# python class (objects) can "grow" its members and methods on the fly.
# for example, starting with an "empty" class:
class ExampleClass:
	pass

example = ExampleClass()	# creates an empty ExampleClass record

# the fields of the record can be "filled" in:
example.name = 'bob'
example.id = 1234
example.description = 'what about it'

print "example: " + example.name + " " + str( example.id ) + " " + example.description + "\n"


# ........................................
# there is no "abstract" interface in python.
#
# methods can be stomped on to make it work like a virtual function.
#
# and "same" methods names across different objects can be thought
# of as "polymorphic"...
#
# self is a REQUIRED parameter - making it look more like how C would
# impliment a "class" object (since it has no "this" keyword).
#
# note:, if the method is declared as a staticmethod(), it is
# equivalent to a global function (and self is not required).
# classmethod() however, will require the "self" parameter;
# and it still works like staticmethod().

class SampleClass:
	f = None								# member f

	def __init__( self, something ):		# constructor
		print "+++ SampleClass constructor"
		self.x = 0							# member x
		self.y = something					# member y

	def __del__( self ):					# destructor
		print "--- SampleClass destructor"
		if self.f != None:
			f.close()

	def printbase( self, data ):
		print "SampleClass::printbase: " + str(data) + " " + str( self.x ) + " " + str( self.y ), self

	def printme( self, data ):
		print "SampleClass::printme: " + str(data), self

	def printstatic( data ):
		print "SampleClass::printstatic: " + str( data )
	printstatic = staticmethod( printstatic )

	def printclass( cls, data ):
		print "SampleClass::printclass: " + str( data ), cls
	printclass = classmethod( printclass )


sample = SampleClass( "instanced SampleClass" )
sample.printbase( "sample" )

sample.printstatic( "instanced static call" )
SampleClass.printstatic( "non-instanced static call" )

sample.printclass( "instanced class call" )
SampleClass.printclass( "non-instanced class call" )


# override test
def printoutside( data ):
	print "outside " + str( data )

sample.printstatic = printoutside
sample.printstatic( "instanced static call" )

# free the object to see the destructor
del sample			# 'sample' will be undefined after here...
print ""


# ........................................
# inheritance is supported, BUT:
# parent/base class __init__() and __del__() are NOT called
# automatically if derived class define these methods...

class BaseClass:
	def __init__( self ):
		print "+++ BaseClass constructor", self

	def __del__( self ):
		print "--- BaseClass destructor"

	def printme( self, data ):
		print "BaseClass::printme " + str( data ), self


class DerivedClass1( BaseClass, SampleClass ):		# BaseClass is first...
	def __init__( self ):
		print "+++ DerivedClass1 constructor", self
		self.printme( "from DerivedClass1" )

dc = DerivedClass1()								# no __del__()
del dc
print ""


class DerivedClass2( SampleClass, BaseClass ):		# SampleClass is first...
	def __init__( self ):
		print "+++ DerivedClass2 constructor", self
		self.printme( "from DerivedClass2" )

dc = DerivedClass2()								# no __del__()
del dc
print ""


class DerivedClass3( BaseClass, SampleClass ):		# BaseClass is first...
	def __del__( self ):
		print "--- DerivedClass3 destructor"

dc = DerivedClass3()								# no __init__()
dc.printme( "DerivedClass3" )
del dc
print ""


class DerivedClass4( BaseClass, SampleClass ):
	def __init__( self ):
		print "+++ DerivedClass4 constructor", self
		self.printme( "from DerivedClass4" )

	def __del__( self ):
		print "--- DerivedClass4 destructor"

dc = DerivedClass4()
#dc.printbase( "DerivedClass4" )					# x & y are not members of DerivedClass4
dc.x = 0
dc.y = "from DerivedClass4"
dc.printbase( "DerivedClass4" )						# now, can SampleClass::printbase()
del dc
print ""


# call the parent/base class __init__() __del__() explicitly
# yes, this means you can change the order of which base class methods to call...
class DerivedClass5( BaseClass, SampleClass ):
	def __init__( self ):
		# the long way...
		BaseClass.__init__( self )
		SampleClass.__init__( self, "derived" )
		print "+++ DerivedClass5 constructor", self
		self.printme( "from DerivedClass5" )

	def __del__( self ):
		# the "better" way...
		for base in reversed( DerivedClass5.__bases__ ):
			base.__del__( self )
		print "--- DerivedClass5 destructor"

# now, printbase() can be called since SampleClass::__init__() has been called properly
dc = DerivedClass5()
dc.printbase( "DerivedClass5" )						# now, can SampleClass::printbase()
del dc
print ""


# CLASSES }}}
# ----------------------------------------

