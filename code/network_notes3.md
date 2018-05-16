<style>
ul ul ul ul ul, .note1    { font-size: 11px; }
pre                       { margin-left: 2em; }
.markdown-body pre code   { font-size: 80%; }
.underline                { text-decoration: underline; }
</style>

# Networking Server Notes

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>


* * *
## Concurrency

<!--
[//] # ( https://en.wikipedia.org/wiki/List_of_concurrent_and_parallel_programming_languages )
-->

- examples written in: <span class='note1'>(coming soon)</span>
	- Exlixir
	- GoLang
	- Scala

* * *
## WebSockets

- programming language implimentations
	- (perl) [Net::Async::WebSocket::Server](http://search.cpan.org/dist/Net-Async-WebSocket/lib/Net/Async/WebSocket/Server.pm)
	- (python) [pywebsocket](http://code.google.com/p/pywebsocket/)
	- (ruby) [em-websocket](https://github.com/igrigorik/em-websocket)

* * *
## WebRTC

my notes on compiling WebRTC <span class='note1'>(as well as libWebSockets and libCurl)</span> with zlib and OpenSSL:
- [https://github.com/EpicGames/UnrealEngine/blob/release/Engine/Source/ThirdParty/libcurl/BUILD.EPIC.sh](https://github.com/EpicGames/UnrealEngine/blob/release/Engine/Source/ThirdParty/libcurl/BUILD.EPIC.sh)
	- <span class="note1">you will need to sign up for Unreal Engine access...</span>
	- <span class="note1">will copy it here one of these days ... please stand by ...</span>

* * *
## SSL (libraries)

OpenSSL is a mess.  Want to evaluate the following libs:
<span class='note1'>(see what it will take to get libWebSocket, libCurl and WebRTC compiled with these)</span>
- BoringSSL
- LibreSSL
- WolfSSL
<br>&nbsp;
- <span class="note1">external links:</span>
	- <span class="note1">[Comparison of TLS implementations](https://en.wikipedia.org/wiki/Comparison_of_TLS_implementations)</span>

* * *
## Behind a Firewall

- using a STUN server will help Jingle communications to happen when parties are separated
	by a NAT, by providing a public service for IP addresses and ports discovery.

<!--
[//] # ( 	- asterisk                                                                                                     )
[//] # ( 	- ejabberd                                                                                                     )
[//] # ( 		- configure listening module:                                                                              )
[//] # ( ```erlang                                                                                                         )
[//] # ( {listen,                                                                                                          )
[//] # ( 	[                                                                                                              )
[//] # ( 		...                                                                                                        )
[//] # ( 		{ {3478, udp}, ejabberd_stun, [] },                                                                        )
[//] # ( 		{3478, ejabberd_stun, []}, %% TCP!!!                                                                       )
[//] # ( 		{5349, ejabberd_stun, [{certfile, "/etc/ejabberd/server.pem"}]}, %% TCP!!!                                 )
[//] # ( 		...                                                                                                        )
[//] # ( 	]                                                                                                              )
[//] # ( }                                                                                                                 )
[//] # ( ```                                                                                                               )

[//] # ( 		- and configure DNS SRV records properly so clients can easily discover STUN server from your XMPP domain: )
[//] # ( ```zone                                                                                                           )
[//] # ( _stun._udp   IN SRV  0 0 3478 stun.example.com.                                                                   )
[//] # ( _stun._tcp   IN SRV  0 0 3478 stun.example.com.                                                                   )
[//] # ( _stuns._tcp  IN SRV  0 0 5349 stun.example.com.                                                                   )
[//] # ( ```                                                                                                               )
-->

- See this whitepaper on: [NAT Traversal ... using STUN, TURN and ICE](http://web.archive.org/web/20120313075557/http://www.voiptraversal.com/) for an overall view of this system
	- see this [PDF](http://www.viagenie.ca/publications/2008-09-24-astricon-stun-turn-ice.pdf) for a crash course on:
<!--
[//] # ( <span class='note1'>(by Simon Perreault)</span> )
-->
		- **STUN**: <span class='note1'>(slides 6 - 8)</span>
			- <span class='note1'>client finds 'outside IP address' from STUN server:
				- this punches a temporay hole in the firewall (see **NAT-type**> notes just below)
				- peers does the same thing on their side
			- <span class='note1'>client sends both internal and 'outsside IP address' to peer (or to a proxy server)</span>
			- <span class="note1">peers attempts to communicate with client via both IP address: connects with which ever wins!</span>
			<br>&nbsp;
			- see this [page](https://wiki.asterisk.org/wiki/display/TOP/NAT+Traversal+Testing) <span class='note1'>(with example firewall settings/commands)</span><br>
				and this [page](http://wapiti.telecom-lille1.eu/commun/ens/peda/options/ST/RIO/pub/exposes/exposesrio2005ttnfa2006/butin-sutter/doc/type_nat.pdf) <span class='note1'>(with drawings)</span><br>
				to see which **NAT types** will allow certain connection types
				- full-cone:
					- port forwarding: **<span class="underline">all traffic</span> is mapped to internal host (including non-established connections)**
				- (address) restricted-cone
					- all external hosts connection attempts will be dropped, unless
					- internal host initiates external communications to 'that external host'
					- then, 'that external host' can communicate with internal host **from <span class="underline">any</span> (external host) port**
				- port restricted-cone
					- all external hosts connection attempts will be dropped, unless
					- internal host initiates external communications to 'that external host'
					- then, 'that external host' can communicate with internal host **but <span class="underline">only</span> from the <span class="underline">same</span> (external host) port**
				- symmetric
					- NAT translations and only established connections allowed (again internal host initiated only)
			<br>&nbsp;
		- **TURN**: <span class='note1'>(slides 11 - 17)</span>
			- <span class="note1">peer traffic are all relayed through a TURN server</span>
			<br>&nbsp;
	- see this [PDF](http://web.archive.org/web/20110304095700/http://www.interop.com/lasvegas/2006/presentations/downloads/session-border-controllers-d-wing.pdf) for an example on:
<!--
[//] # ( <span class='note1'>(by Dan Wing)</span> )
-->
		- **ICE** <span class='note1'>(slides 11 and on)</span>:
			- <span class='note1'>tries a combination of STUN and TURN to determine best method to connect peers</span>

* * *

