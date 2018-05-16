// written by Nick Shin - nick.shin@gmail.com
// the code found in this file is licensed under:
// - Creative Commons Attribution 3.0 License
//
// this file is from https://www.nickshin.com/CheatSheets/
//
//
// these are my used NodeJS code snippets
//
// http SERVER
// http CLIENT
// websocket SERVER
// amqp CLIENT
// and some minor utilities and nodejs goodies..
//

"use strict";

var noop = function() {};

//======================================================================
// http SERVER object
// https://github.com/einaros/ws/blob/master/examples/ssl.js
//======================================================================

var httpd_config = {
		port : 8888
	,	ssl_conf : {
			enabled : false // XXX CHANGE ME -- to test basic versus secure XXX

			// http://www.devsec.org/info/ssl-cert.html
			// openssl genrsa [ -des3 ] -out privkey.pem
			//   o -des3 (optional) will ask for a passphrase
			// openssl req -new -key privkey.pem -out certreq.csr
			// openssl x509 -req [ -days 3650 ] -in certreq.csr -signkey privkey.pem -out newcert.pem
			//   o -days (optional)
		,	key  : 'keys/privkey.pem'
		,	cert : 'keys/newcert.pem'
//		,	passphrase : 'foobar' // https://github.com/joyent/node/issues/1925#issuecomment-2531521
		}
};

var httpd = null;
function setup_httpd() {
	// split this to make it obvious
	if ( httpd_config.ssl_conf.enabled )
		setup_http_secure();
	else
		setup_http_normal();
}

function setup_httpd_basic() {
	httpd = require('http');
	httpd.createServer(function (req, res) {
		var result = http_process_request(req);
		// ----------------------------------------
		res.writeHead(200, {'Content-Type':'text/plain'});
		res.end('{result:'+result+'}');
	}).listen(httpd_config.port);
	console.log('!!! HTTPd running withOUT : TLS');
}

function setup_httpd_secure() {
	httpd = require('https');
	var options = {
		key:  fs.readFileSync( httpd_config.ssl_conf.key )
	,	cert: fs.readFileSync( httpd_config.ssl_conf.cert )
//	,	passphrase: httpd_config.ssl_conf.passphrase
	};
	httpd.createServer(options, function (req, res) {
		var result = http_process_request(req);
		// ----------------------------------------
		res.writeHead(200, {'Content-Type':'text/plain'});
		res.end('{result:'+result+'}');
	}).listen(httpd_config.port);

	// ========================================
	// setup TLS wrapper for websockets
	https_ws = httpd.createServer(options, function (req, res) {
		res.writeHead(200, {'Content-Type':'text/plain'});
		res.end('{result:1}');
	}).listen(ws_srv_port);
	console.log('!!! HTTPd running WITH : TLS');
}


//======================================================================
// http CLIENT object
//======================================================================

var http_config = {
		type : 'http'
	,	NODE_TLS_REJECT_UNAUTHORIZED : "1"

//		type : 'https'
//	,	NODE_TLS_REJECT_UNAUTHORIZED : "0" // make sure this is "1" on production (i.e. using an 'authorized' signed certificate)

	// note about: NODE_TLS_REJECT_UNAUTHORIZED
	// to allow http.request() to pass for 'self signed certificates'
	// http://stackoverflow.com/questions/9440166/node-js-https-400-error-unable-to-verify-leaf-signature
};

var http = null;
function setup_http() {
	// remember, this is when this nodejs talks TO webservers
	http = require(http_config.type);
	process.env.NODE_TLS_REJECT_UNAUTHORIZED = http_config.NODE_TLS_REJECT_UNAUTHORIZED;
}

function http_request( _host, _path, _header, _cb, _err ) {
	var options = {
		host     : _host
	,	path     : _path
	,	headers  : _header
	,	callback : _cb ? _cb : noop
	,	onerror  : _err ? _err : noop
	};
	var callback = function(response) {
		var str = '';
		response.on('data', function (chunk) { str += chunk; }); // keep appending
		response.on('end', function () {
			console.log( '+++ Completed: ' + options.host + options.path );
			options.callback( str );
		});
		response.on('error', function (exception) {
			console.log( '*** ERROR: ' + options.host + options.path );
			console.log( exception );
			options.onerror(exception);
		});
	};
	try { http.request(options, callback).end(); }
	catch(e) {
		console.log( '*** ERROR: calling: ' + options.host + options.path );
		console.log( exception );
		options.onerror(exception);
	}
}

function setup_php_session() {
	var options = {
		host: 'localhost'
	,	path: '/test.php'
	};
	var callback = function(str) {
		console.log( str );
		var data = JSON_parse(str);
		if ( ! data ) {
			console.log('*** ERROR: unable to obtain PHP sessionID');
			return;
		}
		console.log('!!! COOKIE - sessionID: '+data.sessionID);
		if ( ! options.headers ) {
			// http://docs.nodejitsu.com/articles/HTTP/clients/how-to-create-a-HTTP-request
			options.headers = { 'Cookie' : 'PHPSESSID=' + data.sessionID };
			// try again and see if sessions sticks
			http_request( host, path, null, callback, null );
		}
	};
	http_request( host, path, null, callback, null );
}


//======================================================================
// websocket SERVER
// https://github.com/einaros/ws
//======================================================================

var ws_srv_port = 4444;

var https_ws = null; // TLS wrapper to websockets
var WebSocketServer = require('ws').Server;
var __wss = null;
function setup_websocket() {
	// split this to make it obvious
	if ( https_ws ) {
		__wss = new WebSocketServer( { server: https_ws } );
		console.log('!!! websockets running WITH : TLS');
	} else {
		__wss = new WebSocketServer( { port: ws_srv_port } );
		console.log('!!! websockets running withOUT : TLS');
	}

	__wss.on('connection', function(ws) {
		var wss = this; // TODO: this should be tracked and closed if zombie

		ws.on('message', function(data, flags) {
			websock_onMessage( wss, ws, data, flags );
		});

		ws.on('close', function(code, message) {
			// TODO: untrack socket here...
			ws.close(); // close NOW...
		});

		ws.on('error', function(error) {
			console.log( '*** ERROR ***' );
			console.log( error );
			// TODO: untrack socket here...
			ws.close(); // close NOW...
		});

		websocket_send( ws, 'Welcome !' );
	});
}

function websocket_send( ws, msg ) {
	try { ws.send( msg ) }
	catch(e) {
		console.log('*** SEND ERROR: ' + e);
		console.log('*** tried sending : ' + msg);
	}
}

function websock_onMessage( wss, ws, data, flags ) {
	if ( data == 'ping' ) {
		websocket_send( ws, 'pong' );
	}
	else if ( data.match( /"xyz":("[^"]+)"/ ) ) {
		var query = RegExp.$1;
		// do something with data...
	}
	else
		websock_spam( data );
}

function websock_spam( msg ) {
	console.log( msg );
//	for ( var i in __wss.users )
//		websocket_send( __wss.users[i].ws, msg );
}


//======================================================================
// amqp CLIENT
// https://github.com/postwait/node-amqp
//======================================================================

var amqp_config = {
		host: { host : 'localhost' }
	,	queues [
			{ 'queue':'dead'    ,'key':'video.#'  ,'cb':amqp_cb_test }
		,	{ 'queue':'alive'   ,'key':'games.#'  ,'cb':amqp_cb_test }
		,	{ 'queue':'mortal'  ,'key':'video.#'  ,'cb':amqp_cb_test }
		,	{ 'queue':'kombat'  ,'key':'games.#'  ,'cb':amqp_cb_test }
		,	{ 'queue':'street'  ,'key':'video.#'  ,'cb':amqp_cb_test }
		,	{ 'queue':'fighter' ,'key':'games.#'  ,'cb':amqp_cb_test }
		]
};

var AMQPclient = require('amqp');
var _amqp = null;
var amqp_publish = noop;
function setup_amqp() {
	_amqp = AMQPclient.createConnection(amqp_config.host);
	_amqp.on('ready', function () {
		var ajaxamqp_exchange = _amqp.exchange("amq.topic", {type:'topic'}, function(exch) {
			for ( var i = 0; i < amqp_config.queues.length; i++ ) {
				var q = amqp_config.queues[i];
				_amqp.queue( q.queue, (function(_q) { return function(que) {
					que.bind(exch, _q.key);
					que.subscribe( _q.cb );
				};})(q));
			}
		});
		amqp_publish = function(qname, data) {
			// https://github.com/postwait/node-amqp#exchangepublishroutingkey-message-options-callback
			// https://gist.github.com/kusor/402761#file-node-amqp-topic-exchange-js
			ajaxamqp_exchange.publish(qname, data);
		};
	});
}

function amqp_cb_test(message, headers, deliveryInfo) {
	var data = 'amqp:' + deliveryInfo.routingKey + ':' + message.data.toString('ascii',0,message.data.length);
	if ( deliveryInfo.routingKey.match( /video.(.+)/ ) ) {
		var subkey = RegExp.$1;
		amqp_publish('games.fighters.' + subkey, 'boom' + data );
	} else if ( deliveryInfo.routingKey.match( /games.(.+)/ ) )
		websock_spam( data );
	else
		console.log(data); // jic
}


//======================================================================
// utilities
//======================================================================

function JSON_parse( data ) {
	var results = null;
	try { results = JSON.parse( data ); }
	catch(e) {
		console.log('*** JSON.parse ERROR: ' + e); // garbage data detected
		console.log(data);
	}
	return results;
}


//======================================================================
// more nodejs goodies
//======================================================================

// ----------------------------------------------------------------------
// manual garbage-collection
// o http://simonmcmanus.wordpress.com/2013/01/03/forcing-garbage-collection-with-node-js-and-v8/
// o for metrics/debugging purposes
// o remember to run this script with "--expose-gc" switch
//   or else set it to noop
if ( ! global.gc ) global.gc = noop;


// ----------------------------------------------------------------------
// http://nodejs.org/api/process.html#process_event_uncaughtexception
process.on('uncaughtException', function (err) {
	console.error(err.stack);
	console.log(" Node NOT Exiting...");
});


// ----------------------------------------------------------------------
// dump an object
var util = require('util');
console.log( util.inspect( process.memoryUsage() ) );


//======================================================================
// MAIN
//======================================================================
setup_httpd(); // SERVER
setup_http();  // CLIENT
setup_websocket();
setup_amqp();

console.log('server started!');

