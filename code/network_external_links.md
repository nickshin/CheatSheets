# External Links: Network IO

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://github.com/nickshin/CheatSheets/>

* * *

The external links list was getting so large, I placed them here.

* * *

## Websockets

- (perl) [Net::Async::WebSocket::Server](https://metacpan.org/pod/Net::Async::WebSocket::Server)
- (python) [pywebsocket](http://code.google.com/p/pywebsocket/)
- (ruby) [em-websocket](https://github.com/igrigorik/em-websocket)

* * *

## Linux

### epoll

- (C) [How to use epoll? A complete example in C](https://banu.com/blog/2/how-to-use-epoll-a-complete-example-in-c/)
- (C) [Linux Files and the Event Poll Interface](http://www.devshed.com/c/a/BrainDump/Linux-Files-and-the-Event-Poll-Interface/)
- (perl) [IO::Epoll - detecting sockets which have gone away](http://www.perlmonks.org/index.pl?node_id=646683)
- (python) [How To Use Linux epoll with Python](http://scotdoyle.com/python-epoll-howto.html)
- (ruby) [An EventMachine Tutorial](http://20bits.com/article/an-eventmachine-tutorial)

* * *

## CGI

### FastCGI

- interesting details on forking a "long running" FastCGI process ([DreamHost](http://wiki.dreamhost.com/Perl_FastCGI))

- [Apache](http://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html) (Perl and PHP)
	- [Apache, FastCGI and](http://www.electricmonk.nl/docs/apache_fastcgi_python/apache_fastcgi_python.html) (Python)
		- also a nice overview of FastCGI
	- [FastCGI with](https://rubygems.org/gems/fcgi/) (Ruby)
- [lighttpd](http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_ModFastCGI)
	- examples in: ( C/C++, Perl, Python and PHP ) as well as ( load balancing )
	- [Optimizing FastCGI performance](http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_PerformanceFastCGI)
		- PHP centric (but is applicable to Perl, Python and Ruby as well)
- [Nginx](http://wiki.nginx.org/Configuration#FastCGI_examples)
	- great collection of setup and examples for: ( Perl, Python, Ruby and PHP ) and more
<!--
[//] # ( 	- [nginx pitfalls](http://wiki.nginx.org/Pitfalls) )
-->

- PHP via FastCGI
	- (socket) [Setting up PHP via FastCGI in Apache2 on Ubuntu](http://igor.gold.ac.uk/~mas01rwb/pages/apache-php-fastcgi.html)
	- (host:port) [How to configure Apache to run PHP as FastCGI on Ubuntu 12.04 via terminal](http://askubuntu.com/questions/378734/how-to-configure-apache-to-run-php-as-fastcgi-on-ubuntu-12-04-via-terminal)
	- (auto spawn) [Install apache + php with mod fastcgi on ubuntu](http://www.binarytides.com/install-apache-php-mod-fastcgi-ubuntu/)
	- [Setting up Perl FastCGI with Nginx](http://nginxlibrary.com/perl-fastcgi/)
		- update-rc.d & insserv
		- BUT, this is still technically CGI (via 'perl-fastCGI')
	- [Nginx and PHP-FastCGI on Fedora 14](https://library.linode.com/web-servers/nginx/php-fastcgi/fedora-14)
		- chkconfig &amp; daemon
		- remember, PHP-FastCGI must be spawned external to Nginx
- (C) [Nginx, fastcgi, 'Hello World' in C](http://www.kutukupret.com/2010/08/20/nginx-fastcgi-hello-world-in-c/)
- (C++) [Writing Hello World in FCGI with C++](http://chriswu.me/blog/writing-hello-world-in-fcgi-with-c-plus-plus/)
- (C++) [Getting Request URI and Content in C++ FCGI](http://chriswu.me/blog/getting-request-uri-and-content-in-c-plus-plus-fcgi/)

### cgi-bin

- (C/C++) [C++ Web Programming](http://www.tutorialspoint.com/cplusplus/cpp_web_programming.htm)
- (perl) [PERL and CGI Tutorial](http://www.tutorialspoint.com/perl/perl_cgi.htm)
- (python) [Python CGI Programming](http://www.tutorialspoint.com/python/python_cgi_programming.htm)
- (ruby) [Ruby and the Web](http://ruby-doc.com/docs/ProgrammingRuby/html/web.html)

<!--
[//] # (- (python) [CgiScripts - PythonInfo Wiki](http://wiki.python.org/moin/CgiScripts)                                )
[//] # (- (ruby) [Ruby Web Applications - CGI Programming](http://www.tutorialspoint.com/ruby/ruby_web_applications.htm) )
[//] # (- (ruby) [PLEAC-Ruby](http://pleac.sourceforge.net/pleac_ruby/cgiprogramming.html)                               )
-->

* * *

