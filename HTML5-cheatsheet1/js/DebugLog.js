/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 * 
 * this file is from https://www.nickshin.com/CheatSheets/
 * 
 * 
 * debugger logger to a div layer
 * 
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * reference sources:
 *
 * the javascript console is nice for dumping messages to.
 * there are a number of categories available for separating the messages:
 *		http://stackoverflow.com/questions/217957/how-to-print-debug-messages-in-the-google-chrome-javascript-console
 *
 * firebug's console is the way to go:
 * 		http://getfirebug.com/logging
 * 		http://getfirebug.com/wiki/index.php/Console_API
 * 
 * but sometimes, on mobile devices for example, there is no javascript
 * console of any kind.  so this was created to output the information
 * to, for example, a div layer.
 * 
 * this way, the layer can also be stylized for placement, visibility or whatever.
 *		http://www.thatguycharlie.com/2010/professional-css-alert-boxes/
 * 
 * this is a no frills/thrills solution -- just the bare bones...
 * 
 * 
 * note:
 * firebug has a remote debugger/inspector called firebug lite
 * 
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * 
 * best viewed in editor with tab stops set to 4
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */

// ----------------------------------------
// NOTE: this is a MODULE -- not a class
// ----------------------------------------
var DEBUGLOG = (function () {
	var my = {};

	// ----------------------------------------
	// private static
	var el = null;

	// ----------------------------------------
	// these are publicly accessible
	my.setElementById = function ( id ) {
		el = document.getElementById( id );
	};

	my.printhook = function ( msg ) {
		el.innerHTML += msg + "<br />";
	};

	my.clear = function () {
		el.innerHTML = '';
	};
	
	return my; // must be last
}());

// the following is to bypass an automatic breakpoint in firebug/firefox
document.addEventListener("DOMNodeInserted", function(e){ if (!e.target.tagName) e.target.tagName = 'dummy'; }, false);
