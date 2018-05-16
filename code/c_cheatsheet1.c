/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 *
 * this file is from https://www.nickshin.com/CheatSheets/
 *
 *
 * C is a pretty simple language.
 * so, this file will describe design patterns in C, even though
 * it is normally used with Object Oriented languages.
 * - creational patterns
 * - structural patterns
 * - behavioral patterns
 * - design principles
 *
 *
 * to compile:
 *     gcc -I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include \
 *         -L/usr/lib/ -lglib-2.0 c_cheatsheet1.c -o c_cheatsheet1
 *
 * to run:
 *     ./c_cheatsheet1
 *
 *
 * best viewed in editor with tab stops set to 4
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */




/* DESIGN PATTERNS NOTES {{{

design patterns represents:
---------------------------

o shared vocabulary
  i.e. a label to describe the common patterns
o solutions (patterns) to common problems (requirements)
o instead of code reuse, you get experience (patterns) reuse
o thinks about how to create flexble (pattern) designs that
  are maintainable and that can cope with change

o API: program to an interface, not an implementation
       i.e. program to a supertype
o encapsulate what varies
o favor composition over inheritance (programming language masturbation)
o depend on abstraction, not on concrete classes
o strive for loosely coupled designs between objects that interact


the details:
------------

http://www.codeguru.com/forum/showthread.php?t=327982
                 -----------------------------------------------------------
                 |                         purpose                         |
                 -----------------------------------------------------------
                 | creational       | structural |        behavioral       |
-----------------+------------------+------------+--------------------------
|       | class  | factory method   | adapter    | interpreter             |
|       |        |                  |            | template method         |
|       |--------+------------------+------------+--------------------------
|       |        | abstract factory | bridge     | chain of responsibility |
|       |        | builder          | composite  | command                 |
|       |        | prototype        | decorator  | iterator                |
| scope |        | singleton        | façade     | mediator                |
|       | object | object pool      | flyweight  | memento                 |
|       |        |                  | proxy      | observer                |
|       |        |                  |            | state                   |
|       |        |                  |            | strategy                |
|       |        |                  |            | visitor                 |
|       |        |                  |            | null object             |
----------------------------------------------------------------------------
class:  compile time
object: run time

Creational Patterns: initializing and configuring classes and objects
Structural Patterns: decoupling the interface and implementation of classes and objects
Behavioral Patterns: dynamic interactions among societies of classes and objects

creational
- factory method          : Creates an instance of several derived classes
- abstract factory        : Creates an instance of several families of classes
- builder                 : Separates object construction from its representation
- prototype               : A fully initialized instance to be copied or cloned
- singleton               : A class of which only a single instance can exist
- object pool             : Reuses and shares objects that are expensive to create

structural
- adapter                 : Match interfaces of different classes
- bridge                  : Separates an object’s interface from its implementation
- composite               : A tree structure of simple and composite objects
- decorator               : Add responsibilities to objects dynamically
- façade                  : A single class that represents an entire subsystem
- flyweight               : A fine-grained instance used for efficient sharing
- proxy                   : An object representing another object

behavioral
- interpreter             : A way to include language elements in a program
- template method         : Encapsulating algorithms to a subclass
- chain of responsibility : A way of passing a request between a chain of objects
- command                 : Encapsulate method invocation as an object
- iterator                : Sequentially access the elements of a collection
- mediator                : Centralize complex communication and control between related objects
- memento                 : Capture and restore an object's internal state
- observer                : A way of notifying change to a number of classes
- state                   : Alter an object's behavior when its state changes
- strategy                : Encapsulates an algorithm inside a class
- visitor                 : Defines a new operation to a class without change
- null object             : Provides intelligent "do nothing" behavior, hiding the details


http://www.oodesign.com/design-principles.html
Design Principles: set of guidelines for software development
- Open Close Principle:
  o Software entities like classes, modules and functions should be open for
    extension but closed for modifications.

- Dependency Inversion Principle:
  o High-level modules should not depend on low-level modules.
    Both should depend on abstractions.
  o Abstractions should not depend on details (concrete classes).
    Design should depend on abstractions.

- Principle of Least Knowledge:
  o Talk only to your immediate friends.

- Interface Segregation Principle:
  o Clients should not be forced to depend upon interfaces that they don't use.

- Single Responsibility Principle
  o A class should have only one reason to change.

- Liskov's Substitution Principle
  o Derived types must be completely substitutable for their base types.


additional reference sources:
- http://www.vincehuston.org/dp/
- Design Patterns: Elements of Reusable Object-Oriented Software, Nov 1994, Addison-Wesley Professional
- Head First Design Patterns, Oct 2004, O'Reilly Media


DESIGN PATTERNS NOTES }}} */
/* my design patterns comments {{{
----------------------------------------

knowning how to make your own function pointer declaration, assignment and execution
will cover 80% of the design pattern's attempt to implement your project.  wrappers
basic data structure know-how covers the other 20%.


design patterns should NOT be thought of as a solution to a problem but as an IDEA
to accomplish the task.


why in "C"?  why not.  the ideas are what is important here.  these are not new ideas.
many of the "design patterns" have been written before any OO languages existed.  again,
function pointers, data structure and function routines are all that's needed to run
these programming "tips/tricks/ideas".  these will come natural when getting rid of
duplicate code becomes obvious.


the giant list of alternative terminology created to describe the nit-picky difference
(as well as already established terms) for software development is actually quite
detrimental.  this leads to "holding hands" during (extreme micro managing or heavily
regulated) software development.  again, using patterns as ideas instead of requirements
would help.


redundant terminology notes
---------------------------

supertypes      == parent class / a particular base class
interface       == abstract supertype
refactoring     == complete re-write vs. extend vs. slight modification
instantiate     == create, alloc, new (an object) [see factory]
aggregate       == group, items
component       == an element in the composite (tree)
composite       == blind type tree
context         == the situation in which the pattern applies
collection      == container (array, stack, list, hash, etc.)
invoke          == call (a function)
(remote) proxy  == remote method invocation
                == remote procedure call
                == basic network programming

factory         == create, alloc, new (the function/method) [see instantiate]
adapter         == wrapper for an object('s interface) with a different interface
decorator       == wrapper with additional behviors (extend an object)
façade          == a function block (for a bunch of stuff to a bunch of objects)
builder         == create function (create a bunch of related objects)
visitor         == composite façade
proxy           == control access (request handler) to an object via:
                   remote (client/server) vs. virtual (delayed expensive instantiation)
command         == to execute() a function pointer
observers       == listeners / events / notifications
state           == changeable function pointers [see strategy]
strategy        == configurable (initialize) function pointers [see state]
template method == class/struct with (abstract/overridable[hooking]) function pointers
flyweight       == one instance used to provide many "virtual instances"
chain of responsibility == handlers are objects, and they handle "a" request
                           a fancy term for a "chain of function handlers"

model view controller (MVC) - an example composite pattern
model      == (observer)  data, state, logic
view       == (composite) presentation, display
controller == (strategy)  IO [translates to requests on the model]

model2 == MVC via the web
i.e. server side (controller) dynamic (model) page (view)


my design patterns comments }}} */




#include <stdio.h>			// printf
#include <stdlib.h>			// malloc free
#include <assert.h>			// assert()
#include <string.h>			// strcmp()
#include <time.h>			// time()
#include <glib.h>			// GList GQueue




/* -------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------- */


/* the following structs be used to demonstrate design patterns throughout this file */


/* -------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------- */


typedef struct {
	void (*print)(void*);				// virtual func set in BaseInit();
	char* data;
} BaseStruct;

void BasePrint( void* ptr )
{
	if ( ptr )
		printf( "\t%s\n", ((BaseStruct*)ptr)->data );
}

void BaseInit( BaseStruct* base )
{
	static char* data = "BaseStruct";
	if ( base ) {
		base->print = BasePrint;
		base->data = data;
	}
}

BaseStruct* BaseConstructor( void )
{
	BaseStruct* base = (BaseStruct*)malloc( sizeof(BaseStruct) );
	BaseInit( base );
	return base;
}

/* -------------------------------------------------------------------------------- */

// class SubStruct extends BaseStruct
typedef struct {
	BaseStruct base;
	char* data;
} SubStruct;

void SubPrint( void *ptr )
{
	if ( ptr ) {
		SubStruct* sub = (SubStruct*)ptr;
		BasePrint( &sub->base );
		printf( "\t%s\n", sub->data );
	}
}

void SubInit( SubStruct* sub )
{
	static char* data = "SubStruct";
	if ( ! sub )
		return;
	BaseInit( &sub->base );
	sub->base.print = SubPrint;			// override virtual function
	sub->data = data;
}

SubStruct* SubConstructor( void )
{
	SubStruct* sub = (SubStruct*)malloc( sizeof(SubStruct) );
	SubInit( sub );
	return sub;
}

/* -------------------------------------------------------------------------------- */

void Demo_Extends()
{
	SubStruct sub;

	printf( "\nStruct Extends\n" );
	SubInit( &sub );
	sub.base.print( &sub );
}


/* -------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------- */


void a_function(void) { printf( "in a_function()\n" ); }
void b_function(void) { printf( "in b_function()\n" ); }
void c_function(void) { printf( "in c_function()\n" ); }

/* -------------------------------------------------------------------------------- */

typedef struct {
	void (*print) (void*);				// virtual func set in AbstractInit();
	void (*function1)(void);			// virtual func set in AbstractInit();
	void (*function2)(void);			// note: pure virtual
	char* data;
} AbstractStruct;

void AbstractPrint( void* ptr )
{
	if ( ptr )
		printf( "\t%s\n", ((AbstractStruct*)ptr)->data );
}

void AbstractInit( AbstractStruct* abstract, void (*func1) (void) )
{
	static char* data = "AbstractStruct";
	if ( ! abstract ) {
		assert( "abstract: \"this\" is missing\n" );
		return;
	}
	if ( ! func1 ) {
		assert( "abstract: missing function assignment\n" );
		return;
	}
	abstract->print = AbstractPrint;
	abstract->function1 = a_function;
	abstract->function2 = func1;
	abstract->data = data;
}

AbstractStruct* AbstractConstructor( void )
{
	assert( "am abstract, extend this on your own\n" );
	return NULL;
}

/* -------------------------------------------------------------------------------- */

typedef struct {
	void (*function1)(void);			// note: pure virtual
	void (*function2)(void);			// note: pure virtual
	char* data;
} InterfaceStruct;

void InterfaceInit( InterfaceStruct* iface, void (*func1) (void), void (*func2) (void), char* data )
{
	if ( ! iface ) {
		assert( "interface: \"this\" is missing\n" );
		return;
	}
	if ( ! func1 || ! func2 ) {
		assert( "interface: missing function assignment\n" );
		return;
	}
	iface->function1 = func1;
	iface->function2 = func2;
	iface->data = data;
}

InterfaceStruct* InterfaceConstructor( void )
{
	assert( "am interface, impliment this on your own\n" );
	return NULL;
}

/* -------------------------------------------------------------------------------- */

// class ConcreteStruct extends AbstractStruct implements InterfaceStruct
typedef struct {
	AbstractStruct  abstract;
	InterfaceStruct interface;
} ConcreteStruct;

void ConcretePrint( void* ptr )
{
	if ( ptr ) {
		ConcreteStruct* c = (ConcreteStruct*)ptr;
		AbstractPrint( &c->abstract );
		printf( "\t%s\n", c->interface.data );
	}
}

void ConcreteInit( ConcreteStruct* c )
{
	static char* data = "ConcreteStruct";
	if ( !c )
		return;
	AbstractInit( &c->abstract, a_function );
	InterfaceInit( &c->interface, b_function, c_function, data );
	c->abstract.print = ConcretePrint;	// override virtual function
}

ConcreteStruct* ConcreteConstructor( void )
{
	ConcreteStruct* c = (ConcreteStruct*)malloc( sizeof(ConcreteStruct) );
	ConcreteInit( c );
	return c;
}

/* -------------------------------------------------------------------------------- */

void Demo_Abstract_Implements()
{
	ConcreteStruct c;

	printf( "\nStruct Extends and Implements\n" );
	ConcreteInit( &c );
	c.abstract.print( &c );
}


/* -------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------- */


/* Creational Design Patterns {{{
 * ======================================== */

/* Factory (Simplified version of Factory Method): {{{2
 * ----------------------------------------
 * - Creates objects without exposing the instantiation logic to the client.
 * - Refers to the newly created object through a common interface.
 */

/* THE DEMO */
void Factory_Simple()
{
	BaseStruct*     base;
	SubStruct*      sub;
	ConcreteStruct* crete;

	printf( "\nFactory_Simple()\n" );
	base  = BaseConstructor();
	sub   = SubConstructor();
	crete = ConcreteConstructor();

	if ( base ) {
		printf( "\t%s\n", base->data );
		free( base ); base = NULL;		/* clean up */
	}
	if ( sub ) {
		printf( "\t%s %s\n", sub->base.data, sub->data );
		free( sub ); sub = NULL;		/* clean up */
	}
	if ( crete ) {
		printf( "\t%s %s\n", crete->abstract.data, crete->interface.data );
		free( crete ); crete = NULL;	/* clean up */
	}
}


/* Factory (Simplified version of Factory Method): }}}2 */
/* Abstract Factory: {{{2
 * ----------------------------------------
 * - Offers the interface for creating a family of related objects, or
 *   dependent objects without explicitly specifying their concrete classes.
 * - A hierarchy that encapsulates: many possible "platforms", and the
 *   construction of a suite of "products".
 * - The [new] operator considered harmful.
 */

// class AF1Struct extends BaseStruct
typedef struct {
	BaseStruct base;
	char* data;
} AF1Struct;

void AF1_Print( void* ptr )
{
	if ( ptr )
		printf( "\t%s\n", ((AF1Struct*)ptr)->data );
}

AF1Struct* AF1Constructor( void )
{
	static char* data = "AF1Struct";
	AF1Struct* af1 = (AF1Struct*)malloc( sizeof(AF1Struct) );
	if ( af1 ) {
		BaseInit( &af1->base );
		af1->base.print = AF1_Print;	// override virtual function
		af1->data = data;
	}
	return af1;
}

// class AF2Struct extends BaseStruct
typedef struct {
	BaseStruct base;
	char* data;
	int moredata;
} AF2Struct;

void AF2_Print( void* ptr )
{
	if ( ptr ) {
		AF2Struct* af2 = (AF2Struct*)ptr;
		printf( "\t%s : %d\n", af2->data, af2->moredata );
	}
}

AF2Struct* AF2Constructor( void )
{
	static char* data = "AF2Struct";
	AF2Struct* af2 = (AF2Struct*)malloc( sizeof(AF2Struct) );
	if ( af2 ) {
		BaseInit( &af2->base );
		af2->base.print = AF2_Print;	// override virtual function
		af2->data = data;
		af2->moredata = 1234;
	}
	return af2;
}

/* THE DEMO */
void Abstract_Factory()
{
	int i;
	BaseStruct* base[2];

	printf( "\nAbstract_Factory()\n" );
	base[0] = (BaseStruct*)AF1Constructor();
	base[1] = (BaseStruct*)AF2Constructor();
	for ( i = 0; i < 2; i++ ) {
		if ( base[i] ) {
			base[i]->print( base[i] );
			free( base[i] ); base[i] = NULL;	/* clean up */
	}	}
}


/* Abstract Factory: }}}2 */
/* Factory Method: {{{2
 * ----------------------------------------
 * - Defines an interface for creating objects,
 *   but let subclasses decide which class to instantiate.
 *   i.e Lets a class defer instantiation to subclasses.
 * - Refers to the newly created object through a common interface.
 *
 * - Defining a "virtual" constructor.
 * - The [new] operator considered harmful.
 */

BaseStruct* FM_VirtualConstructor( int type )
{
	switch( type ) {
		case 0:
			return (BaseStruct*)AF1Constructor();
		case 1:
			return (BaseStruct*)AF2Constructor();
		default:
			break;
	}
	return NULL;
}

/* THE DEMO */
void Factory_Method()
{
	int i;
	BaseStruct* base[2];

	printf( "\nFactory_Method()\n" );
	for ( i = 0; i < 2; i++ )
		base[i] = FM_VirtualConstructor(i);

	for ( i = 0; i < 2; i++ ) {
		if ( base[i] ) {
			base[i]->print( base[i] );
			free( base[i] ); base[i] = NULL;	/* clean up */
	}	}
}


/* Factory Method: }}}2 */
/* Builder: {{{2
 * ----------------------------------------
 * - Defines an instance for creating an object
 *   but letting subclasses decide which class to instantiate
 * - Allows a finer control over the construction process.
 *
 * - Separate the construction of a complex object from its representation
 *   so that the same construction process can create different representations.
 * - Parse a complex representation, create one of several targets.
 */

/* builder == create function (create a bunch of related objects) */

BaseStruct** Builder_Parser( int* types, int count )
{
	BaseStruct** bases;
	if ( count <= 0 )
		return NULL;

	bases = (BaseStruct**)malloc( sizeof(BaseStruct*) * count );
	if ( bases ) {
		int i;
		for ( i = 0; i < count; i++ ) {
			switch( types[i] ) {
				case 0:
					bases[i] = (BaseStruct*)AF1Constructor();
					break;
				case 1:
					bases[i] = (BaseStruct*)AF2Constructor();
					break;
				default:
					bases[i] = NULL;
					break;
	}	}	}
	return bases;
}

/* THE DEMO */
void Builder()
{
	int complex_representation[] = { 0, 1, 0, 0, 1, 1, 0, 1 /*etc*/ };
	int count = sizeof( complex_representation ) / sizeof( complex_representation[0] );
	int i;
	BaseStruct** bases;

	printf( "\nBuilder()\n" );
	bases = Builder_Parser( complex_representation, count );
	if ( ! bases )
		return;

	for ( i = 0; i < count; i++ ) {
		if ( bases[i] ) {
			bases[i]->print( bases[i] );
			free( bases[i] ); bases[i] = NULL;	/* clean up */
	}	}

	free( bases );	/* clean up */
}


/* Builder: }}}2 */
/* Prototype: {{{2
 * ----------------------------------------
 * - Specify the kinds of objects to create using a prototypical instance,
 *   and create new objects by copying this prototype.
 * - Co-opt one instance of a class for use as a breeder of all future instances.
 * - The [new] operator considered harmful.
 */

typedef struct ProtoAbstractStruct {
	struct ProtoAbstractStruct* (*clone)(void);		// note: pure virtual
	BaseStruct base;
} ProtoAbstractStruct;

void ProtoAbstractInit( ProtoAbstractStruct* proto, struct ProtoAbstractStruct* (*clone)(void) )
{
	static char* data = "ProtoAbstractStruct";
	if ( ! proto ) {
		assert( "proto abstract: \"this\" is missing\n" );
		return;
	}
	if ( ! clone ) {
		assert( "proto abstract: missing clone function\n" );
		return;
	}
	BaseInit( &proto->base );
	proto->base.data = data;
}

ProtoAbstractStruct* ProtoAbstractConstructor( void )
{
	assert( "am proto abstract, extend this on your own\n" );
	return NULL;
}


// class Proto1Struct extends ProtoAbstractStruct
typedef struct {
	ProtoAbstractStruct proto;
	char* data;
} Proto1Struct;

void Proto1_Print( void* ptr )
{
	if ( ptr ) {
		Proto1Struct* proto1 = (Proto1Struct*)ptr;
		BasePrint( &proto1->proto.base );
		printf( "\t%s\n", proto1->data );
	}
}

ProtoAbstractStruct* Proto1Constructor( void )
{
	static char* data = "Proto1Struct";
	Proto1Struct* proto1 = (Proto1Struct*)malloc( sizeof(Proto1Struct) );
	if ( proto1 ) {
		BaseInit( &proto1->proto.base );
		proto1->proto.base.print = Proto1_Print;	// override virtual function
		proto1->proto.clone = Proto1Constructor;
		proto1->data = data;
	}
	return (ProtoAbstractStruct*)proto1;
}

// class Proto2Struct extends ProtoAbstractStruct
typedef struct {
	ProtoAbstractStruct proto;
	char* data;
	int moredata;
} Proto2Struct;

void Proto2_Print( void* ptr )
{
	if ( ptr ) {
		Proto2Struct* proto2 = (Proto2Struct*)ptr;
		BasePrint( &proto2->proto.base );
		printf( "\t%s : %d\n", proto2->data, proto2->moredata );
	}
}

ProtoAbstractStruct* Proto2Constructor( void )
{
	static char* data = "Proto2Struct";
	Proto2Struct* proto2 = (Proto2Struct*)malloc( sizeof(Proto2Struct) );
	if ( proto2 ) {
		BaseInit( &proto2->proto.base );
		proto2->proto.base.print = Proto2_Print;	// override virtual function
		proto2->proto.clone = Proto2Constructor;
		proto2->data = data;
	}
	return (ProtoAbstractStruct*)proto2;
}

/* THE DEMO */
void Prototype()
{
	int i, j;
	ProtoAbstractStruct* protos[8];

	printf( "\nPrototype()\n" );
	protos[0] = (ProtoAbstractStruct*)Proto1Constructor();
	protos[1] = (ProtoAbstractStruct*)Proto2Constructor();
	for ( i = 2; i < 8; i++ ) {
		j = i & 0x1;
		if ( protos[j] )
			protos[i] = (ProtoAbstractStruct*)protos[j]->clone();
	}
	/* show the results */
	for ( i = 0; i < 8; i++ ) {
		if ( protos[i] ) {
			protos[i]->base.print( protos[i] ); printf( "\n" );
			free( protos[i] ); protos[i] = NULL;	/* clean up */
	}	}
}


/* Prototype: }}}2 */
/* Singleton: {{{2
 * ----------------------------------------
 * - Ensure that only one instance of a class is created.
 * - Provide a global access point to the object.
 *
 * - Encapsulated "just-in-time initialization" or "initialization on first use".
 */

// the following indirection is needed to help make the singleton pattern design work in C:
//
// here's why, the following will break in C
//
// struct XYZ {	/* struct member (not pointer) */
//		__TheRealSingletonObject data;
//		...
// }
//
// {	/* stack allocation */
//		__TheRealSingletonObject element;
//		...
// }
//
// /* dynamically allocated */
// __TheRealSingletonObject* item = (__TheRealSingletonObject*)malloc( sizeof(__TheRealSingletonObject) );
//
// [data], [element] and [item] all do not refer to same singleton object...

#define __TheRealSingletonObject	BaseStruct

// the indirection...
typedef struct {
	__TheRealSingletonObject* the_real_singleton;
} SingletonStruct;

SingletonStruct* _singleton = NULL;

#define Singleton_GetInstance		SingletonConstructor
SingletonStruct* SingletonConstructor()
{
	if ( ! _singleton ) {
		_singleton = (SingletonStruct*)malloc( sizeof(SingletonStruct) );
		if ( _singleton )
			_singleton->the_real_singleton = BaseConstructor();
	}
	return _singleton;
}

void SingletonInit( SingletonStruct* singleton )
{
	if ( singleton ) {
		SingletonStruct* s = Singleton_GetInstance();
		if ( s )
			singleton->the_real_singleton = s->the_real_singleton;
	}
}

/* THE DEMO */
void Singleton()
{
	struct SingletonTest {
		SingletonStruct struct_singleton_object;
	} test;
	int i;
	SingletonStruct* singleton[6];
	SingletonStruct local_singleton_object;
	SingletonStruct* dynamic_singleton;

	printf( "\nSingleton()\n" );
	/* these are all the same */
	singleton[0] = SingletonConstructor();
	singleton[1] = Singleton_GetInstance();
	singleton[2] = _singleton;

	/* trick C */
	/* these are all essentially the same */
	SingletonInit( &test.struct_singleton_object );
	singleton[3] = &test.struct_singleton_object;
	SingletonInit( &local_singleton_object );
	singleton[4] = &local_singleton_object;
	dynamic_singleton = (SingletonStruct*)malloc( sizeof(SingletonStruct) );
	SingletonInit( dynamic_singleton );
	singleton[5] = dynamic_singleton;

	for ( i = 0; i < 6; i++ )
		if ( singleton[i] )
			printf( "\t[%d] pointer:%p singleton:%p\n", i, singleton[i], singleton[i]->the_real_singleton );

	/* clean up */
	if ( dynamic_singleton )
		free ( dynamic_singleton );
	// DO NOT DESTROY THE SINGLETON HERE (unless planned)...
}


/* Singleton: }}}2 */
/* Object Pool: {{{2
 * ----------------------------------------
 * - Reuses and shares objects that are expensive to create.
 */

#define OBJECT_POOL_LIMIT			3
#define ObjectPoolConstructor		ObjectPool_GetInstance
#define ObjectPoolFree(x)			x->alive = 0

//#define objpool_dbg_printf			printf
#define objpool_dbg_printf(...)

typedef struct {
	BaseStruct base;
	int alive;
} ObjectPoolStruct;

ObjectPoolStruct* _object_pool[OBJECT_POOL_LIMIT] = { NULL, NULL, NULL };

ObjectPoolStruct* ObjectPool_GetInstance()
{
	static char* data[3] = { "pool0", "pool1", "pool2" };
	int i;

	// logic order:
	// 1 allocated & not alive
	// 2 newly allocated
	// 3 none to return
	
	// rule 1
	for ( i = 0; i < OBJECT_POOL_LIMIT; i++ ) {
		if ( _object_pool[i] && ! _object_pool[i]->alive ) {
			objpool_dbg_printf( "*** get: reusing %d\n", i );
			_object_pool[i]->alive = 1;
			return _object_pool[i];
	}	}

	// rule 2
	for ( i = 0; i < OBJECT_POOL_LIMIT; i++ ) {
		ObjectPoolStruct* obj;
		if ( _object_pool[i] ) continue;
		obj = (ObjectPoolStruct*)malloc( sizeof(ObjectPoolStruct) );
		if ( ! obj )
			return NULL;
		objpool_dbg_printf( "*** get: allocating %d\n", i );
		_object_pool[i] = obj;
		BaseInit( &obj->base );
		obj->base.data = data[i];
		obj->alive = 1;
		return obj;
	}

	objpool_dbg_printf( "*** get: none\n" );
	// rule 3
	return NULL;
}

/* THE DEMO */
void Object_Pool()
{
	ObjectPoolStruct* objs[OBJECT_POOL_LIMIT] = { NULL, NULL, NULL };
	int i, j;

	printf( "\nObject_Pool()\n" );
	srand( time(NULL) );
	for ( i = 0; i < 8; i++ ) {
		j = rand() % OBJECT_POOL_LIMIT;
		if ( objs[j] ) {
			objpool_dbg_printf( "*** run: pre nuke %d\n", j );
			ObjectPoolFree( objs[j] );
			objs[j] = NULL;
		}
		objs[j] = ObjectPool_GetInstance();
		if ( objs[j] ) {
			objpool_dbg_printf( "*** run: getting %d\n", j );
			objs[j]->base.print( &objs[j]->base );
		}
		j = rand() % OBJECT_POOL_LIMIT;
		if ( objs[j] ) {
			objpool_dbg_printf( "*** run: post nuke %d\n", j );
			ObjectPoolFree( objs[j] );
			objs[j] = NULL;
	}	}
	printf( "\t*** final results ***\n" );
	for ( i = 0; i < OBJECT_POOL_LIMIT; i++ ) {
		if ( objs[i] && objs[i]->alive )
			objs[i]->base.print( &objs[i]->base );
	}
	printf( "\t---\n" );
	for ( i = 0; i < OBJECT_POOL_LIMIT; i++ ) {
		if ( _object_pool[i] )
			_object_pool[i]->base.print( &_object_pool[i]->base );
	}
}


/* Object Pool: }}}2
 * Creational Design Patterns }}}
 * Structural Design Patterns {{{
 * ======================================== */

/* Adapter: {{{2
 * ----------------------------------------
 * - Convert the interface of a class into another interface clients expect.
 *   i.e. Lets classes work together, that could not otherwise because of
 *   incompatible interfaces.
 *
 * - Wrap an existing class with a new interface.
 * - Impedance match an old component to a new system
 */

typedef struct {
	int data;
	void (*print)(int);				// set in LegacyInit();
} LegacyStruct;

void Legacy_Print( int data )
{
	printf( "\t%d\n", data );
}

void LegacyInit( LegacyStruct* legacy )
{
	if ( ! legacy )
		return;
	legacy->print = Legacy_Print;
	legacy->data = 5678;
}

typedef struct {
	BaseStruct	base;
	LegacyStruct old;
} AdapterStruct;

void Adapter_Print( void* ptr )
{
	if ( ptr ) {
		AdapterStruct* adapter = (AdapterStruct*)ptr;
		printf( "\t%s :", adapter->base.data );
		adapter->old.print( adapter->old.data );
	}
}

AdapterStruct* AdapterConstructor( void )
{
	static char* data = "AdapterStruct";
	AdapterStruct* adapter = (AdapterStruct*)malloc( sizeof(AdapterStruct) );
	if ( adapter ) {
		BaseInit( &adapter->base );
		adapter->base.print = Adapter_Print;	// override virtual function
		adapter->base.data = data;
		LegacyInit( &adapter->old );
	}
	return adapter;
}

/* THE DEMO */
void Adapter() // based on Abstract_Factory()
{
	int i;
	BaseStruct* base[3];

	printf( "\nAdapter()\n" );
	base[0] = (BaseStruct*)AF1Constructor();
	base[1] = (BaseStruct*)AF2Constructor();
	base[2] = (BaseStruct*)AdapterConstructor();
	for ( i = 0; i < 3; i++ ) {
		if ( base[i] ) {
			base[i]->print( base[i] );
			free( base[i] ); base[i] = NULL; // clean up
	}	}
}


/* Adapter: }}}2 */
/* Bridge: {{{2
 * ----------------------------------------
 * - Decouple abstraction from implementation so that the two can vary independently.
 *
 * i.e. provide an common (abstract) interface to different systems (APIs, drivers, etc.).
 *
 * - Adapter makes things work after they're designed;
 *   Bridge makes them work before they are.
 */

typedef struct {
	void (*func) (void);
} BridgeStruct;

void bridge_mySQL_implimentation()
{
	printf( "\tusing mySQL\n" );
}

void bridge_oracleSQL_implimentation()
{
	printf( "\tusing oracleSQL\n" );
}

void bridge_postgreSQL_implimentation()
{
	printf( "\tusing postgreSQL\n" );
}

void bridge_SQLite_implimentation()
{
	printf( "\tusing SQLite\n" );
}

void bridge_someNewSQL_implimentation()
{
	printf( "\tgetting ready to use some new SQL library\n" );
}

/* THE DEMO */
void Bridge()
{
	BridgeStruct mySQL;
	BridgeStruct oracleSQL;
	BridgeStruct postgreSQL;
	BridgeStruct SQLite;
	BridgeStruct someNewSQL;			// !!! bridge

	/* NOTE: BridgeStruct is also allowed to be modified -- so both sides of the
	 * object (1:abstraction 2:implementation) can be worked on at the same time... */

	BridgeStruct* DBbackendSupported[5] = { &mySQL, &oracleSQL, &postgreSQL, &SQLite, &someNewSQL };
	int i;

	printf( "\nBridge()\n" );
	mySQL.func      = bridge_mySQL_implimentation;
	oracleSQL.func  = bridge_oracleSQL_implimentation;
	postgreSQL.func = bridge_postgreSQL_implimentation;
	SQLite.func     = bridge_SQLite_implimentation;
	someNewSQL.func = bridge_someNewSQL_implimentation;	// !!! bridge
	for ( i = 0; i < 5; i++ )
		DBbackendSupported[i]->func();
}


/* Bridge: }}}2 */
/* Composite: {{{2
 * ----------------------------------------
 * - Compose objects into tree structures to represent part-whole hierarchies.
 *   i.e. Lets clients treat individual objects and compositions of objects uniformly.
 *
 * - Recursive composition.
 * - "Directories contain entries, each of which could be a directory."
 * - 1-to-many "has a" up the "is a" hierarchy .
 *
 * - Implement via "lowest common denominator".
 */


/* GLib's Data Types pretty much covers this
 * http://library.gnome.org/devel/glib/2.20/glib-data-types.html */

static GList* _blitlist = NULL;

typedef struct {					// compositions (of objects) vs. an object
	union {							// think of union as the base class
		struct {					// SubClass 1
			int is_a_composite;		// must be zero
			char* data;
		};
		struct {					// SubClass 2
			int level;
			GList* sublist;
		};
	};
} BlitStruct;
// these examples could have used BaseStrut and SubStruct declaration for
// "proper" OO programming design... but the combo struct above is for
// demonstration purposes simplifing these design patterns examples.


BlitStruct* BlitConstructor_Object( char* name )
{
	BlitStruct* blit;

	if ( ! name || ! *name )
		return NULL;

	blit = (BlitStruct*)malloc( sizeof(BlitStruct) );
	if ( blit ) {
		blit->is_a_composite = 0;
		blit->data = name;
	}
	return blit;
}

BlitStruct* BlitConstructor_Composite( int level )
{
	BlitStruct* blit = (BlitStruct*)malloc( sizeof(BlitStruct) );
	if ( blit ) {
		blit->level = level;
		blit->sublist = NULL;
	}
	return blit;
}


// forward declarations -- found in behavioral::iterator
void _blitlist_delete_element( gpointer, gpointer );
int   blitlist_blit( GList*, int );


// "private" implementation functions -- hidden from behavioral::iterator
int _blitlist_blit( BlitStruct* blit, int level )
{
	char* p = "am leaf";
	int i;

	if ( blit->is_a_composite )
		level = blit->level;
	else
		p = blit->data;

	for ( i = 0; i <= level; i++ )
		printf( "\t" );
	printf( "%s\n", p );

	if ( blit->is_a_composite )
		blitlist_blit( blit->sublist, level );

	return 0;
}

void _blitlist_delete( BlitStruct* blit )
{
	/* free additional resources attached to this obj here */
	if ( blit->is_a_composite ) {
	    g_list_foreach( blit->sublist, _blitlist_delete_element, NULL );
		g_list_free( blit->sublist );
	}
	free( blit );
}


/* THE DEMO -- see behavioral::iterator::blitlist_blit() */
//             see behavioral::iterator::blitlist_nuke()
//             using the functions here with only a single GList object


/* Composite: }}}2 */
/* Flyweight: {{{2
 * ----------------------------------------
 * - Use sharing to support a large number of objects that have part of their
 *   internal state in common where the other part of state can vary.
 *
 * - Replacing heavy-weight widgets with light-weight gadgets.
 */

/* THE DEMO -- see behavioral::iterator()->FacadeBlitSetup() */
char* FlyweightBlit_GetObject( void )
{
	// pretend data is a chunky object of the 3D model (verts & polys),
	// animation skeleton (bones), collision data (boundary) and
	// sound tables (voice type) =)
	//
	// i.e.
	// chunkyobject = new objectModel;
	//
	// chunkyobject.load3Dmodel();				// only needs to be loaded once
	// chunkyobject.createBones();				// state that can vary - i.e. standing, jumping, sitting, etc.
	// chunkyobject.generateCollisionData();	// shared data
	// chunkyobject.initSoundPointers();		// state that can vary - i.e. male vs female
	// return chunkyobject;

	static char* data = "FlyweightBlit";
	return data;
}


/* Flyweight: }}}2 */
/* Façade: {{{2
 * ----------------------------------------
 * - Provide a unified interface to a set of interfaces in a subsystem.
 *   i.e. Defines a higher-level interface that makes the subsystem easier to use.
 * - Wrap a complicated subsystem with a simpler interface.
 */

// forward declarations -- found in behavioral::iterator
GList* blitlist_submit( BlitStruct*, GList* );

/* THE DEMO -- see behavioral::iterator() using this function */
void FacadeBlit_Setup( int* blit_data, int size )
{
	int i;
	GQueue* queue;
	GList** list;

	queue = g_queue_new();
	if ( ! queue ) {
		printf( "unable to allocate queue...\n" );
		return;
	}
	list = &_blitlist;

	// setup
	for ( i = 0; i < size; i++ ) {
		BlitStruct* blit;
		int type = blit_data[i];
		if ( type == -1 )
			list = (GList**)g_queue_pop_tail( queue );
		else {
			// "the complicated subsystem"
			int level = g_queue_get_length( queue )
						+ ( ! type ? 1 : 0 );
			if ( type )
				blit = BlitConstructor_Object( FlyweightBlit_GetObject() );
			else
				blit = BlitConstructor_Composite( level );
			if ( blit ) {
				*list = blitlist_submit( blit, *list );
				if ( ! type ) {
					g_queue_push_tail( queue, list );
					list = &blit->sublist;
	}	}	}	}
}


/* Façade: }}}2 */
/* Decorator: {{{2
 * ----------------------------------------
 * - Add additional responsibilities dynamically to an object.
 *
 * - Provide a flexible alternative to subclassing for extending functionality.
 * - Client-specified embellishment of a core object by recursively wrapping it.
 * - Wrapping a gift, putting it in a box, and wrapping the box.
 */

#define MAX_ABSTRACT_BASE_DATA_SIZE		20
typedef struct {
	void (*print)(void*);				// virtual func set in AbstractBaseInit();
	void (*destroy)(void*);				// virtual func set in AbstractBaseInit();
	char data[MAX_ABSTRACT_BASE_DATA_SIZE];
} AbstractBaseStruct;

#define AbstractBaseConstructor		AbstractConstructor

void AbstractBasePrint( void* ptr )
{
	if ( ptr )
		printf( "\t%s icecream\n", ((AbstractBaseStruct*)ptr)->data );
}

void AbstractBaseDestroy( void* ptr )
{
	if ( ptr )
		free( ptr );
}

void AbstractBaseInit( AbstractBaseStruct* abase, char* data )
{
	if ( ! abase ) {
		assert( "abstract base: \"this\" is missing\n" );
		return;
	}
	if ( ! data || ! *data ) {
		assert( "abstract base: missing data ptr\n" );
		return;
	}
	abase->print = AbstractBasePrint;
	abase->destroy = AbstractBaseDestroy;
	strncpy( abase->data, data, MAX_ABSTRACT_BASE_DATA_SIZE - 2 );
	abase->data[MAX_ABSTRACT_BASE_DATA_SIZE - 1] = '\0';
}

// abstract class DecoratorStruct extends AbstractBaseStruct
#define DecoratorStruct				AbstractBaseStruct		// but going to make [print & destroy] pure virtual
#define DecoratorConstructor		InterfaceConstructor

void DecoratorInit( DecoratorStruct* decor, char* data, void (*func1) (void*), void (*func2) (void*) )
{
	if ( ! decor ) {
		assert( "decorator: \"this\" is missing\n" );
		return;
	}
	if ( ! data || ! *data ) {
		assert( "abstract base: missing data ptr\n" );
		return;
	}
	if ( ! func1 || ! func2 ) {
		assert( "decorator: missing function assignment\n" );
		return;
	}
	decor->print = func1;
	decor->destroy = func2;
	strncpy( decor->data, data, MAX_ABSTRACT_BASE_DATA_SIZE - 2 );
	decor->data[MAX_ABSTRACT_BASE_DATA_SIZE - 1] = '\0';
}


/* think of this as burying the concrete object under layers and layers of "decorations".
 * this is a one shot interface -- i.e. can only really be used in one way (one direction).
 *
 * DO NOT USE THIS TO BURY A LIST WITHIN THIS PATTERN -- the resulting "composite" cannot
 * be used outside of its intended purpose.  you will need a custom peeler just to get back
 * to the concrete object.  i.e. a general iterator cannot be used with this "composite". */


// class ConcreteBaseStruct extends AbstractBaseStruct
// #define ConcreteBaseStruct		AbstractBaseStruct
typedef struct {
	AbstractBaseStruct abase;				// for clarity, this is spelled out for you...
} ConcreteBaseStruct;

ConcreteBaseStruct* ConcreteBaseContructor( char* data )
{
	ConcreteBaseStruct* cbase;

	if ( ! data || ! *data ) {
		assert( "concrete base: missing data ptr\n" );
		return NULL;
	}

	cbase = (ConcreteBaseStruct*)malloc( sizeof(ConcreteBaseStruct) );
	if ( cbase )
		AbstractBaseInit( &cbase->abase, data );
	return cbase;
}

// class ConcreteDecoratorStruct extends DecoratorStruct
typedef struct {
	DecoratorStruct this;
	AbstractBaseStruct* next;				// that's all a decorator is...
} ConcreteDecoratorStruct;

void ConcreteDecoratorPrint( void* ptr )
{
	if ( ptr ) {
		ConcreteDecoratorStruct* decor = (ConcreteDecoratorStruct*)ptr;
		printf( "\t%s", decor->this.data );
		decor->next->print( decor->next );
	}
}

void ConcreteDecoratorDestroy( void* ptr )
{
	if ( ptr ) {
		ConcreteDecoratorStruct* decor = (ConcreteDecoratorStruct*)ptr;
		decor->next->destroy( decor->next );
		free( decor );
	}
}

ConcreteDecoratorStruct* ConcreteDecoratorContructor( ConcreteBaseStruct* cbase, char* data )
{
	ConcreteDecoratorStruct* decor;

	if ( ! cbase ) {
		assert( "concrete decorator: missing extended base object\n" );
		return NULL;
	}
	if ( ! data || ! *data ) {
		assert( "concrete decorator: missing data ptr\n" );
		return NULL;
	}

	decor = (ConcreteDecoratorStruct*)malloc( sizeof(ConcreteDecoratorStruct) );
	if ( decor ) {
		DecoratorInit( &decor->this, data, ConcreteDecoratorPrint, ConcreteDecoratorDestroy );
		decor->next = (AbstractBaseStruct*)cbase;
	}
	return decor;
}

/* THE DEMO */
void Decorator()
{
	char* icecream[] = { "on chocolate", "on strawberry", "on vanilla", "pecan" };
	char* toppings[] = { "cherries", "fudge", "nuts", "sprinkles" };

	ConcreteBaseStruct* dessert1 = ConcreteBaseContructor( icecream[0] );
	ConcreteBaseStruct* dessert2 = ConcreteBaseContructor( icecream[1] );
	ConcreteBaseStruct* dessert3 = ConcreteBaseContructor( icecream[2] );
	ConcreteBaseStruct* dessert4 = ConcreteBaseContructor( icecream[3] );
	ConcreteDecoratorStruct* decor1;
	ConcreteDecoratorStruct* decor2;
	ConcreteDecoratorStruct* decor3;

	printf( "\nDecorator()\n" );
	dessert1 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert1, toppings[0] );
	dessert1 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert1, toppings[1] );
	dessert1 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert1, toppings[2] );
	dessert1 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert1, toppings[3] );
	decor1 = (ConcreteDecoratorStruct*)dessert1;

	dessert2 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert2, toppings[2] );
	dessert2 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert2, toppings[2] );
	dessert2 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert2, toppings[0] );
	decor2 = (ConcreteDecoratorStruct*)dessert2;

	dessert3 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert3, toppings[0] );
	dessert3 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert3, toppings[2] );
	dessert3 = (ConcreteBaseStruct*)ConcreteDecoratorContructor( dessert3, toppings[1] );
	decor3 = (ConcreteDecoratorStruct*)dessert3;

	decor1->this.print( decor1 );
	decor2->this.print( decor2 );
	decor3->this.print( decor3 );
	dessert4->abase.print( dessert4 );

	// cleanup
	decor1->this.destroy( decor1 );			dessert1 = NULL;	decor1 = NULL;
	decor2->this.destroy( decor2 );			dessert2 = NULL;	decor2 = NULL;
	decor3->this.destroy( decor3 );			dessert3 = NULL;	decor3 = NULL;
	dessert4->abase.destroy( dessert4 );	dessert4 = NULL;
}


/* Decorator: }}}2 */
/* Proxy: {{{2
 * ----------------------------------------
 * - Provide a surrogate or placeholder for another object to control access/references to it.
 * - Use an extra level of indirection to support distributed, controlled, or intelligent access.
 * - Add a wrapper and delegation to protect the real component from undue complexity.
 */

typedef struct {					// the original object
	unsigned int cash;
} BankAccountStruct;

BankAccountStruct* BankAccountConstructor( unsigned int amount )
{
	BankAccountStruct* acct = (BankAccountStruct*)malloc( sizeof(BankAccountStruct) );
	if ( acct )
		acct->cash = amount;
	return acct;
}

// proxy to the cash in bank account
typedef struct BankAccountAccessStruct {
	        void (*deposit) ( struct BankAccountAccessStruct*, BankAccountStruct*, unsigned int );
	unsigned int (*withdraw)( struct BankAccountAccessStruct*, BankAccountStruct*, unsigned int );
	unsigned int cash;				// amount this object represents -- i.e. on withdrawals
	unsigned int balance;			// last known amount in account after this transaction
} BankAccountAccessStruct;

void BankDeposit( BankAccountAccessStruct* this, BankAccountStruct* acct, unsigned int amount )
{
	if ( this && acct ) {
		acct->cash += amount;
		this->cash = 0;
		this->balance = acct->cash;
	}
}

unsigned int BankWithdraw( BankAccountAccessStruct* this, BankAccountStruct* acct, unsigned int amount )
{
	if ( ! this || ! acct )
		return 0;

	if ( amount > acct->cash )
		return 0;					/* insufficient funds */
	acct->cash -= amount;
	this->cash = amount;
	this->balance = acct->cash;
	return amount;
}

#define ATMStruct					BankAccountAccessStruct

ATMStruct* ATMConstructor( void )
{
	ATMStruct* acct = (ATMStruct*)malloc( sizeof(ATMStruct) );
	if ( acct ) {
		acct->deposit = BankDeposit;
		acct->withdraw = BankWithdraw;
		acct->cash = 0;				/* init */
		acct->balance = 0;			/* init */
	}
	return acct;
}

#define eBankStruct					BankAccountAccessStruct
#define eBankConstructor			ATMConstructor

#define CheckStruct					BankAccountAccessStruct

void BankDepositToCheck( BankAccountAccessStruct* this, BankAccountStruct* acct, unsigned int amount )
{
	(void) this;	/* unused */
	(void) acct;	/* unused */
	(void) amount;	/* unused */

	assert( "depositing to a check makes no sense\n" );
	/* i.e. checks only make withdrawals
	 * depositing "with" checks uses BankDeposit() */
}

unsigned int BankWithdrawByCheck( BankAccountAccessStruct* this, BankAccountStruct* acct, unsigned int amount )
{
	unsigned int withdrawal = BankWithdraw( this, acct, amount );
	if ( this )
		this->cash = 0;				/* remember, this object is not cash */
	return withdrawal;
}

CheckStruct* CheckConstructor( void )
{
	CheckStruct* acct = (CheckStruct*)malloc( sizeof(CheckStruct) );
	if ( acct ) {
		acct->deposit = BankDepositToCheck;
		acct->withdraw = BankWithdrawByCheck;
		acct->cash = 0;				/* init */
		acct->balance = 0;			/* init */
	}
	return acct;
}


/* normally, this pattern is used to describe RPC (remote procedure calls) or some
 * basic networking server/client programming.  in JAVA, RMI (remote method invocation)
 * is their version of the object based representation of this pattern.  this may
 * be covered in another (networking) cheatsheet. =)
 *
 * so, the examples above show the proxy objects handling the base class externally.
 * networking proxy on the other hand can/will go other way, where the base class will
 * understand (implement) the remote proxy interface.  again, to be covered in the
 * networking cheatsheet */


/* THE DEMO */
void Proxy()
{
	unsigned int amount;

	BankAccountStruct* store;
	eBankStruct* eBank;

	BankAccountStruct* savings;
	ATMStruct* atm;
	CheckStruct* check;

	printf( "\nProxy()\n" );
	store = BankAccountConstructor( 1000000 );	/* one million dollars */
	savings = BankAccountConstructor( 100 );

	/* get proxy objects */
	eBank = eBankConstructor();
	atm = ATMConstructor();
	check = CheckConstructor();

	/* do some transactions */
	if ( ! store || ! eBank || ! savings || ! atm || ! check )
		goto cleanup;

	printf( "\tsavings balance: %d\n", savings->cash );
	printf( "\n" );

	amount = 10;
	printf( "\tdepositing: %d\n", amount );
	atm->deposit( atm, savings, amount );
	printf( "\tbalance after deposit: %d\n", atm->balance );
	printf( "\n" );

	amount = 5;
	printf( "\twithdrawing: %d\n", amount );
	atm->withdraw( atm, savings, amount );
	printf( "\tbalance after withdrawal: %d\n", atm->balance );
	printf( "\tcash in hand after withdrawal: %d\n", atm->cash );
	printf( "\n" );

	printf( "\tstore balance: %d\n", store->cash );
	amount = 20;
	printf( "\tpurchasing merchandise for %d\n", amount );
	eBank->deposit( eBank, store, check->withdraw( check, savings, amount ) );
	printf( "\tstore balance: %d\n", eBank->balance );
	printf( "\tsavings balance: %d\n", check->balance );

cleanup:
	if ( store )	free( store );		store = NULL;
	if ( eBank )	free( eBank );		eBank = NULL;
	if ( savings )	free( savings );	savings = NULL;
	if ( atm )		free( atm );		atm = NULL;
	if ( check )	free( check );		check = NULL;
}


/* Proxy: }}}2
 * Structural Design Patterns }}}
 * Behavioral Design Patterns {{{
 * ======================================== */

/* Interpreter: {{{2
 * ----------------------------------------
 * - Given a language, define a representation for its grammar along with an
 *   interpreter that uses the representation to interpret sentences in the language.
 *   i.e. Map a domain to a language, the language to a grammar, and the grammar
 *   to a hierarchical object-oriented design.
 */


// this will be deferred to the lexical analyzer generator and compiler cheatsheets:
// i.e. lex & yacc | flex & bison | LLVM cheatsheets


/* Interpreter: }}}2 */
/* Template Method: {{{2
 * ----------------------------------------
 * - Define the skeleton of an algorithm in an operation, deferring some steps to subclasses.
 *   i.e. Lets subclasses redefine certain steps of an algorithm without letting them
 *        change the algorithm's structure.
 * - Base class declares algorithm “placeholders”, and derived classes implement the placeholders.
 */

// abstract class
typedef struct TemplateMethodStruct {
	void (*boilWater)(void);
	void (*brew)(void);					// note: pure virtual
	void (*pourInCup)(void);
	void (*addCondiments)(void);		// note: pure virtual
	void (*prepareRecipe)(struct TemplateMethodStruct*);		// the template method
} TemplateMethodStruct;

void boilWater() { printf( "\tBoiling water\n" ); }
void pourInCup() { printf( "\tPouring into cup\n" ); }
/* final */ void prepareRecipe( TemplateMethodStruct* caffeine )
{
	// this function would be declared as "final":
	// all sub classes MUST follow these steps
	// but sub classes can implement their own (in this case) brew() and addCondiments()
	if ( caffeine ) {
		caffeine->boilWater();
		caffeine->brew();
		caffeine->pourInCup();
		caffeine->addCondiments();
	}
}

void TemplateMethodInit( TemplateMethodStruct* caffeine, void(*func1)(void), void(*func2) )
{
	if ( ! caffeine ) {
		assert( "template method: \"this\" is missing\n" );
		return;
	}
	if ( ! func1 || ! func2 ) {
		assert( "template method: missing function assignment\n" );
		return;
	}
	caffeine->boilWater = boilWater;
	caffeine->brew = func1;
	caffeine->pourInCup = pourInCup;
	caffeine->addCondiments = func2;
	caffeine->prepareRecipe = prepareRecipe;
}

#define TemplateMethodConstructor	InterfaceConstructor
#define CaffeineBeverage			TemplateMethodStruct		// abstract class
#define Tea							TemplateMethodStruct		// sub class
#define Coffee						TemplateMethodStruct		// sub class

//class Tea extends CaffeineBeverage
void TeaBrew() { printf( "\tSteeping the tea\n" ); }
void TeaAddCondiments() { printf( "\tAdding Lemon\n" ); }

Tea* TeaConstructor( void )
{
	Tea* caffeine = malloc( sizeof(Tea) );
	if ( caffeine )
		TemplateMethodInit( caffeine, TeaBrew, TeaAddCondiments );
	return caffeine;
}

//class Coffee extends CaffeineBeverage
void CoffeeBrew() { printf( "\tDripping Coffee through filter\n" ); }
void CoffeeAddCondiments() { printf( "\tAdding Sugar and Milk\n" ); }

Coffee* CoffeeConstructor( void )
{
	Coffee* caffeine = malloc( sizeof(Coffee) );
	if ( caffeine )
		TemplateMethodInit( caffeine, CoffeeBrew, CoffeeAddCondiments );
	return caffeine;
}

/* THE DEMO */
void Template_Method()
{
	CaffeineBeverage* caffeine[2];
	int i;

	printf( "\nTemplate_Method()\n" );
	caffeine[0] = TeaConstructor();
	caffeine[1] = CoffeeConstructor();
	for ( i = 0; i < 2; i++ ) {
		if ( caffeine[i] ) {
			caffeine[i]->prepareRecipe( caffeine[i] );
			printf( "\n" );
			free( caffeine[i] );		/* clean up */
	}	}
}


/* Template Method: }}}2 */
/* Chain of Responsibiliy: {{{2
 * ----------------------------------------
 * - It avoids attaching the sender of a request to its receiver,
 *   giving this way other objects the possibility of handling the request too.
 * - The objects become parts of a chain and the request is sent from one object
 *   to another across the chain until one of the objects will handle it.
 *
 * - Launch-and-leave requests with a single processing pipeline that contains
 *   many possible handlers.
 * - An object-oriented linked list with recursive traversal.
 */

typedef enum { Quarter, Nickle, Dime, Penny } CoinEnum;

typedef struct ChainOfReponsibilityStruct {
	void (*handler)( struct ChainOfReponsibilityStruct*, CoinEnum );
	struct ChainOfReponsibilityStruct* next;
} ChainOfReponsibilityStruct;

ChainOfReponsibilityStruct* ChainOfReponsibilityConstructor( ChainOfReponsibilityStruct* chain, void(*handler)(ChainOfReponsibilityStruct*, CoinEnum) )
{
	ChainOfReponsibilityStruct* object;
	if ( ! handler ) {
		assert( "chain: missing function assignment\n" );
		return NULL;
	}
	object = (ChainOfReponsibilityStruct*)malloc( sizeof(ChainOfReponsibilityStruct) );
	if ( object ) {
		object->handler = handler;
		object->next = chain;
	}
	return object;
}

void QuarterHandler( ChainOfReponsibilityStruct* chain, CoinEnum coin )
{
	if ( coin == Quarter )
		printf( "\tFound Quarter\n" );
	else
		chain->next->handler( chain->next, coin );
}

void NickleHandler( ChainOfReponsibilityStruct* chain, CoinEnum coin )
{
	if ( coin == Nickle )
		printf( "\tFound Nickle\n" );
	else
		chain->next->handler( chain->next, coin );
}

void DimeHandler( ChainOfReponsibilityStruct* chain, CoinEnum coin )
{
	if ( coin == Dime )
		printf( "\tFound Dime\n" );
	else
		chain->next->handler( chain->next, coin );
}

void PennyHandler( ChainOfReponsibilityStruct* chain, CoinEnum coin )
{
	if ( coin == Penny )
		printf( "\tFound Penny\n" );
	else
		chain->next->handler( chain->next, coin );
}

void DefaultHandler( ChainOfReponsibilityStruct* chain, CoinEnum coin )
{
	printf( "\tUnknown Coin Found\n" );
}

ChainOfReponsibilityStruct* ChainSetup()
{
	ChainOfReponsibilityStruct* chain;
	chain = ChainOfReponsibilityConstructor( NULL, DefaultHandler );
	chain = ChainOfReponsibilityConstructor( chain, PennyHandler );
	chain = ChainOfReponsibilityConstructor( chain, DimeHandler );
	chain = ChainOfReponsibilityConstructor( chain, NickleHandler );
	chain = ChainOfReponsibilityConstructor( chain, QuarterHandler );
	return chain;
}

void ChainTearDown( ChainOfReponsibilityStruct* chain )
{
	if ( chain ) {
		if ( chain->next )
			ChainTearDown( chain->next );
		free( chain );
	}
}

/* THE DEMO */
void Chain_Of_Responsibility()
{
	int i;
	CoinEnum coins[] = {
		Quarter,
		Nickle,
		Quarter,
		Dime,
		Penny,
		Nickle,
		Penny,
		Quarter,
		Dime,
		Quarter,
		Penny,
		Nickle,
		-1
	};
	ChainOfReponsibilityStruct* chain;

	printf( "\nChain_Of_Responsibility()\n" );
	chain = ChainSetup();

	for ( i = 0; coins[i] != -1; i++ )
		chain->handler( chain, coins[i] );

	ChainTearDown( chain );
}


/* Chain of Responsibiliy: }}}2 */
/* Command: {{{2
 * ----------------------------------------
 * - Encapsulate a request in an object.
 * - Allows the parameterization of clients with different requests.
 * - Allows saving the requests in a queue.
 *
 * - Promote "invocation of a method on an object" to full object status.
 */

// a simple command pattern example:
//class RemoteControlTest {									/* the client*/
//	RemoteControl remote = new RemoteControl();				/* the invoker */
//	Light light = new Light();								/* the receiver */
//	LightOnCommand lightOn = new LightOnCommand(light);		/* the command (with receiver passed to it) */
//	remote.setCommand(lightOn);								/* pass the command to the invoker */
//	remote.buttonWasPressed();								/* execute the command */
//}


/* in a nutt-shell:
 *
 * [ CLIENT ] will trigger the requests
 * [ INVOKER ] will take the requests and translate to commands
 * [ RECEIVER ] handles the commands
 *
 * obtain a table of [ COMMANDS ] (the capabilites the receiver can do)
 * commands are [ SETUP ] with the invoker (so invoker knows how to call the commands)
 * so by the time the client makes the requests,
 * - the commands can be [ EXECUTED ] via the invoker
 *   (which is ultimately done by the receiver)
 *
 * the commands can also be stacked (queued).  */

typedef struct {
	void(*funcs[4])(void);
} CommandStruct;

#define CommandInvoker				CommandStruct
#define CommandReceiver				CommandStruct

/* an example */
#define GamePad						CommandInvoker
void Command_Button( GamePad* pad, int index )				/* execute the command */
{
	if ( pad && pad->funcs[index] )
		pad->funcs[index]();
}

#define GameCharacter				CommandReceiver
/* the commands */
void Command_Run()    { printf( "\tcharacter is running\n" ); }
void Command_Jump()   { printf( "\tcharacter is jumping\n" ); }
void Command_Attack() { printf( "\tcharacter is attacking\n" ); }
void Command_Block()  { printf( "\tcharacter is blocking\n" ); }

void GameCharacterInit( GameCharacter* plyr )
{
	if ( plyr ) {
		plyr->funcs[0] = Command_Run;
		plyr->funcs[1] = Command_Jump;
		plyr->funcs[2] = Command_Attack;
		plyr->funcs[3] = Command_Block;
	}
}

/* the command (with receiver passed to it) */
void CommandRecveiver_SetAction( GameCharacter* plyr, void(*func)(void), int index )
{
	if ( plyr )
		plyr->funcs[index] = func;
}

/* pass the command to the invoker
 * i.e. take the (client) requests and translate to commands */
void Command_SetButton( GamePad* pad, int padIndex, GameCharacter* plyr, int plyrIndex )
{
	/* think of this function as a configurable button assignment to the available actions
	 * such as, left handed versus right handed players,
	 * or "i like my run botton on the top not the bottom...", etc*/
	if ( pad && plyr )
		pad->funcs[padIndex] = plyr->funcs[plyrIndex];
}

/* THE DEMO -- the client */
void Command()
{
	GamePad pad;
	GameCharacter plyr;
	int button_configuration[][4] = {
		{ 0, 1, 2, 3 },		/* run=b0 jump=b1 attack=b2 block=b3 */
		{ 2, 3, 1, 0 }		/* run=b2 jump=b3 attack=b1 block=b0 */
	};
	int button_sequence[] = { 0, 1, 2, 3, 1, 3, 1, 2, 3, 1, 2, -1 };
	int i, j, k;

	printf( "\nCommand()\n" );
	GameCharacterInit( &plyr );
	for ( i = 0; i < 2; i++ ) {

		/* configure buttons */
		for ( j = 0; j < 4; j++ )
			Command_SetButton( &pad, button_configuration[i][j], &plyr, j );

		/* invoke - execute command */
		for ( k = 0; button_sequence[k] > -1; k++ )
			Command_Button( &pad, button_sequence[k] );

		printf( "\n" );
	}
}


/* Command: }}}2 */
/* Iterator: {{{2
 * ----------------------------------------
 * - Provide a way to access the elements of an aggregate object sequentially
 *   without exposing its underlying representation.
 *
 * - Polymorphic traversal
 */

// GList callback / predicate (implementation) functions
// "protected" structural::composite interface
void _blitlist_delete_element( gpointer data, gpointer user_data )
{
	(void) user_data;	/* unused */
	_blitlist_delete( (BlitStruct*)data );
}


// "public" structural::composite interface functions
void
blitlist_nuke()
{
	g_list_foreach( _blitlist, _blitlist_delete_element, NULL );
	g_list_free( _blitlist );
	_blitlist = NULL;
}

GList*
blitlist_submit( BlitStruct* blit, GList* list )
{
	return g_list_insert( list, blit, -1 );
}

int
blitlist_blit( GList* list, int level )
{
	GList *element;
	if ( ! list ) return 0;
	element = g_list_first( list );
	while ( element ) {
	    if ( _blitlist_blit( element->data, level ) ) return -1;
	    element = g_list_next( element );
	}
	return 0;
}


/* THE DEMO */
void Iterator()
{
	/*  1 = an object
	 *  0 = a leaf
	 * -1 = terminates the list
	 */
	int blit_data[] = {
		1, 1, 1,				// background objects
		   0, 1, 1, -1,			// a building on the background
		1, 1,					// foreground objects
		   0, 1,				// a player
		      0, 1, 1, -1,		// player's weapon
		   1, -1,				// another player
		1, -1					// hud
	};							// =)
	int size = sizeof( blit_data ) / sizeof( blit_data[0] );

	printf( "\nComposite()" );
	printf( "\nFlyweight()" );
	printf( "\nFaçade()" );
	printf( "\nIterator()\n" );
	FacadeBlit_Setup( blit_data, size );
	blitlist_blit( _blitlist, 0 );
}


/* Iterator: }}}2 */
/* Mediator: {{{2
 * ----------------------------------------
 * - Define an object that encapsulates how a set of objects interact.
 * - Mediator promotes loose coupling by keeping objects from referring to each
 *   other explicitly, and it lets you vary their interaction independently.
 *
 * - Design an intermediary to decouple many peers.
 * - Promote the many-to-many relationships between interacting peers to
 *   "full object status".
 */

/* basically, a mediator is the core LOGIC controller/handler for all of the objects
 * attached/registered to it.  it pulls all of the watching, notifications, probing,
 * querying, what ever... to the mediator and out of objects (peers) */

// an example:
// [coffee pot] would like to know if alarm (clock) has triggered so to know to start brewing
// but, only on weekdays (calendar)...
//
// [sprinkler] would like to turn on during the mornings (clock)... but not during winter (calendar)
//
// - so -
// [calendar] and [clock] have competing control issues
// - or -
// [coffee pot] and [sprinkler] needs to query [clock] and [calendar] to
// determine if action is needed
// - as well as -
// [clock] needs to tell [coffee pot] and/or [sprinkler] to do something
// at a certain time while consulting the [calendar]
//
// - a solution -
// a [smart house controller] (mediator) is needed to handle all of these while
// keeping all the other stuff "dumb" -- i.e. just doing what they were designed to do

typedef struct {
	int (*GetDate) (void);			// 1 = isWinter
} CalendarStruct;

typedef struct {
	int (*GetTime) (void);			// 1 = alarm
} ClockStruct;

typedef struct {
	void (*MakeCoffee) (void);
} CoffeePotStruct;

typedef struct {
	void (*WaterLawn) (void);
} SprinklerStruct;

int GetDate()
{
	printf( "\tit is today\n" );
	return rand() % 2;				/* isWinter: rand() for demonstration purposes only */
}

int GetTime()
{
	printf( "\tit is now o'clock\n" );
	return rand() % 2;				/* alarm: rand() for demonstration purposes only */
}

void MakeCoffee()
{
	printf( "\tcoffee is brewing\n" );
}

void WaterLawn()
{
	printf( "\tsprinkler is a sprinkling\n" );
}


/* THE DEMO */
void Mediator()
{
	CalendarStruct	calendar	= { GetDate };
	ClockStruct		clock		= { GetTime };
	CoffeePotStruct	coffee		= { MakeCoffee };
	SprinklerStruct	sprinkler	= { WaterLawn };
	int isWinter = calendar.GetDate();
	int alarmEvent = clock.GetTime();
	int i;

	printf( "\nMediator()\n" );
	srand( time(NULL) );

	/* the smart house controller */
	for ( i = 0; i < 2; i++ ) {
		printf( "\t%s pass\n", ! i ? "first" : "second" );
		if ( alarmEvent )
			coffee.MakeCoffee();
		if ( isWinter )
			sprinkler.WaterLawn();
		/* for demonstration purposes only: flip the bits */
		alarmEvent = 1 - alarmEvent;
		isWinter = 1 - isWinter;
	}
}


/* Mediator: }}}2 */
/* Memento: {{{2
 * ----------------------------------------
 * - Capture the internal state of an object without violating encapsulation and
 *   thus providing a mean for restoring the object into initial state when needed.
 *
 * - Promote "check point" capability such as undo or rollback to full object status.
 *
 * - capture and restore an object's internal state
 */

/* it would be too easy to show this example if the "live"
 * object was the same as the "checkpoint" object. */

#define LiveQueue					GQueue
#define MementoQueue				GQueue

/* so making this a little more useful as a learning example... */

typedef struct {
	int state1;						// essential checkpoint data
	int calculations;				// deterministic data, i.e. non-essential for checkpointing
	int state2;						// essential checkpoint data
	// other non-essential data...
} LiveStruct;

// note: this is not used as an abstract object to be subclassed,
//      keeping the two object distinctly separate.
typedef struct {
	int state1;						// essential checkpoint data
	int state2;						// essential checkpoint data
} MementoStruct;

MementoStruct* MementoConstructor( LiveStruct* live )
{
	MementoStruct* memento = (MementoStruct*)malloc( sizeof(MementoStruct) );
	if ( memento ) {
		memento->state1 = live->state1;
		memento->state2 = live->state2;
	}
	return memento;
}

LiveStruct* LiveConstructor( void )
{
	return (LiveStruct*)malloc( sizeof(LiveStruct) );
}

LiveStruct* LiveFromMemento( MementoStruct* memento )
{
	LiveStruct* live = LiveConstructor();
	if ( live ) {
		live->state1 = memento->state1;
//		live->calculations;		// don't care right now...
		live->state2 = memento->state2;
		// all other member are don't care right now...
	}
	return live;
}

/* the mechanism */
void _LiveAppend( gpointer memento /*data*/, gpointer lqueue /*user_data*/ )
{
	LiveStruct* live = LiveFromMemento( (MementoStruct*)memento );
	if ( live )
		g_queue_push_tail( (LiveQueue*)lqueue, live );
}

void _MementoAppend( gpointer live /*data*/, gpointer mqueue /*user_data*/ )
{
	MementoStruct* memento = MementoConstructor( (LiveStruct*)live );
	if ( memento )
		g_queue_push_tail( (MementoQueue*)mqueue, memento );
}

void _NukeElement( gpointer data, gpointer user_data )
{
	(void) user_data;	/* unused */
	free( data );
}

void ClearQueue( GQueue* queue )
{
	if ( queue ) {
		g_queue_foreach( queue, _NukeElement, NULL );
		g_queue_clear( queue );
	}
}

void PrintLiveQueue( gpointer data, gpointer user_data )
{
	(void) user_data;	/* unused */
	printf( " %d", ((LiveStruct*)data)->state2 );
}


void PrintMementoQueue( gpointer data, gpointer user_data )
{
	(void) user_data;	/* unused */
	printf( " %d", ((MementoStruct*)data)->state2 );
}


/* the familiar functions */
MementoQueue* check_point( LiveQueue* lqueue )
{
	MementoQueue* checkpoint = g_queue_new();
	if ( ! checkpoint ) {
		printf( "unable to allocate queue...\n" );
		return NULL;
	}
	g_queue_foreach( lqueue, _MementoAppend, checkpoint );
	return checkpoint;
}

void check_point_delete( MementoQueue* mqueue )
{
	if ( mqueue ) {
		ClearQueue( mqueue );
		g_queue_free( mqueue );
	}
}

void roll_back( LiveQueue* lqueue, MementoQueue* checkpoint )
{
	ClearQueue( lqueue );
	g_queue_foreach( checkpoint, _LiveAppend, lqueue );
}


/* THE DEMO */
void Memento()
{
	LiveStruct* live;
	LiveQueue* lqueue;
	MementoQueue* mqueue1;
	MementoQueue* mqueue2;
	int i;

	printf( "\nMemento()\n" );
	lqueue = g_queue_new();
	if ( ! lqueue ) {
		printf( "unable to allocate queue...\n" );
		return;
	}

	printf( "\tfilling live queue\n" );
	for ( i = 0; i < 5; i++ ) {
		live = LiveConstructor();
		if ( live ) {
			live->state2 = i;
			g_queue_push_tail( lqueue, live );
	}	}
	printf( "\tlive: [" ); g_queue_foreach( lqueue, PrintLiveQueue, NULL ); printf( " ]\n" );

	printf( "\t1st check point\n" );
	mqueue1 = check_point( lqueue );

	printf( "\tfilling live queue with more data\n" );
	for ( i = 5; i < 10; i++ ) {
		live = LiveConstructor();
		if ( live ) {
			live->state2 = i;
			g_queue_push_tail( lqueue, live );
	}	}
	printf( "\tlive: [" ); g_queue_foreach( lqueue, PrintLiveQueue, NULL ); printf( " ]\n" );

	printf( "\t2nd check point\n" );
	mqueue2 = check_point( lqueue );

	printf( "\tclearing live queue\n" );
	ClearQueue( lqueue );
	printf( "\tlive: [" ); g_queue_foreach( lqueue, PrintLiveQueue, NULL ); printf( " ]\n" );

	printf( "\trestoring live queue to 2nd checkpoint\n" );
	roll_back( lqueue, mqueue2 );
	printf( "\tlive: [" ); g_queue_foreach( lqueue, PrintLiveQueue, NULL ); printf( " ]\n" );

	printf( "\trestoring live queue to 1st checkpoint\n" );
	roll_back( lqueue, mqueue1 );
	printf( "\tlive: [" ); g_queue_foreach( lqueue, PrintLiveQueue, NULL ); printf( " ]\n" );

	/* clean up */
	ClearQueue( lqueue );
	g_queue_free( lqueue );

	check_point_delete( mqueue1 );
	check_point_delete( mqueue2 );
}


/* Memento: }}}2 */
/* Observer: {{{2
 * ----------------------------------------
 * - Define a one-to-many dependency between objects so that when one object
 *   changes state, all its dependents are notified and updated automatically.
 *
 * - Encapsulate the core (or common or engine) components in a Subject abstraction,
 *   and the variable (or optional or user interface) components in an Observer hierarchy.
 * - The "View" part of Model-View-Controller.
 *
 * - Publishers + Subscribers = Observer Pattern
 */

typedef struct {
	int  value;
	union {								// the many different names/labels all doing the same thing
	   GList* views;
	   GList* subscribers;
	   GList* listeners;
	};
} SubjectStruct;


typedef struct ObserverStruct {
	void (*update) ( struct ObserverStruct*, int ); // note: pure virtual
} ObserverStruct;

void ObserverAttach( SubjectStruct* subject, ObserverStruct* observer )
{
	if ( ! subject || ! observer ) {
		assert( "attach: object(s) missing\n" );
		return;
	}
	subject->views = g_list_insert( subject->views, observer, -1 );
}

void ObserverNotify( SubjectStruct* subject )
{
	GList *element;
	if ( ! subject->views ) return;		// no one to notify
	element = g_list_first( subject->views );
	while ( element ) {
		ObserverStruct* observer = (ObserverStruct*)element->data;
		observer->update( observer, subject->value );
	    element = g_list_next( element );
	}
}


// more alternative names to this common pattern
#define ObserverSubscribe					attach
#define ObserverRegister					attach

#define ObserverPublish						notify
#define ObserverDispatch					notify


void SubjectSetValue( SubjectStruct* subject, int value )
{
	if ( subject ) {
		subject->value = value;
		ObserverNotify( subject );
	}
}


// class ObserverDivideStructDiv implements Observer
typedef struct {
	ObserverStruct o;
	int  divider;
} ObserverDivideStruct;

void ObserverDivideUpdate( ObserverStruct* o, int v )
{
	ObserverDivideStruct* observer = (ObserverDivideStruct*)o;
	printf( "\t%d / %d is %d\n", v, observer->divider, v / observer->divider );
}

ObserverDivideStruct* ObserverDivideConstructor( SubjectStruct* subject, int divider )
{
	ObserverDivideStruct* observer = (ObserverDivideStruct*)malloc( sizeof(ObserverDivideStruct) );
	if ( observer ) {
		ObserverAttach( subject, (ObserverStruct*)observer );
		observer->divider = divider;
		observer->o.update = ObserverDivideUpdate;
	}
	return observer;
}

// class ObserverModuloStructDiv implements Observer
typedef struct {
	ObserverStruct o;
	int  modulo;
} ObserverModuloStruct;

void ObserverModuloUpdate( ObserverStruct* o, int v )
{
	ObserverModuloStruct* observer = (ObserverModuloStruct*)o;
	printf( "\t%d %% %d is %d\n", v, observer->modulo, v % observer->modulo );
}

ObserverModuloStruct* ObserverModuloConstructor( SubjectStruct* subject, int modulo )
{
	ObserverModuloStruct* observer = (ObserverModuloStruct*)malloc( sizeof(ObserverModuloStruct) );
	if ( observer ) {
		ObserverAttach( subject, (ObserverStruct*)observer );
		observer->modulo = modulo;
		observer->o.update = ObserverModuloUpdate;
	}
	return observer;
}


/* THE DEMO */
void Observer()
{
	SubjectStruct subject;
	ObserverDivideStruct *observer1, *observer2;
	ObserverModuloStruct* observer3;

	printf( "\nObserver()\n" );
	subject.views = NULL;
	observer1 = ObserverDivideConstructor( &subject, 4 );
	observer2 = ObserverDivideConstructor( &subject, 3 );
	observer3 = ObserverModuloConstructor( &subject, 3 );
	SubjectSetValue( &subject, 14 );

	/* clean up */
	if ( observer1 ) free( observer1 );	observer1 = NULL;
	if ( observer2 ) free( observer2 ); observer2 = NULL;
	if ( observer3 ) free( observer3 ); observer3 = NULL;
	if ( subject.views ) g_list_free( subject.views );
}


/* Observer: }}}2 */
/* State: {{{2
 * ----------------------------------------
 * - Allow an object to alter its behavior when its internal state changes.
 *   The object will appear to change its class.
 * - An object-oriented state machine
 * - wrapper + polymorphic wrapper + collaboration
 */

typedef struct StateStruct {
	void (*animation)(struct StateStruct*);
	int hurdler;
} StateStruct;

void StateAnimationRunning( StateStruct* );

void StateAnimationLanding( StateStruct* state )
{
	if ( state->hurdler ) {
		state->animation = StateAnimationRunning;
		state->hurdler--;
	} else
		state->animation = NULL;
	printf( "\t\tlanding...\n" );
}

void StateAnimationJumping ( StateStruct* state )
{
	state->animation = StateAnimationLanding;
	printf( "\t\tjumping...\n" );
}

void StateAnimationRunning( StateStruct* state )
{
	state->animation = StateAnimationJumping;
	printf( "\trunning...\n" );
}

void StateAnimationStance ( StateStruct* state )
{
	state->animation = StateAnimationRunning;
	printf( "\tready stance...\n" );
}

StateStruct* StateConstructor( int hurdler )
{
	StateStruct* state = (StateStruct*)malloc( sizeof(StateStruct) );
	if ( state ) {
		state->animation = StateAnimationStance;
		state->hurdler = hurdler;
	}
	return state;
}


/* THE DEMO */
void State()
{
	StateStruct* long_jumper;
	StateStruct* hurdler;

	printf( "\nState()\n" );
	printf( "\t[ long jumper ]\n" );
	long_jumper = StateConstructor(0);
	if ( long_jumper ) {
		while( long_jumper->animation )
			long_jumper->animation( long_jumper );
		free( long_jumper );			/* clean up */
	}

	printf( "\n\t[ hurdler ]\n" );
	hurdler = StateConstructor(3);
	if ( hurdler ) {
		while( hurdler->animation )
			hurdler->animation( hurdler );
		free( hurdler );				/* clean up */
	}
}


/* State: }}}2 */
/* Strategy: {{{2
 * ----------------------------------------
 * - Define a family of algorithms, encapsulate each one, and make them interchangeable.
 *   i.e. Lets the algorithm vary independently from clients that use it.
 * - Capture the abstraction in an interface, bury implementation details in derived classes.
 */

typedef struct StrategyStruct {
	void (*transportation)( struct StrategyStruct* );
	char* data;
} StrategyStruct;

void StrategyCar( StrategyStruct* strategy )
{
	printf( "\t%s is going to drive to the airport\n", strategy->data );
	/* put key in car
	 * pedal to the metal */
}

void StrategyBus( StrategyStruct* strategy )
{
	printf( "\t%s is going to take the bus to the airport\n", strategy->data );
	/* pay fee
	 * sit/stand with other passengers */
}

void StrategyTaxi( StrategyStruct* strategy )
{
	printf( "\t%s is going to take a cab to the airport\n", strategy->data );
	/* get in vehicle
	 * pay fee at destination */
}

void StrategyLimo( StrategyStruct* strategy )
{
	printf( "\tJeeves is going to take %s to the airport\n", strategy->data );
	/* get in vehicle */
}

/* THE DEMO */
void Strategy()
{
	StrategyStruct strategy[] = {
		{ StrategyCar,  "Beth" },
		{ StrategyBus,  "Mike" },
		{ StrategyTaxi, "Tom" },
		{ StrategyLimo, "Devon" },
	};
	int i;

	printf( "\nStrategy()\n" );
	for ( i = 0; i < 4; i++ )
		strategy[i].transportation( &strategy[i] );
}


/* Strategy: }}}2 */
/* Visitor: {{{2
 * ----------------------------------------
 * - Represents an operation to be performed on the elements of an object structure.
 *
 * - A technique for recovering lost type information without resorting to dynamic casts.
 * - Do the right thing based on the type of two objects.
 * - Double dispatch
 */

/* this pattern shouldn't be used at all.
 * the vistor class contains all (overloaded) visit function to all classes it wants to molest.
 *
 * take a look at this example (streamlined a bit for clarity):
 * http://en.wikipedia.org/wiki/Visitor_pattern */
 
#if VISITOR_EXAMPLE_IN_C_PLUS_PLUS

struct Visitor;  // forward declaration (step 2)
 
struct Element
{
  virtual void accept(Visitor*) = 0;  // step 2
};
 
struct Foo : public Element
{
  void make_foo() { cout << "Making some Foo..." << endl; }
  virtual void accept(Visitor*);  // step 2
};
 
struct Bar : public Element
{
  void make_bar() { cout << "Making some Bar..." << endl; }
  virtual void accept(Visitor*);  // step 2
};
 
struct Baz : public Element
{
  void make_baz() { cout << "Making some Baz..." << endl; }
  virtual void accept(Visitor*);  // step 2
};
 
// Visitor classes (step 1)
struct Visitor
{
  virtual void visit(Foo*) = 0;
  virtual void visit(Bar*) = 0;
  virtual void visit(Baz*) = 0;
};
 
struct MakeVisitor : public Visitor
{
  virtual void visit(Foo* foo) { foo->make_foo(); }
  virtual void visit(Bar* bar) { bar->make_bar(); }
  virtual void visit(Baz* baz) { baz->make_baz(); }
};
 
struct CountVisitor : public Visitor
{
  CountVisitor() : foo_count(0), bar_count(0), baz_count(0) { }
  void print_counters() { cout << "Counters: Foo(" << foo_count << ") Bar(" << bar_count << ") Baz(" << baz_count << ")" << endl; }
 
  virtual void visit(Foo*) { ++foo_count; }
  virtual void visit(Bar*) { ++bar_count; }
  virtual void visit(Baz*) { ++baz_count; }
private:
  int foo_count, bar_count, baz_count;
};
 
// Implementing the accept(Visitor*) methods (step 2)
// This has to come after the definition of the Visitor base class.
void Foo::accept(Visitor* v) { v->visit(this); }
void Bar::accept(Visitor* v) { v->visit(this); }
void Baz::accept(Visitor* v) { v->visit(this); }

#endif // #if VISITOR_EXAMPLE_IN_C_PLUS_PLUS


/* the Visitor class is actually quite lazy and does absolutely nothing extraordinary.
 * it would make more sense to spell out the overloaded functions.
 *
 * then, this shows how the accept() function is basically a function wrapper to
 * make an indirect call to the vistor "visit" function.  again, nothing extraordinary. */

#if VISITOR_CLASS_REWRITTEN

// Visitor classes (step 1)
struct Visitor
{
  virtual void visitFoo(Foo*) = 0;
  virtual void visitBar(Bar*) = 0;
  virtual void visitBaz(Baz*) = 0;
};
 
struct MakeVisitor : public Visitor
{
  virtual void visitFoo(Foo* foo) { foo->make_foo(); }
  virtual void visitBar(Bar* bar) { bar->make_bar(); }
  virtual void visitBaz(Baz* baz) { baz->make_baz(); }
};
 
struct CountVisitor : public Visitor
{
  CountVisitor() : foo_count(0), bar_count(0), baz_count(0) { }
  void print_counters() { cout << "Counters: Foo(" << foo_count << ") Bar(" << bar_count << ") Baz(" << baz_count << ")" << endl; }
 
  virtual void visitFoo(Foo*) { ++foo_count; }
  virtual void visitBar(Bar*) { ++bar_count; }
  virtual void visitBaz(Baz*) { ++baz_count; }
private:
  int foo_count, bar_count, baz_count;
};
 
// Implementing the accept(Visitor*) methods (step 2)
// This has to come after the definition of the Visitor base class.
void Foo::accept(Visitor* v) { v->visitFoo(this); }
void Bar::accept(Visitor* v) { v->visitBar(this); }
void Baz::accept(Visitor* v) { v->visitBaz(this); }

#endif // #if VISITOR_CLASS_REWRITTEN


/* THE DEMO -- with the visit() function name changed to "spelled out for you"
 * version, this becomes nothing more than an abstract/interface example.
 *
 * see AbstractStruct or InterfaceStruct examples */


/* Visitor: }}}2 */
/* Null Object: {{{2
 * ----------------------------------------
 * - Provide an object as a surrogate for the lack of an object of a given type.
 *   i.e. Provides intelligent "do nothing" behavior, hiding the details from
 *   its collaborators.
*/

/* i.e. writing out stub functions */

/* THE DEMO -- see structural::bridge::bridge_someNewSQL_implimentation() */


/* Null Object: }}}2
 * Behavioral Design Patterns }}}
 * ======================================== */

int
main()
{
	Demo_Extends();
	Demo_Abstract_Implements();

	/* creational patterns */
	Factory_Simple();
	Abstract_Factory();
	Factory_Method();
	Builder();
	Prototype();
	Singleton();
	Object_Pool();

	/* structural patterns */
	Adapter();
	Bridge();
//	Composite();			// deferred to Iterator();
//	Flyweight();			// deferred to Iterator();
//	Façade();				// deferred to Iterator();
	Decorator();
	Proxy();

	/* behavioral patterns */
//	Interpreter();			// deferred to lexar parser and compiler cheatsheets
	Template_Method();
	Chain_Of_Responsibility();
	Command();
	Iterator();
	Mediator();
	Memento();
	Observer();
	State();
	Strategy();
//	Visitor();				// see notes on Visitor()
//	NullObject();			// deferred to Bridge();

	printf( "\n" );
	return 0;
}

