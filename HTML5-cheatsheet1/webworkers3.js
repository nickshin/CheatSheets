/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 * 
 * this file is from https://www.nickshin.com/CheatSheets/
 *
 *
 * SEE webworkers.html for details
 */

// note: count is incremented as more and more scripts connect to this one
// at the same time.  SHARED workers run with only one of this thread.
// see DEDICATED workers for different results
var count = 0;
onconnect = function(e) {
	count += 1;
	var port = e.ports[0];
	port.postMessage( 'MSG from worker3 : connection #' + count );

	port.onmessage = function(e) {
		port.postMessage( 'pong ' + count ); // not e.ports[0].postMessage!
		// but e.target.postMessage('pong'); would work also
	}
}

