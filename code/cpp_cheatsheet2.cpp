/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 *
 * this file is from https://www.nickshin.com/CheatSheets/
 *
 *
 * this code will show the basic principles of:
 * - templates
 * - const-ness
 * - dynamic memory
 * - exceptions
 *
 *
 * to compile:
 *     g++ cpp_cheatsheet2.cpp -o cpp_cheatsheet2
 *
 * to run:
 *     ./cpp_cheatsheet2
 *
 *
 * best viewed in editor with tab stops set to 4
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */


#include <iostream>		// cout cerr
#include <cstdlib>		// free
#include <string.h>		// strdup strlen
#include <exception>	// set_terminate set_unexpected
#include <new>			// set_new_handler
using namespace std;


// ----------------------------------------

template <class T>
T templateFunction( T a, T b ) {
	T result;
	result = ( a > b ) ? a : b;
	return result;
// all of the above can also be shorten to this:
//	return ( a > b ) ? a : b;
}


// ----------------------------------------

template <class T>
class templateClass
{
private:
	T a, b;

public:
	templateClass( T first, T second ) { a = first; b = second; }
	T getMax() { return ( a > b ) ?  a : b; }
	T getMin();
};

// when functions are defined outside of the class template
template <class T>
T templateClass<T>::getMin()
{
	return ( a < b ) ? a : b;
}

// template specialization: think of this as overriding a specific template type
template <>
class templateClass <char>
{
private:
	char c;

public:
	templateClass( char arg ) { c = arg; }
	char getUpper() {
		if ( ( c >= 'a' ) && ( c <= 'z' ) )
			c += 'A' - 'a';
		return c;
	}
};

// note: templates arguments are like parameters of a function...
// template < int, float >
// template < class T, double >
// template < class T, int, float, long, double >
// etc...


// ----------------------------------------

void
templateTest()
{
	int i = 10, j =20, a, b;
	a = templateFunction( i, j );				// compiler will figure this out
	b = templateFunction<int>( 1, 2 );			// explicitly
	cout << "*** template function\n";
	cout << a << endl;
	cout << b << endl;

	cout << "\n*** template class\n";
	templateClass<int> tci( 100, 200 );
	cout << tci.getMax() << endl;
	cout << tci.getMin() << endl;

	cout << "\n*** template specialization\n";
	templateClass<char> tcc( 'c' );
	cout << tcc.getUpper() << endl;
}


// ----------------------------------------

class constTest
{
private:
	char* x;

public:
	int y;
	mutable int z;

	constTest( const char* arg ) { x = strdup( arg ); y = 1; z = 2; }
	~constTest() { if ( x ) free( x ); }

	void doNothing1() { };
	void doNothing2() const { };

	const char* const MemberFunction() const {
		// see end of const_ness() for a note on this
//		doNothing1();							// will not compile
		doNothing2();							// will compile
//		y = 10;									// will not compile
		z = 20;									// will compile due to mutable keyword
		return x;
	}
};


void
const_ness()
{
	cout << "\n*** const-ness\n";

	// basically, 'const' applies to whatever is on its immediate left
	// (other than if there is nothing there [i.e. at the begining],
	//  in which case it applies to whatever is its immediate right).

	// for variable declaration and assigning this should be fairly straightforward.
	// there are a few other important details to note.

	// const_cast<> should only be used if the orignal variable is NOT const.
	// for example:

	const int x = 4;							// x is const, it can't be modified
	const int* const pX = &x;					// can not modify x through the pX pointer
	cout << x << endl;							// prints "4"
	int* pI = const_cast < int* > (pX);			// explicitly cast pX as non-const
	*pI = 3;									// result is undefined
	cout << x << endl;							// compiler will use [ const int x = 4; ] for x here

	int y = 5;

	// pX was a one time assignment, so it cannot be changed to point to something else
//	pX = &y;									// will not compile

	// here, pY will be able to point to another location.
	// note the missing 2nd const as done with in pX.
	const int* pY = &x;
	pY = &y;									// can not modify y through the pY pointer

	// here, the first const will not allow this assignment even though y itself is not const
//	*pY = 2;									// will not compile
	pI = const_cast < int* > (pY);				// explicitly cast pY as non-const
	*pI = 3;									// valid assignment
	cout << y << endl;							// prints "3"


	// const function, with the following:
	//     const char* const MemberFunction() const
	//
	// the second const means that the pointer returned is a const, so it
	// cannot be changed to point to something else (this is like pX above).
	//
	// the first const means that nothing can be modified at what the pointer
	// is pointing to (this is like x above).
	//
	// the last const, tells the compiler to check to make sure that none
	// of the object's data will be modified and any other member functions
	// invoked should also be declared as const.
	const char* p1 = "hi there";
	const constTest cT( p1 );
	cout << cT.MemberFunction() << endl;

	// mutable: allows data members to be modified even though the member
	// is part of an object declared as const.
	cout << "y: " << cT.y << "    z: " << cT.z << endl;
//	cT.y = 100;									// will not compile
	cT.z = 200;									// will compile due to mutable keyword
	cout << "y: " << cT.y << "    z: " << cT.z << endl;
}


// ----------------------------------------

void
terminateCatch()
{
	cerr << "Custom Exception Handler: terminate called\n";
}

void
unexpectedCatch()
{
	cerr << "Custom Exception Handler: unexpected called\n";
}

void
noMemoryCatch()
{
	cerr << "Custom Exception Handler: no memory called\n";

	// here, the code can try to make more storage available
	// and the new/new[] operators will be tried again.
	//
	// be aware, this will lead to an infinite loop if storage cannot be made available;
	// in which case, handler must throw another exception or terminate the program.
	throw bad_alloc();
//	exit(1);
}

// NOTE: the XXX notations here on denotes alternative lines of codes to
//       try out to see the different behaviours/response in using them.


// exception specifications: force a guarantee that a function (directly
// and indirectly) that only certain exceptions will be thrown within it;
// otherwise, terminate the program.
//
// void throwAnException();						// all exception types allowed
// void throwAnException() throw();				// no exceptions          thrown - or terminate program
// void throwAnException() throw(float);		// only floats            thrown - or terminate program
// void throwAnException() throw(constTest);	// only classes constTest thrown - or terminate program
// void throwAnException() throw(int, char);	// only ints and chars    thrown - or terminate program
//
// unexpected handler can still throw exceptions, but program will still terminate


// XXX: try one or the other to see how unexpected exception types are handled
void
throwAnException()
//throwAnException() throw(char)				// will terminate the program
{
	throw 1;
}


void
exceptionTest()
{
	int breakme = 1000000000;

	// exception handler
	try {

		// dynamic memory
		cout << "\n*** dynamic memory\n";
		int size = 1024;
//		size *= breakme;						// XXX: see what happends if this is used

		int *p = new int[size];
		cout << "alloc successful\n";
		delete[] p;								// note: an array

		p = new int;
		cout << "another alloc successful\n";
		delete p;								// note: a single element


		// nested exception handler
		cout << "\n*** exception\n";
		try {
			// XXX: try commenting one or the other to see the catch types
//			throw 20;							// throw an exception manually
			throw 'x';							// throw an exception manually
		}
		catch( int )  { cerr << "Exception 1: caught int\n"; }
		catch( char ) { cerr << "Exception 1: caught char\n"; }
		cout << "end of inner try-catch\n";
	}
	// a bad memory alloc can be caught in the following way:
	// from the most specific exception type... to the most general...
	// XXX: try commenting out the following catches one at a time
	catch( bad_alloc& )   { cerr << "Exception 2: Error allocating memory\n"; }
	catch( exception& e ) { cerr << "Exception 2: " << e.what() << endl; }
	catch( ... )          { cerr << "Exception 2: catch all\n"; }
	cout << "end of outer try-catch\n\n";


	// XXX: "no throw" exception, see what happens with the other line of code...
	int *pp = new (nothrow) int[breakme];
//	int *pp = new int[breakme];					// will terminate the program
	if ( pp ) {
		cout << "nothrow 1: alloc successful\n\n";
		delete[] pp;
	} else cerr << "nothrow 1: Error allocating memory\n\n";

	// trying this again, but with a custom handler
	set_new_handler(noMemoryCatch);
	try {
		// with nothrow
		pp = new (nothrow) int[breakme];		// note how custom handler is still called
		if ( pp ) {
			cout << "nothrow 2: alloc successful\n\n";
			delete[] pp;
		} else cerr << "nothrow 2: Error allocating memory\n\n";
		// without nothrow - but inside try-catch
		pp = new int[breakme];					// now, will NOT terminate the program
		cout << "with throw 2: alloc successful\n\n";
		delete[] pp;
	}
	catch( exception& e ) { cerr << "Exception: " << e.what() << endl << endl; }

	// more custom handlers
	set_terminate(terminateCatch);
	set_unexpected(unexpectedCatch);
	try { throwAnException(); }
	catch( int ) { cerr << "Exception 3: caught int\n"; }
}


// ----------------------------------------

int
main()
{
	templateTest();
	const_ness();
	exceptionTest();

	cout << "\ntests all done!\n";

	return 0;
}

