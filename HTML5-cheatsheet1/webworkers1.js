/* written by Nick Shin - nick.shin@gmail.com
 * the code found in this file is licensed under:
 * - Unlicense - http://unlicense.org/
 * 
 * this file is from https://www.nickshin.com/CheatSheets/
 *
 *
 * SEE webworkers.html for details
 */

// to #include other javascript files:
//		importScripts( 'common.js', 'webworker2.js', .... );
// this can actually be loaded anywhere in a function when needed...

var n = 1;
function findPrime() {
	search: while (true) {
		n += 1;
		for (var i = 2; i <= Math.sqrt(n); i += 1) {
			if (n % i == 0)
				continue search; // yay!  named loops   ^_^
		}
		postMessage(n); // found a prime!
		break; // for DEMO purposes...
	}
	setTimeout( findPrime, 1000 );
}

var result = 'CHILD: ';
onmessage = function( evt ) {
	var data = evt.data;
	switch (data.cmd) {
		case 'start':
			postMessage( 'WORKER STARTED: ' + data.msg );
			findPrime();
			break;
		case 'stop':
			postMessage( 'WORKER STOPPED: ' + data.msg );
			close(); // Terminates the worker.
			break;
		case 'spawn':
			// workers can start child workers
			// note: child prime numbers start from 1,
			// DEDICATED workers are run in isolated threads.
			// see SHARED workers for different results
// WARNING: Chrome(webkit) does not support this yet...
// http://code.google.com/p/chromium/issues/detail?id=50432
			postMessage( 'WORKER: starting subchild - look for "started" message next...' );
			var worker = new Worker('webworkers1.js');
			postMessage( 'WORKER: subchild started (this will not be seen on webkit browsers)' );
			worker.onmessage = function( evt ) {
				result += evt.data + ' ';
				postMessage( result );
				if ( evt.data == '13' )
					worker.postMessage( { 'cmd':'stop', 'msg':'bye' } );
			};
			worker.postMessage( { 'cmd':'start', 'msg':'hi' } );
			break;
		default:
			postMessage( 'Unknown command: ' + data.msg );
	};
};

// remember: the other way to write this:
// addEventListener('message', function( evt ) {
//     ...
// }, false);


// tell parent that worker is done 'initializing'
postMessage( 'WORKER READY' );

