# Javascripts Notes

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>

* * *

## js optimization tips and notes

- <http://people.mozilla.com/~dmandelin/KnowYourEngines_Velocity2011.pdf>

* * *

## the module pattern

- <http://www.adequatelygood.com/2010/3/JavaScript-Module-Pattern-In-Depth>
	- good crash course on the module pattern for javascript
	- shows using `global import`...
- <http://briancray.com/posts/javascript-module-pattern>
	- a little 'nicer' use of `global import` (but not so good on 'augmentation')
- <http://macwright.org/2012/06/04/the-module-pattern.html>
	- nice explaination on how to **not** use `this`
	- as well as not having to use `prototype` nor require `new`

* * *

## Javascript: the good parts

- <http://www.crockford.com/javascript/private.html>

#### 3.5 Prototype

- method creates a new object that uses an old object as its prototype

```javascript
if (typeof Object.beget !== 'function') {
	Object.beget = function (o) {
		var F = function () {};
		F.prototype = o;
		return new F();
	};
}
var another_stooge = Object.beget(stooge);
```

#### 4.4 Arguments

```javascript
var sum = function ( ) {
	var i, sum = 0;
	for (i = 0; i < arguments.length; i += 1) {
		sum += arguments[i];
	}
	return sum;
};

document.writeln(sum(4, 8, 15, 16, 23, 42)); // 108
```

#### 4.7 Augmenting Types

- by augmenting Function.prototype, we can make a method available to all functions:

```javascript
Function.prototype.method = function (name, func) {
	if (!this.prototype[name]) { // Add a method conditionally.
		this.prototype[name] = func;
	}
	return this;
};
```

###### usage examples:

- C: int(n/m)

```javascript
Number.method('integer', function ( ) {
	return Math[this < 0 ? 'ceiling' : 'floor'](this);
});
document.writeln((-10 / 3).integer( )); // -3
```

- perl: chomp

```javascript
String.method('trim', function ( ) {
	return this.replace(/^\s+|\s+$/g, '');
});
document.writeln('"' + " neat ".trim( ) + '"');
```

#### 4.10 Closure

```javascript
var add_the_handlers = function (nodes) {
	var i;
	for (i = 0; i < nodes.length; i += 1) {
		nodes[i].onclick = function (i) {
			return function (e) {
				alert(i);
			};
		}(i); // THE CLOSURE
	}
};

// BAD EXAMPLE
var add_the_handlers = function (nodes) {
	var i;
	for (i = 0; i < nodes.length; i += 1) {
		nodes[i].onclick = function (e) {
			alert(i); // (i) is already nodes.length by the time this (onclick) is processed
		};
	}
};
```

#### 4.12 Module

- a function or object that presents an interface but that hides its state and implementation

```javascript
String.method('deentityify', function ( ) {
	// The entity table. It maps entity names to characters.
	// NOTE: this is evaulated only once
	var entity = {
		quot: '"',
		lt: '<',
		gt: '>'
	};

	// Return the deentityify method.
	return function ( ) {
		// This is the deentityify method. It calls the string replace method,
		// looking for substrings that start with '&' and end with ';'. If the
		// characters in between are in the entity table, then replace the entity
		// with the character from the table. It uses a regular expression (Chapter 7).
		return this.replace(
			/&([^&;]+);/g,
			function (a, b) {
				var r = entity[b];
				return typeof r === 'string' ? r : a;
			}
		);
	};
}( )); // NOTE: closure -- making this a module

// usage example:
document.writeln( '&lt;&quot;&gt;'.deentityify( )); // <">
```

- another module:

```javascript
var serial_maker = function ( ) {
	// Produce an object that produces unique strings. A unique string is made up
	// of two parts: a prefix and a sequence number. The object comes with methods
	// for setting the prefix and sequence number, and a gensym method that produces
	// unique strings.
	var prefix = '';
	var seq = 0;

	// look MA! no prototype declarations
	return {
		set_prefix: function (p) {
			prefix = String(p);
		},
		set_seq: function (s) {
			seq = s;
		},
		gensym: function ( ) {
			var result = prefix + seq;
			seq += 1;
			return result;
		}
	};
}( );

// usage example:
var seqer = serial_maker( );
seqer.set_prefix = 'Q';
seqer.set_seq = 1000;
var unique = seqer.gensym( ); // unique is "Q1000"

// another usage example:
thirdparty_function( seqer.gensym );
	// thirdparty_function would not be able to see 'prefix' or 'seq'
	// yet, seqer.gensym is still evaluated properly
```

#### 5.1 Pseudoclassical

```javascript
Function.method('new', function ( ) {
	// Create a new object that inherits from the constructor's prototype.
	var that = Object.beget(this.prototype);

	// Invoke the constructor, binding -this- to the new object.
	var other = this.apply(that, arguments);

	// If its return value isn't an object, substitute the new object.
	return (typeof other === 'object' && other) || that;
});

Function.method('inherits', function (Parent) {
	this.prototype = new Parent( );
	return this;
});

// usage example:
var Mammal = function (name) {
	this.name = name;
}.
	method('says', function() {
		return this.saying || '';
	}


var Cat = function (name) {
	this.name = name;
	this.saying = 'meow';
}.
	inherits(Mammal).
	method('purr', function (n) {
		...
		return s;
	}). method('get_name', function ( ) {
		return this.says( ) + ' ' + this.name + ' ' + this.says( );
	});
```

#### 5.3 Prototypal

- usage example:

```javascript
var myMammal = {
	name : 'Herb the Mammal',
	get_name : function ( ) {
		return this.name;
	},
	says : function ( ) {
		return this.saying || '';
	}
};

var myCat = Object.beget(myMammal);
myCat.name = 'Henrietta';
myCat.saying = 'meow';
myCat.purr = function (n) {
	...
	return s;
};
myCat.get_name = function ( ) {
	return this.says + ' ' + this.name + ' ' + this.says;
};
```

#### 5.4 Functional

- super() method

```javascript
Object.method('superior', function (name) {
	var that = this,
		method = that[name];
	return function ( ) {
		return method.apply(that, arguments);
	};
});

// usage example:
var coolcat = function (spec) {
	var that = cat(spec),
		super_get_name = that.superior('get_name');
	that.get_name = function (n) {
		return 'like ' + super_get_name( ) + ' baby';
	};
	return that;
};
var myCoolCat = coolcat({name: 'Bix'});
var name = myCoolCat.get_name( ); //	'like meow Bix meow baby'
```

#### 6.1 Array Literals

```javascript
var numbers = [
	'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'
];

var numbers_object = {
	'0': 'zero',
	'1': 'one',
	'2': 'two',
	'3': 'three',
	'4': 'four',
	'5': 'five',
	'6': 'six',
	'7': 'seven',
	'8': 'eight',
	'9': 'nine'
};
```

- Both produces a similar result
- Both `numbers` and `number_object` are objects containing 10 properties,
and those properties have exactly the same names and values
- But there are also significant differences:
	- `numbers` inherits from `Array.prototype`
	- whereas `number_object` inherits from `Object.prototype`
	- so `numbers` inherits a larger set of useful methods
- Also, `numbers` gets the mysterious `length` property, while `number_object` does not

#### 6.7 Dimensions

- if implementing algorithms that assume that every element starts with
a known value (such as 0), then the array must be prep manually.

```javascript
Array.dim = function (dimension, initial) {
	var a = [], i;
	for (i = 0; i < dimension; i += 1) {
		a[i] = initial;
	}
	return a;
}
// Make an array containing 10 zeros.
var myArray = Array.dim(10, 0);
```

- To make a two-dimensional array or an array of arrays,
again, must build the arrays manually:

```javascript
for (i = 0; i < n; i += 1) {
	my_array[i] = [];
}
// Note: Array.dim(n, []) will not work here.
// Each element would get a reference to the same array, which would be very bad.
```

* * *

#### A.4 Reserved Words

```javascript
abstract boolean break byte case catch char class const continue
debugger default delete do double else enum export extends
false final finally float for function goto
if implements import in instanceof int interface long
native new null package private protected public return
short static super switch synchronized
this throw throws transient true try typeof var volatile void
while with
```

- They cannot be used to name variables or parameters
- When reserved words are used as keys in object literals, they must be 'quoted'
- They "cannot" be used with the "dot" notation
	- so it is sometimes necessary to use the "bracket" notation instead:

```javascript
var method;                 // ok
var class;                  // illegal
object = {box: value};      // ok           object literal notation
object = {case: value};     // illegal      object literal notation
object = {'case': value};   // ok           object literal notation
object.box = value;         // ok              dot notiation
object.case = value;        // illegal         dot notiation
object['case'] = value;     // ok        subscript notiation
```

#### B.1 ==

JavaScript has two sets of equality operators:
- `===` and `!==`
- and their evil twins `==` and `!=`

The good ones work the way you would expect.
- If the two operands are of the same type and have the same value,
then `===` produces `true` and `!==` produces `false`

The evil twins do the right thing when the operands are of the same type,
- but if they are of different types, they attempt to coerce the values.

#### E.2. Using JSON Securely

<http://www.JSON.org/json2.js>

JSON.parse will throw an exception if the text contains anything dangerous.
It is recommended that you always use JSON.parse instead of eval() to defend
against server incompetence.

There is another danger in the interaction between external data and innerHTML.
A common Ajax pattern is for the server to send an HTML text fragment that
gets assigned to the innerHTML property of an HTML element. This is a very
bad practice. If the HTML text contains a &lt;script&gt; tag or its equivalent,
then an evil script will run. This again could be due to server incompetence.

* * *




<style>
.note1                    { font-size: 11px; }
pre                       { margin-left: 2em; }
.markdown-body pre code   { font-size: 80%; }
.blink                    { text-decoration: blink; }
</style>

