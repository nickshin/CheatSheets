# Networking Server Notes

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>

* * *
## Node.js

<span class="indent">My #1 goto link: [wss://](https://github.com/einaros/ws/blob/master/examples/ssl.js)
(with excellent **http vs. https** setup tips!)</span>

<span class="indent">My master nodejs starter file: [network_nodejs.js](network_nodejs.js)</span>

#### http
- [http://](http://nodejs.org/)
- [querystring](http://nodejs.org/api/querystring.html)

#### ws
- [ws://](https://github.com/einaros/ws)
	- Every now and then, echo.websocket.org / www.websocket.org/echo.html goes down.
		And sometimes, you need a local echo server tester.  I use
		[pywebsocket](https://code.google.com/p/pywebsocket/wiki/TestingYourWebSocketImplementation)
		for this.
- [http:upgrade](http://nodejs.org/api/http.html#http_event_upgrade_1) (the gory details)

#### AMQP
- [node-amqp](https://github.com/postwait/node-amqp)

#### XMPP
- [node-xmpp](https://github.com/node-xmpp/node-xmpp)
	- [node-xmpp-server](https://github.com/node-xmpp/node-xmpp-server)
	- [node-xmpp-client](https://github.com/node-xmpp/node-xmpp-client)
- [node-simple-xmpp](https://github.com/simple-xmpp/node-simple-xmpp)

#### TLS(SSL)
<span class="indent">it is amazing how easy it is in Node.js to add a TLS wrapper to nearly any communication protocol it supports</span>
- [TLS](http://nodejs.org/api/tls.html)
- [PEM](https://github.com/andris9/pem)
<br>&nbsp;
- [https://](http://nodejs.org/api/https.html#https_https_createserver_options_requestlistener)
- [amqps://](https://github.com/postwait/node-amqp#connection-options-and-url)
- [xmpps://](https://github.com/node-xmpp/node-xmpp-server/blob/master/examples/s2s_echo_tls.js)

* * *
## HTTPd

#### setting up SSL <span class="note1">for Apache</span>
- [HTTPD - Apache2 Web Server :: HTTPS Configuration](https://help.ubuntu.com/10.04/serverguide/C/httpd.html#https-configuration)
<span class='note1'>(on Ubuntu)</span>

#### .htaccess
- [Stupid htaccess Tricks](http://perishablepress.com/stupid-htaccess-tricks/)
- My [network_notes2_htaccess.pl](network_notes2_htaccess.pl) to generate .htaccess files for Apache and lighttpd

#### CGI configuration
```apache
# remember to 'chmod 755 script/executable'
# (just in case it isn't obvious) **DO NOT enable cgi on untrusted folders**
# (e.g. uploads, submissions, un-sanitized inputs, etc.)
```

- [Apache](http://httpd.apache.org/docs/2.2/howto/cgi.html)

```apache
LoadModule cgi_module modules/mod_cgi.so

# what i use
<Directory "/var/www/cgi-bin">
	AllowOverride None
	Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
# 2.2 configuration
#	Order allow,deny
#	Allow from all
# 2.4 configuration - note: /var/www is expected, but DocumentRoot is located outside, access must be granted
	Require all granted
</Directory>

# spell out what can be CGI
<Directory "/home/*/public_html">
	Options +ExecCGI
	AddHandler cgi-script .cgi .pl .py .rb
	Require all granted
</Directory>

# everything can be CGI
<Directory "/home/*/public_html/cgi-bin">
	Options ExecCGI
	SetHandler cgi-script
	Require all granted
</Directory>
```

- [lighttpd](http://redmine.lighttpd.net/projects/1/wiki/docs_modcgi)

```nginx
# /etc/lighttpd/conf-available/10-cgi.conf

	server.modules += ( "mod_cgi" )

# spell out what can be CGI
$HTTP["url"] =~ "^/cgi-bin/" {
	cgi.assign = ( ".cgi" => "",
	               ".pl" => "/usr/bin/perl",
	               ".py" => "/usr/bin/python",
	               ".rb" => "/usr/bin/ruby")
}

# everything can be CGI
$HTTP["url"] =~ "^/cgi-bin/" {
	cgi.assign = ( "" => "" )
}
```

- [Nginx](http://wiki.nginx.org/Fcgiwrap)
	- NOTE: Nginx cannot directly execute external programs (CGI), it will run them via fcgiwrap.
		- but, be aware that it's still not "fast"CGI (even if it was writen as a FastCGI bin)
		- fcgiwrap will terminate the execution -- thus "CGI-bin" behavior

```nginx
# /etc/nginx/sites-available/default

# spell out what can be CGI
location ~ \.(cgi|pl|py|rb)$ {
	try_files $uri =404;
	# to see where fcgiwrap is running, check: /etc/init.d/fcgiwrap
	fastcgi_pass unix:/var/run/fcgiwrap.socket;
#	fastcgi_index index.fcgi;
	include fastcgi_params;
}

# everything can be CGI
location /fastCGI/ {
	gzip off;
	# to see where fcgiwrap is running, check: /etc/init.d/fcgiwrap
	fastcgi_pass unix:/var/run/fcgiwrap.socket;
#	fastcgi_index index.fcgi;
	include fastcgi_params;
}
```

#### FastCGI configuration
- in general, web servers connects to spawned processes (can be remote)
	- unlike apache, **lighttpd [and] nginx does not automatically** spawn [blind] FastCGI processes
	<span class="note1">([nginx.org](http://wiki.nginx.org/FcgiExample#Spawning_a_FastCGI_Process))</span>
	- so, remember to **start a sufficient number instances** of the program to handle concurrent requests,
		and these programs remain running to handle further incoming requests (i.e. does not exit)
	- ensure FastCGI processes stay running -- so, just in case they die unexpectedly, use **process watchers** such as:
		- [monit](http://mmonit.com/monit/)
		- [supervisor](http://supervisord.org/)
		- [perp](http://b0llix.net/perp/)
		- [restartd](https://packages.debian.org/stable/utils/restartd)
		- [supervise - daemontools](http://cr.yp.to/daemontools/supervise.html)
		- [supervise - daemontools-encore](http://untroubled.org/daemontools-encore/supervise.8.html)
		- [runsv](http://smarden.org/runit/runsv.8.html)

- don't forget to:
```sh
chown -R www-data.www-data /var/www/html/fastCGI
chmod 755 /var/www/html/fastCGI/*
```

- <span class="note1">(just in case it isn't obvious)</span> if ".fcgi" program is edited, pid needs to be killed to be reloaded

- [Apache](http://www.cyberciti.biz/tips/rhel-fedora-centos-apache2-external-php-spawn.html)

```apache
# /etc/apache2/sites-available/000-default.conf
# 	(or .htaccess file...)
<Directory /var/www/html/fastCGI>
	Options +ExecCGI
</Directory>

# /etc/apache2/mods-available/fastcgi.conf
<IfModule mod_fastcgi.c>
	# this allows apache to spawn FastCGI process without spelling them out
	# yes, this is a little dangerous -- but very convenient if the process dies
	AddHandler fastcgi-script .fcgi .pl .rb .py

	# add as many handlers as needed here...
	# note: not in fastCGI path
	# - URI will be resolved to the (already running) external FastCGI process
	FastCGIExternalServer /var/www/html/fcgi_example_0  -host localhost:9000
	FastCGIExternalServer /var/www/html/fcgi_example_0s -socket /tmp/test_fcgi_0.socket
	FastCGIExternalServer /var/www/html/fcgi_example_1  -host localhost:9001
	FastCGIExternalServer /var/www/html/fcgi_example_1s -socket /tmp/test_fcgi_1.socket
</IfModule>
```

- <span class="note1">Apache notes:</span>
	- another nice [mod_fastcgi](http://www.openjpeg.org/jpip/doc/ApacheFastCGITutorial.pdf) howto
	- **WARNING:** a note about [mod_fcgid](http://itkia.com/external-fastcgi-with-apache/)
		- **mod_fcgid CAN NOT** be use to **connect** to externally spawned FastCGI process.
			It can **only launch and manage** the processes itself.
		- in other words, it'll be just like a simple "CGI-bin" execution
<br>&nbsp;

- [lighttpd](http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_ModFastCGI)

```nginx
# /etc/lighttpd/conf-available/10-fastcgi.conf
server.modules += ("mod_fastcgi")

fastcgi.server = (
	# FastCGI application cannot be started by Lighttpd
	# scripts/binaries needs to be spelled out (map to socket or port)...
#	".fcgi" => (
#		(   "bin-path" => "/usr/bin/perl",
#			"docroot" => "/var/www/html/fastCGI",
#			"socket" => "/tmp/test_fcgi_lighttpd.socket" # this will obviously not work...
#	)	),

	# add as many handlers as needed here...
	# connect to listening processes
	"/fcgi_example_0" => ( (
			"host" => "localhost",
			"port" => 9000,
			"check-local" => "disable"
	)	),

	"/fcgi_example_0s" => ( (
			"socket" => "/tmp/test_fcgi_0.socket",
			"check-local" => "disable"
	)	),

	"/fcgi_example_1" => ( (
			"host" => "127.0.0.1",
			"port" => 9001,
			"check-local" => "disable"
	)	),

	"/fcgi_example_1s/" => ( (
			"socket" => "/tmp/test_fcgi_1.socket",
			"check-local" => "disable"
	)	),
)
```

- [Nginx](https://library.linode.com/web-servers/nginx/perl-fastcgi/ubuntu-12.04-precise-pangolin)

```nginx
# /etc/nginx/sites-available/default

server {
	...

# NOTE: the use of '=' for regexp path

	location = /fcgi_example_0 {
		include fastcgi_params;
		fastcgi_pass 127.0.0.1:9000;
	}

	location = /fcgi_example_0s {
		include fastcgi_params;
		fastcgi_pass unix:/tmp/test_fcgi_0.socket;
	}

	location = /fcgi_example_1 {
		include fastcgi_params;
		fastcgi_pass 127.0.0.1:9001;
	}

	location = /fcgi_example_1s {
		include fastcgi_params;
		fastcgi_pass unix:/tmp/test_fcgi_1.socket;
	}
	...
}
```

- <span class="note1">Nginx notes:</span>
	- remember, Nginx can only connect to listening processes

<!--
[//] # ( TODO: - source codes for fcgi_example_* can be found [here](fcgi_example.tgz). )
[//] # ( TODO: - note:                                                                  )
[//] # ( TODO: ```                                                                      )
[//] # ( TODO: 	http://localhost/fcgi_example_0  => ./fcgi_00_CGIFAST.pl                )
[//] # ( TODO: 	http://localhost/fcgi_example_0s => ./fcgi_00_CGIFAST.pl                )
[//] # ( TODO: 	http://localhost/fcgi_example_1  => ./fcgi_10_FCGI_TCP.pl               )
[//] # ( TODO: 	http://localhost/fcgi_example_1s => ./fcgi_10_FCGI_socket.pl            )
[//] # ( TODO: ```                                                                      )
-->

- in general, UNIX sockets are faster as compared to TCP/IP sockets
	- but, UNIX sockets are local only
	- while TCP/IP sockets can be distributed (e.g. **load balancing** configurations)
		- [Load Balancing with Apache](http://bradley-holt.com/2011/03/load-balancing-with-apache/)
		- [How to configure multiple load balanced fastcgi back-ends with lighty](http://redmine.lighttpd.net/projects/1/wiki/HowToSetupLoadBalancedFCGIBackends)
		- [Using nginx as HTTP load balancer](http://nginx.org/en/docs/http/load_balancing.html)

* * *
## AMQP

#### rabbitMQ
- simple to "install" and run
	- (brain dead easy) [script to download and run](https://gist.github.com/334219)
	- (slides) [Interoperability With RabbitMq](http://www.slideshare.net/old_sound/interoperability-with-rabbitmq)
	- (wordy) [RabbitMQ for Beginners](http://www.skaag.net/2010/03/12/rabbitmq-for-beginners/)

- if "get and compile" -- i.e. doing it the long way
	- before v.2.1, tell rabbitmq to activate plugins: [ rabbitmq-activate-plugins ]
	- then restart server

- [jsonrpc channel](http://www.rabbitmq.com/plugins.html#rabbitmq-jsonrpc-channel)
	- An AMQP-over-HTTP protocol binding for RabbitMQ and some Javascript libraries for interacting with RabbitMQ over HTTP.
	- "simple" install -- but doesn't seem to work on v.1.7
	- NOTE: no need to grab [ rabbitmq-jsonrpc-channel-examples ]
			this is now done inside [ rabbitmq-jsonrpc-channel ]
	- [compile the RabbitMQ JSON-RPC-channel plugin](http://hg.rabbitmq.com/rabbitmq-jsonrpc-channel/file/rabbitmq_v2_4_0/README) (README)
		- GOOD EXTRA HELPFUL INFO
			- <span class="note1">shutdown server</span>
			- <span class="note1">goto: rabbitmq-jsonrpc-channel</span>
			- <span class="note1">then: make run</span>
			- <span class="note1">point browser to: http://localhost:55672/</span>
		- JSON-RPC: examples -> Simple JSONRPC test
			- <span class="note1">NOTE: test server output when connecting</span>
			- <span class="note1">NOTE: channel stays connected until page is closed</span>
			- <span class="note1">YAY !</span>
		- JSON-RPC: examples -> Simple chat application
			- <span class="note1">works as advertised</span>
			- <span class="note1">YAY !</span>

<!--
[//] # ( #### perl clients )
-->

#### python clients
- [Rabbits and warrens](http://web.archive.org/web/20100529043620/http://blogs.digitar.com/jjww/2009/01/rabbits-and-warrens/) <span class='note1'>(archive.org)</span>
	-- [Rabbits and warrens](http://blogs.digitar.com/jjww/2009/01/rabbits-and-warrens/) <span class='note1'>(original)</span>

<!--
[//] # ( #### ruby clients )
-->

* * *
## XMPP

<!--
[//] # ( the latest ejabberd repository (currently v3 alpha) is located at: )
[//] # ( 	https://git.process-one.net/ejabberd/                           )

[//] # ( the mirrored is at (but is only on v2.1):                          )
[//] # ( 	https://github.com/processone/ejabberd/                         )

[//] # ( clustering                                                         )
[//] # ( 	http://www.blinkenlights.ch/ccms/linux/ejabberd.html            )
-->

#### ejabberd: server components
- [<span class='note1'>Echo Bot Part Two:</span> Making A Component](http://metajack.im/2008/10/09/echo-bot-part-two-making-a-component/)
- [Net::Jabber 2.0 examples component_accept.pl](http://cpansearch.perl.org/src/REATMON/Net-Jabber-2.0/examples/component_accept.pl)
- **WARNINGS:**
	- component can be writen and started by **any user** as long as they know the port number and **secret** value
	- more than one server component can be listening on the same port number
		- **TRY NOT TO DO THIS**
		- or else make sure component responds only when **TO:** matches component name
		- clients might take 1st response if any component responds (and possibly encounter something it's not expecting)
	- if message comes in type 'error' -- it's most likely that 'componentname' was used instead of 'componentname<span class="bold">@hostname</span>'
		- do not try to 'fix' this component side
		- keep 'error' type or ignore the message -- this is the expected behavior of badly crafted messages

#### ejabberd + websockets
- [XMPP over websockets](http://blog.superfeedr.com/xmpp-over-websockets/)
	- follow github link and read the easy to follow instructions
	- test with: [Node.js &amp; WebSocket - Simple chat tutorial](http://martinsikora.com/nodejs-and-websocket-simple-chat-tutorial)

#### ejabberd + HTTP binding <span class='note1'>(for older browsers...)</span>
- [<span class='note1'>Install JWChat with</span> ejabberd's HTTP-Bind <span class='note1'>and file server</span>](http://www.ejabberd.im/jwchat-localserver)

```erlang
%% ejabberd.cfg

%% enable HTTP binding
...
{listen,
	{5280, ejabberd_http, [
		{request_handlers, [
			{["web"], mod_http_fileserver}
		]},
...
{modules,
	{mod_http_bind,    []},
	{mod_http_fileserver, [
		{docroot, "/var/www/TEST/XMPP"},
		{accesslog, "/var/log/ejabberd/access.log"}
	]},
...
%% allow jabber client to create accounts:
{access, register, [{allow, all}]}.
...
%% make an admin user - then create account with any jabber client
{acl, admin, {user, "someuser", "localhost"}}.
```

- <span class="note1">ejabberd's HTTP-Bind notes:</span>
	- then login to [ http://localhost:5280/admin/ ] with admin account
	- Virtual Hosts -> localhost -> users can be created/modified/deleted here

	- test with: [jwchat](http://blog.jwchat.org/jwchat/)
		- long lasting connection
		- follow 2nd half of instructions from [ ejabberd's HTTP-Bind ] link above<br>
			  then point browser to: [ http://localhost:5280/web/jwchat/index.html ]
		- works out of the box
		- but account CREATION might not work...
		- watch out for pop-up blocker holding auth/req

	- or test with: [strophejs](http://code.stanziq.com/strophe/)
		- shows ejabberd w/http-bind also works with strophejs
		- but no long lived connection example
		- build strophejs
```sh
apt-get install yui-compressor
export YUI_COMPRESSOR=/usr/share/yui-compressor/yui-compressor.jar
git clone git://code.stanziq.com/strophejs
cd strophejs; make
```

		- (fixes) based on https://gist.github.com/272956
```
EDIT: examples/basic.js:    var BOSH_SERVICE = 'http://localhost:5280/http-bind'
EDIT: examples/echobot.js:  var BOSH_SERVICE = 'http://localhost:5280/http-bind'
point browser to: http://localhost:5280/web/strophejs/examples/basic.html
point browser to: http://localhost:5280/web/strophejs/examples/echobot.html
```

		- LOGIN in with: username@domain

#### ejabberd: config <span class='note1'>(please see: [offical docs](http://www.process-one.net/en/ejabberd/docs/))</span>
- setup admins: <span class='note1'>(**Create an XMPP Account for Administration**)</span>

```sh
sudo ejabberdctl stop
vi ejabberd.cfg
#	{acl, admin, {user, "admin1", "example.org"}}.
#	{acl, admin, {user, "admin2", "example.org"}}.
#	{access, configure, [{allow, admin}]}.
sudo ejabberdctl start

# the following can be done while server is up and running
sudo ejabberdctl register admin1 FQDN password
sudo ejabberdctl register admin2 FQDN password
sudo ejabberdctl register userA FQDN password
# ...
sudo ejabberdctl register userN FQDN password
```

- to allow user created accounts: <span class='note1'>(**mod_register**)</span>
	- change from:<br>
<span class="note1 indent">{access, register, [{**deny**, all}]}.</span>
	- to:<br>
<span class="note1 indent">{access, register, [{**allow**, all}]}.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **(WARINING NOT RECOMMENDED!!!)**<br>&nbsp;

- [The simplest way to create a new ejabberd user with PHP](http://www.ejabberd.im/node/3126)

* * *




<style>
.note1                    { font-size: 11px; }
.bold                     { font-weight: bold; }
.indent, pre              { margin-left: 2em; }
.markdown-body pre code   { font-size: 80%; }
</style>

