/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 *
 * this file is from https://github.com/nickshin/CheatSheets/
 *
 *
 * this code will show some STL programming usage
 * - containers
 * - algorithms
 * some Boost library features
 * - foreach
 * - smart pointers
 * and using class string
 *
 *
 * to compile:
 *     g++ cpp_cheatsheet3.cpp -o cpp_cheatsheet3
 *
 * to run:
 *     ./cpp_cheatsheet3
 *
 *
 * best viewed in editor with tab stops set to 4
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */


#include <iostream>		// cout
#include <algorithm>	// search for_each
#include <iterator>
#include <vector>
#include <memory>		// auto_ptr
#include <string>
#include <boost/foreach.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>
using namespace std;
using namespace boost;	// shared_ptr weak_ptr


// ----------------------------------------

// STL Containers are basically:
// - sequence containers
//   o vector				dynamic arrays
//   o deque				double ended queues
//   o list					linked lists
// - container "adapters"
//   o stack				LIFO stack - top is last (back)
//   o queue				FIFO queue - can access front & back
//   o priority_queue		LIFO queue - top is first (front)
// - associative containers
//   o set					tree - unique elements only
//   o multiset				tree - multiple same value elements allowed
//   o map					associative arrays - unique (key,value) elements
//   o multimap				associative arrays - multiple same keys elements allowed
//   o bitset				bit by bit

// STL algorithms essentially have parameters like:
//     algorithmFunction( firstIterator, lastIterator, ... );
// where the 3rd (or more) parameters are either:
//   o callback function
//   o value(s)
//   o even value(s) and a callback function
//   o or does not have more than 2 parameters
// all have iterative actions that either (to an element or a range of elements):
//   o search for
//   o apply a function to
//   o modify (replace, move, fill, remove)
//   o sort (automatically, partially, ranged, in reverse, permutations)
//   o merge with another
//   o compare for (includes, union, intersection, difference)
//   o copy
//   o use stack/heap-like functions on
// and then there are some template functions that are like operations, conversion
// and generator wrappers to arithmetic, comparison, logic funcions and pointers access

bool
iterPredicate( int i, int j )
{
	return ( i == j );
}

void
iterCallback( int i )
{
	cout << " " << i;
}

void
iteratorTest()
{
	cout << "*** STL iterator\n";

	vector<int> a;
	for( int i = 1; i <= 5; i++ )
		a.push_back(i);							// 1 2 3 4 5

	// walk the list
	vector<int>::iterator it;
	for( it = a.begin(); it != a.end(); ++it )
		cout << *it << " ";
	cout << endl;

	// search for ranged items
	int match1[] = { 3, 4 };
	it = search( a.begin(), a.end(), match1, match1 + 2 );
	if ( it != a.end() )
		cout << "match1 found at position: " << int( it - a.begin() ) << endl;
	else
		cout << "match1 not found\n";

	// search with predicate function
	int match2[] = { 2, 4 };
	it = search( a.begin(), a.end(), match2, match2 + 2, iterPredicate );
	if ( it != a.end() )
		cout << "match2 found at position " << int( it - a.begin() ) << endl;
	else
		cout << "match2 not found" << endl;

	// for_each the STL way
	cout << "foreach:";
	for_each( a.begin(), a.end(), iterCallback );
	cout << endl;
}


// the BOOST library has a handy wrapper to walk a sequence
// container without the need of using a callback function.
void
foreachTest()
{
	cout << "\n*** BOOST foreach\n";

	vector<int> a;
	for( int i = 1; i <= 5; i++ )
		a.push_back(i);							// 1 2 3 4 5

	// foreach the BOOST way
	// "i" will be filled with each element from the sequence container "a"
	cout << "foreach 1:";
	BOOST_FOREACH( int i, a )
	{
		cout << " " << i;
	}
	cout << endl;

	// no currly brace required
	BOOST_FOREACH( int& i, a )
		i++;

	// iterate in reverse
	cout << "foreach 2:";
	BOOST_REVERSE_FOREACH( int i, a )
		cout << " " << i;
	cout << endl;
}


// ----------------------------------------

// the auto_ptr template is a very simple smart pointer implimentation.
// in other words, it owns a dynamically allocated object and performs
// automatic cleanup when the object is no longer needed (destroyed).
//
// the basic behavior of this mechanism is: only one auto_ptr is allowed
// to own the object (pointer).  because of this, a copy of auto_ptr (for
// example, saving an initial memory location) is not possible.  the object
// will transfer ownership to the new auto_ptr while clearing the the
// original auto_ptr (much like auto_ptr::release). (this also means that
// auto_ptrs cannot be used in STL containers.)
//
// also, no two auto_ptrs should own the same object.  when one of the
// auto_ptrs destroys itself, the other auto_ptr will essentially become
// a dangling pointer (see bad example in the following function).

void
autoptrTest()
{
	cout << "\n*** auto_ptr\n";

	// using auto_ptrs
	int* i = new int;
	auto_ptr<int> ap1( i );
	*ap1 = 10;
	cout << "auto ptr 1: " << *ap1 << " " << *i << endl;
	*ap1.get() = 20;
	cout << "auto ptr 2: " << *ap1.get() << " " << *i << endl;


	{	// scope
		auto_ptr<int> ap2;
		ap2 = ap1;								// ap2 now owns the pointer
		cout << "scope auto ptr 3: "
//				<< *ap1							// error, ap1 points to null
				<< *ap2 << " " << *i << endl;
	}	// ap2 will delete the allocated object "i" when going out of scope

	// here, "i" is now pointing at freed memory location
	cout << "allocated object: "
			<< *i								// undefined or may crash
			<< endl;


	// reset & release
	i = new int;
	*i = 10;
	ap1.reset(i);
	cout << "\nauto ptr 4: " << *ap1 << " " << *i << endl;
	ap1.reset( new int );						// "i" will be deleted
	*ap1 = 20;
	// here, "i" is now pointing at freed memory location
	cout << "auto ptr 5: " << *ap1 << " "
			<< *i								// undefined or may crash
			<< endl;

	i = ap1.release();
	cout << "auto ptr 6: "
//			<< *ap1 << " "						// error, ap1 points to null
			<< *i << endl;

	// "i" is no longer owned by any smart pointer,
	// so am responsible for handling allocated object.
	delete i;
	i = NULL;


	// bad example
	i = new int;
	*i = 10;
	ap1.reset(i);
	{	// scope
		auto_ptr<int> ap2(i);
		cout << "auto ptr 7: " << *ap1 << " " << *ap2 << " " << *i << endl;
	}	// ap2 will delete the allocated object "i" when going out of scope
	// ap1 is now a dangling pointer and "i" is pointing at freed memory location
	cout << "auto ptr 8: "
			<< *ap1 << " "						// undefined or may crash
			<< *i								// undefined or may crash
			<< endl;
	// fake a release, this will force ap1 to point to null.
	// so when ap1 is destroyed (upon exiting this function)
	// the program wont crash... :)
	ap1.release();
}


// the BOOST library handles smart pointers with the following:
// - scoped_ptr      is pretty much like auto_ptr - cannot be used in STL containers
// - scoped_array    can take ownership of arrays - cannot be used in STL containers
//
// and adds the bells and whistles with the implimentation of:
// - shared_ptr      object ownership shared among multiple (smart) pointers
// - shared_array    array  ownership shared among multiple (smart) pointers
// - weak_ptr        non-owning observers of an object owned by shared_ptr
//
// there is a "lightweight" shared pointer option called:
// - intrusive_ptr   shared ownership of objects with an embedded reference count
//       and defines the two functions to increment and decrement the reference
//       count [ intrusive_ptr_add_ref() and intrusive_ptr_release() ]
//
// note: shared_ptr and weak_ptr has been proposed in C++ TR1 and is planned for
//       the C++0x standard.  these are all found in <memory> (also, auto_ptr
//       will be replaced with unique_ptr in the C++0x standard).


// the following will help demonstrate using shared_ptrs with cast operations
class Item										// abstract class
{
	string title;

public:
	Item( const string& _title ): title( _title ) { }

	virtual string Description() const = 0;		// pure virtual function
	string Title() const { return title; }
};

class Book : public Item
{
	int pages;

public:
	Book( const string& _title, int _pages ) : Item( _title ), pages( _pages ) { }

	virtual string Description() const { return "Book: " + Title(); }
	int Pages() const { return pages; }
};

class DVD : public Item
{
	int tracks;

public:
	DVD( const string& _title, int _tracks ) : Item( _title ), tracks( _tracks ) { }

	virtual string Description() const { return "DVD: " + Title(); }
	int Tracks() const { return tracks; }
};


// weak_ptr demonstration helper function
void
show( const weak_ptr<int>& wp )
{
	shared_ptr<int> sp = wp.lock();				// set shared_ptr from weak_ptr
	cout << *sp << endl;
}


// the following will help demonstrate solving cyclic dependency, when reference
// counters would be incremented more than necessary and resources may not be deleted.
class Node
{
	string           value;
	shared_ptr<Node> left;
	shared_ptr<Node> right;
	weak_ptr<Node>   parent;
	// since left/right already points to child(ren), any grandchild's "parent"
	// pointer would be redundant (smart pointer usage) if using shared_ptr.
	// to break the cyclic dependency, parent pointer is a weak_ptr.

public:
	Node( const string _value ): value( _value ) { }

	string           Value()  const { return value; }
	shared_ptr<Node> Left()   const { return left; }
	shared_ptr<Node> Right()  const { return right; }
	weak_ptr<Node>   Parent() const { return parent; }

	void SetParent( shared_ptr<Node> node ) {
		parent.reset();
		parent = node;
	}

	void SetLeft( shared_ptr<Node> node ) {
		left.reset();
		left = node;
	}

	void SetRight(shared_ptr<Node> node) {
		right.reset();
		right = node;
	}
};

string printUpTheTree( const shared_ptr<Node>& item )
{
	weak_ptr<Node>   wparent = item->Parent();
	shared_ptr<Node> sparent = wparent.lock();	// set shared_ptr from weak_ptr

	if(sparent)
		return printUpTheTree( sparent ) + "/" + item->Value();

	return item->Value();
}


void
sharedptrTest()
{
	cout << "\n*** BOOST smart pointers\n";

	// basic shared_ptr usage
	cout << "---   shared_ptr" << endl;
	shared_ptr<Node> node1( new Node( "work" ) );
	cout << "use_count for node1: " << node1.use_count() << endl;
	Node& n = *node1;							// not a smart pointer
	(void) n;
	cout << "use_count for node1 again: " << node1.use_count() << endl;

	cout << "# creating node2" << endl;
	shared_ptr<Node> node2( node1 );
	cout << "use_count for node1: " << node1.use_count() << "\tnode2: " << node2.use_count() << endl;
	
	cout << "# reset node1" << endl;
	node1.reset();
	cout << "use_count for node1: " << node1.use_count() << "\tnode2: " << node2.use_count() << endl;
	cout << endl;

	// basic weak_ptr usage
	cout << "--- weak_ptr" << endl;
	weak_ptr<int> wp;
	{	// scope
		shared_ptr<int> sp( new int(10) );
		wp = sp;
		show( wp );
	}	// sp is destroyed here
	cout << "expired : "
		<< boolalpha << wp.expired()
		<< endl << endl;


	// dynamic cast
	cout << "--- dynamic cast" << endl;
	shared_ptr<Item> item1( new DVD( "A Movie", 20 ) );
	cout << "item1 counter: " << item1.use_count() << endl;
	
	shared_ptr<Book> book = dynamic_pointer_cast<Book>( item1 );
	if ( book ) {								// should be null
		cout << book->Title() << ", " << book->Pages() << " pages" << endl;
		cout << "book counter:  " << book.use_count()  << endl;
	}
	
	shared_ptr<DVD> dvd = dynamic_pointer_cast<DVD>( item1 );
	if ( dvd ) {								// live pointer
		cout << dvd->Title() << ", " << dvd->Tracks() << " tracks" << endl;
		cout << "dvd  counter:  " << dvd.use_count()   << endl;
	}
	
	// note how book/dvd incremented the ref count
	cout << "item1 counter again: " << item1.use_count() << endl << endl;

	// static cast
	cout << "--- static cast" << endl;
	shared_ptr<Item> item2( new Book( "A Book", 200 ) );
	vector< shared_ptr<void> > items;			// STL container
	
	cout << "use_count for item1: " << item1.use_count() << "\titem2: " << item2.use_count() << endl;
	
	cout << "# adding to vector" << endl;
	items.push_back( item1 );
	items.push_back( item2 );
	cout << "use_count for item1: " << item1.use_count() << "\titem2: " << item2.use_count() << endl;
	
	shared_ptr<Item> spc = static_pointer_cast<Item>( *(items.begin()) );
	if ( spc )									// note: only looking at the first vector item...
		cout << spc->Title() << endl;
	
	cout << "# after casting" << endl;
	cout << "use_count for item1: " << item1.use_count() << "\titem2: " << item2.use_count() << endl;
	cout << endl;


	// weak_ptrs used to break cyclic dependency
	cout << "--- cyclic dependency" << endl;
	node1.reset( new Node( "/home" ) );
	shared_ptr<Node> node3( new Node( "base" ) );
	shared_ptr<Node> node4( new Node( "shop" ) );

	node1->SetLeft(  node2 );	node2->SetParent( node1 );
	node1->SetRight( node3 );	node3->SetParent( node1 );
	node2->SetLeft(  node4 );	node4->SetParent( node2 );
	cout << "use_count for \n"
		<<   "\tnode1: " << node1.use_count()	// root
		<< "\n\tnode2: " << node2.use_count()	// +1 for SetLeft()
		<< "\n\tnode3: " << node3.use_count()	// +1 for SetRight()
		<< "\n\tnode4: " << node4.use_count()	// +1 for SetLeft()
		<< endl;
// XXX uncomment the following for more output
//	shared_ptr<Node> temp = node1->Left();		// remember, reference count will be +1 when this is used
//	cout << "double check use_count for \n"
//		<<   "\tnode1->left: "       << temp.use_count()
//		<< "\n\tnode1->right: "      << node1->Right().use_count() // can you see why this is also +1
//		<< "\n\tnode1->left->left: " << temp->Left().use_count()
//		<< endl;

	cout << "# unreference some local smart pointers" << endl;
	weak_ptr<Node> last( node4 );				// saving a pointer
	// remember to keep at least a handle to root (top parent), so do not reset node1
	node2.reset();
	node3.reset();
	node4.reset();
	cout << "use_count again for \n"
		<<   "\tnode1: " << node1.use_count()	// root
		<< "\n\tnode2: " << node2.use_count()	// 0, but node1->left  now has a use_count() of 1
		<< "\n\tnode3: " << node3.use_count()	// 0, but node1->right now has a use_count() of 1
		<< "\n\tnode4: " << node4.use_count()	// 0, but node1->left->left now has a use_count() of 1
		<< endl;
// XXX uncomment the following for more output
//	cout << "double check use_count again for \n"
//		<<   "\tnode1->left: "       << temp.use_count()
//		<< "\n\tnode1->right: "      << node1->Right().use_count()
//		<< "\n\tnode1->left->left: " << temp->Left().use_count()
//		<< endl;

	// so, printing the tree should still be possible...
	node4 = last.lock();						// set shared_ptr from weak_ptr
	cout << "printing up the tree: " << printUpTheTree( node4 ) << endl;
}


// ----------------------------------------

void
stringTest()
{
	cout << "\n*** class string\n";

	string msg1 = "hi ";
	string msg2( "there" );
	string msg3( 3, '!' );

	string str( msg1 );
	str += msg2 + msg3;
	cout << str << endl;
	cout << "size: " << str.size() << endl;		// str.length() is an alias for str.size()
	cout << "char at [1] is: " << str.at(1) << endl;

	str.clear();
	if ( str.empty() )
		cout << "\nstring is empty\n\n";
	else
		cout << "\nstring is not empty?\n\n";

	str.append( "yo" );
	const char *c;
//	c = str.data();								// non-null terminated string
	c = str.c_str();
	cout << "[ " << str << " ] [ " << c << " ]" << endl;

	// there are all kinds of member functions that help search for,
	// find a range of, modify parts or fill all things in the string.
	// but, RegExp is KING for these kinds of operations...
}


// ----------------------------------------

int
main()
{
	// iterators
	iteratorTest();								// STL
	foreachTest();								// BOOST

	// pointers
	autoptrTest();								// STL
	sharedptrTest();							// BOOST

	// strings
	stringTest();

	return 0;
}

