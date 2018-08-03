# Networking Server Notes

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://github.com/nickshin/CheatSheets/>

* * *

## Concurrency

<!--
[//] # ( https://en.wikipedia.org/wiki/List_of_concurrent_and_parallel_programming_languages )
-->

- examples written in: _(coming soon)_
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

my notes on compiling WebRTC _(as well as libWebSockets and libCurl)_ with zlib and OpenSSL:
- [https://github.com/EpicGames/UnrealEngine/blob/release/Engine/Source/ThirdParty/libcurl/BUILD.EPIC.sh](https://github.com/EpicGames/UnrealEngine/blob/release/Engine/Source/ThirdParty/libcurl/BUILD.EPIC.sh)
	- _you will need to sign up for Unreal Engine access..._
	- _will copy it here one of these days ... please stand by ..._

* * *

## SSL (libraries)

OpenSSL is a mess.  Want to evaluate the following libs:
_(see what it will take to get libWebSocket, libCurl and WebRTC compiled with these)_
- BoringSSL
- LibreSSL
- WolfSSL

- _external links:_
	- _[Comparison of TLS implementations](https://en.wikipedia.org/wiki/Comparison_of_TLS_implementations)_

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

- See this whitepaper on:
[NAT Traversal ... using STUN, TURN and ICE](http://web.archive.org/web/20120313075557/http://www.voiptraversal.com/)
_(by Simon Perreault)_ for an overall view of this system
	- see this [PDF](http://www.viagenie.ca/publications/2008-09-24-astricon-stun-turn-ice.pdf) for a crash course on:
		- **STUN**: _(slides 6 - 8)_
			- _client finds 'outside IP address' from STUN server:_
				- this punches a temporay hole in the firewall (see **NAT-type**> notes just below)
				- peers does the same thing on their side
			- _client sends both internal and 'outsside IP address' to peer (or to a proxy server)_
			- _peers attempts to communicate with client via both IP address: connects with which ever wins!_

			- see this [page](https://wiki.asterisk.org/wiki/display/TOP/NAT+Traversal+Testing) _(with example firewall settings/commands)_<br>
				and this [page](http://wapiti.telecom-lille1.eu/commun/ens/peda/options/ST/RIO/pub/exposes/exposesrio2005ttnfa2006/butin-sutter/doc/type_nat.pdf) _(with drawings)_<br>
				to see which **NAT types** will allow certain connection types
				- full-cone:
					- port forwarding: **_all traffic_ is mapped to internal host (including non-established connections)**
				- (address) restricted-cone
					- all external hosts connection attempts will be dropped, unless
					- internal host initiates external communications to 'that external host'
					- then, 'that external host' can communicate with internal host **from _any_ (external host) port**
				- port restricted-cone
					- all external hosts connection attempts will be dropped, unless
					- internal host initiates external communications to 'that external host'
					- then, 'that external host' can communicate with internal host **but _only_ from the _same_ (external host) port**
				- symmetric
					- NAT translations and only established connections allowed (again internal host initiated only)

		- **TURN**: _(slides 11 - 17)_
			- _peer traffic are all relayed through a TURN server_

	- see this
[PDF](http://web.archive.org/web/20110304095700/http://www.interop.com/lasvegas/2006/presentations/downloads/session-border-controllers-d-wing.pdf)
_(by Dan Wing)_ for an example on:
		- **ICE** _(slides 11 and on)_:
			- _tries a combination of STUN and TURN to determine best method to connect peers_

* * *

