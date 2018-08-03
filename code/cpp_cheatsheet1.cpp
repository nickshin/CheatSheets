/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 *
 * this file is from https://github.com/nickshin/CheatSheets/
 *
 *
 * this code will show the basic principles of:
 * - constructors
 * - destructors
 * - base, derived, multiple inheritance and friendship classes
 * - private vs protected vs public member data access
 * - pure and basic virtual function declarations
 * - polymorphism
 * - type casting
 *
 *
 * to compile:
 *     g++ cpp_cheatsheet1.cpp -o cpp_cheatsheet1
 *
 * to run:
 *     ./cpp_cheatsheet1
 *
 *
 * best viewed in editor with tab stops set to 4
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */

#include <iostream>		// cout
using namespace std;


// constructors and destructors will print the order
// base and derived classes are built and torn down


class Derived;									// forward declaration


class Abstract
{
private:
	int a_number;								// normally not accessible in derived class

public:
	Abstract()			{ cout << "abs:  no  params\n"; }
	Abstract( int num )	{ cout << "abs:  int params\n"; a_number = num; }
	~Abstract()			{ cout << "abs:  bye bye\n"; }
	virtual int please_define_me( void ) = 0;	// pure virtual function

	// polymorphism example
	// as well as multiple inheritance issue: see main() for details
	int  get_num( void ) { return this->please_define_me(); }

	friend class Derived;						// allowing access to private members
	friend class Poly;							// allowing access to private members
};


class Base
{
private:
//	int b_number;								// can not be accessed in derived class

protected:
	int b_number;								// can be accessed in derived class

public:
	Base()			{ cout << "base: no  params\n"; }
	Base( int num )	{ cout << "base: int params\n"; b_number = num; }
	~Base()			{ cout << "base: bye bye\n"; }

	virtual int get_num( void ) { return 0; }	// basic virtual function
	void set_num( int num ) { b_number = num; }
};


class CantCompile								// testing multiple inheritance ambiguity
{
private:
	int x;

public:
	void set_num( int num ) { x = num; }		// compiler will complain about this if used in Derived class below
};


class Derived: public Abstract, public Base//, public CantCompile
{
public:
	// XXX: watch how different class creation are done,
	// XXX: try out the two different Derived(int) constructors
	Derived()  { cout << "derived: no param\n"; }
	Derived( int num ) : Abstract( num ) { cout << "derived: int param\n"; }
//	Derived( int num ) : Base( num )     { cout << "derived: int param\n"; }
	~Derived() { cout << "derived: bye bye\n"; }

	// friend: note how please_define_me() is accessing a private base class member
	int please_define_me( void ) { return a_number; };

	// also, note how b_number is declared protected, or else this will not compile
	int get_num( void ) { return b_number; }
};


class Poly: public Abstract
{
public:
	// the following two are same
//	Poly( int num ) { a_number = num; }
	Poly( int num ) : Abstract( num ) { }

	int please_define_me( void ) { return a_number * 2; }
};



int
main()
{
	cout << "*** dd1 constructor sequence:\n";
	Derived dd1;
	dd1.set_num( 1234 );
	cout << "dd1 num: " << dd1.get_num() << endl;

	cout << "\n*** dd2 constructor sequence:\n";
	// multiple inheritance issue:
	// if Derived was compiled with [ Derived( int num ) : Abstract( num ) ]
	//     get_num() will not return the expected value of 5678
	// else if Derived was compiled with [ Derived( int num ) : Base( num ) ]
	//     abstract numbers are unknown...
	Derived dd2( 5687 );
	cout << "dd2 num: " << dd2.get_num() << endl;
	cout << "dd2 abstract num: " << dd2.Abstract::get_num() << endl;
	cout << "dd2 abstract num again: " << dd2.please_define_me() << endl;


	// polymorphism
	cout << "\n*** polymorphism:\n";
	Abstract *pp1 = &dd2;
	Abstract *pp2 = new (nothrow) Poly( 10 );
				cout << "pp1 num: " << pp1->get_num() << endl;
	if ( pp2 )	cout << "pp2 num: " << pp2->get_num() << endl;


	// casting
	cout << "\n*** casting:\n";
	CantCompile cc;
	pp1 = (Abstract*)&cc;						// explicit conversion -- see reinterpret_cast below
//	cout << pp1->get_num() << endl;				// will crash or produce unexpected results

	try {
		Base* pbd = new Derived;
		Base* pbb = new Base;
		Derived* pd;

		pd = dynamic_cast<Derived*>(pbd);		// ok: derived-to-base
		if ( ! pd ) cout << "Null pointer on first type-cast\n";

		pd = dynamic_cast<Derived*>(pbb);		// wrong: base-to-derived
		if ( ! pd ) cout << "Null pointer on second type-cast\n";

		pd = static_cast<Derived*>(pbb);
		if ( ! pd ) cout << "Null pointer on third type-cast\n";
//		else cout << "pd num: " << pd->get_num() << endl;	// will crash or produce unexpected results

//		pd = static_cast<Derived*>(&cc);		// will not compile
		pd = reinterpret_cast<Derived*>(&cc);	// will compile and is just like explicit conversion above
		if ( ! pd ) cout << "Null pointer on fourth type-cast\n";
//		else cout << "pd num: " << pd->get_num() << endl;	// will crash or produce unexpected results

	} catch( exception& e ) { cout << "Exception: " << e.what(); }


	// note the desctructor sequences here...
	cout << "\n*** destructor sequences:\n";
	return 0;
}

