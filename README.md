<!--
[//] # (LEFT OFF ON: search for TODO                                          )
[//] # (LEFT OFF ON: search for TODO                                          )

[//] # (network_notes1 - exlixir golang scala                                 )
[//] # (docker_cheatsheet2 - latest                                           )
[//] # (docker external - favorite dockerfiles                                )
[//] # (network_notes3 - concurrency                                          )

[//] # (UE4 build notes - README.md                                           )
[//] # (networking: AWS (Signature Version 4) - link to HTML5ToolChain        )
[//] # (html5_cheatsheet3 - emscripten - my notes...                          )

[//] # (LLVM:                                                                 )
[//] # (- clang sample project (study emscripten/YouCompleteMe?)              )
[//] # (- update external links                                               )
[//] # (networking:                                                           )
[//] # (- #3: SIP                                                             )
[//] # (- stunnel to inside the firewall                                      )
[//] # (- selenium & phantomjs                                                )
[//] # (3D math #2                                                            )

[//] # (LEFT OFF ON: search for TODO                                          )
[//] # (LEFT OFF ON: search for TODO                                          )
-->

# Nick Shin's Programming Cheatsheets

This page will list some sample code files that I have writen and have
made available to the public domain.

These are mostly to help remind me a few bits of details that (when working
with a pile of different programming and scripting languages) I like to copy
and paste code that I use a lot (efficiently), often (lazy) or rarely (forgetful).

* * *

### C

<span class="bold">[c_cheatsheet1.c](code/c_cheatsheet1.c)</span> will describe
**design patterns** in C
(<span class="note1">even though patterns are normally used with Object Oriented languages</span>)
- creational patterns
- structural patterns
- behavioral patterns
- design principles

<!--
[//] # ( o'reilly - head first: design patterns - 2004                                                        )
[//] # ( ch1 p32(44) patterns & strategy                                                                      )
[//] # ( ch2 p74(86) observers                                                                                )
[//] # ( ch3 p105(117) decorator                                                                              )
[//] # (     p84(96)                                                                                          )
[//] # (     "... can see POTENTIAL problems with this approach by thinking                                   )
[//] # (      about how the design MIGHT need to change in the FUTURE..."                                     )
[//] # ( ch4 p162(174) factory                                                                                )
[//] # ( ch5 p186(198) singleton [keyword:synchronized - expensive operation; so use only when needed]        )
[//] # ( ch6 p230(242) command                                                                                )
[//] # ( ch7 p270(282) adapter & façade                                                                       )
[//] # ( ch8 p311(323) template method [keyword:final - prevent subclasses from overriding a template method] )
[//] # ( ch9 p380(392) iterator & composite                                                                   )
[//] # ( ch10 p423(435) state                                                                                 )
[//] # ( ch11 p491(503) proxy                                                                                 )
[//] # ( ch12 p560(572) MVC & model2                                                                          )
[//] # ( ch13 p608(620) misc                                                                                  )
[//] # (     p595(607)                                                                                        )
[//] # (     "refactoring time is patterns time"                                                              )
[//] # (     "take out what you don't really need"                                                            )
[//] # (     "if you don't need it now, don't do it now"                                                      )
[//] # (     p598(610)                                                                                        )
[//] # (     "Overuse of design patterns can lead to code that is downright                                   )
[//] # (      over-engineered. Always go with the simplest solution that does                                 )
[//] # (      the job and introduce patterns where the need emerges."                                         )
-->

* * *

### C++

<span class="bold">[cpp_cheatsheet1.cpp](code/cpp_cheatsheet1.cpp)</span> covers the following C++ usage:
- constructors
- destructors
- base, derived, multiple inheritance and friendship classes
- private vs protected vs public member data access
- pure and basic virtual function declarations
- polymorphism
- type casting

<span class="bold">[cpp_cheatsheet2.cpp](code/cpp_cheatsheet2.cpp)</span> covers the following C++ usage:
- templates
- const-ness
- dynamic memory
- exceptions

<span class="bold">[cpp_cheatsheet3.cpp](code/cpp_cheatsheet3.cpp)</span> covers the following:
- STL programming
	- containers
	- algorithms
- some Boost library features
	- foreach
	- smart pointers
- and using class string

**external links:**
- <span class="note1">[Bartlomiej Filipek](https://www.bfilipek.com) - an amazing resource on all things c++</span>
- <span class="note1">keep a page opened to: [cppreference.com](http://cppreference.com/)</span>

<!--
[//] # ( - [C++17](https://en.wikipedia.org/wiki/C%2B%2B17)
[//] # ( - [C++14](https://en.wikipedia.org/wiki/C%2B%2B14)
[//] # ( - [C++11](https://en.wikipedia.org/wiki/C%2B%2B11)
[//] # ( 	- multithreaded (
[//] # ( 		[atomic](http://www.cplusplus.com/reference/atomic/),
[//] # ( 		[future](http://www.cplusplus.com/reference/future/),
[//] # ( 		[condition](http://www.cplusplus.com/reference/condition_variable/condition_variable/),
[//] # ( 		etc.)
[//] # ( 	- smart pointers (
[//] # ( 		[unique](http://www.cplusplus.com/reference/memory/unique_ptr/),
[//] # ( 		[shared](http://www.cplusplus.com/reference/memory/shared_ptr/),
[//] # ( 		[weak](http://www.cplusplus.com/reference/memory/weak_ptr/),
[//] # ( 		etc.)
[//] # ( 	- new types ( auto inference, range-based for loop, Rvalue, constexpr, un/ordered hash tables, etc. )
[//] # ( 	- lamba functions and syntax
-->

* * *

### LLVM

(<span class="note1">coming soon</span>)
<span class="bold">LLVM_Clang_cheatsheet1[](code/LLVM_Clang_cheatsheet1.sh)</span>
notes and boilerplate LLVM &amp; Clang project

**external links:**
- the list is so large, they are placed here: [LLVM_external_links](code/LLVM_external_links.md)

* * *

### Perl

<span class="bold">[perl_cheatsheet1.pl.inc](code/perl_cheatsheet1.inc)</span>
written to be included in by perl_cheatsheet2 and contains the following perl snippets:
- unique sort
- time n date
- file notes
- wget

<span class="bold">[perl_cheatsheet2.pl](code/perl_cheatsheet2.pl)</span>
executable and contains more perl snippets:
- file IO
- fork
- arrays, arrays of arrays, array references, slice n splice
- hashes, hashes of arrays, hash references
- references to functions
- and some boiler plate code

<span class="bold">[perl_cheatsheet3.pm](code/perl_cheatsheet3.pm)</span> is an example perl module and
<span class="bold">[perl_cheatsheet4.pl](code/perl_cheatsheet4.pl)</span> &amp;
<span class="bold">[perl_cheatsheet5.pl](code/perl_cheatsheet5.pl)</span> uses the perl module
while showing the tiny differences on:
- require
- use
- fully qualified names
- automatic exported names
- controlled (manually) exported names

**external links:**
- <span class="note1">good collection of perl tips: [Perl Training Australia - Perl Tips](http://perltraining.com.au/tips/)</span>
- <span class="note1">and if you ever thought to yourself, "someone has to have written this in PERL"...
chances are: someone did and threw it up on <span class="bold">[CPAN](http://www.cpan.org/)</span></span>

* * *

### Python

<span class="bold">[python_cheatsheet1.py](code/python_cheatsheet1.py)</span> covers the following python usage:
- some of my most used python snippets
- file IO
- dictionary
- lists, tuples and arrays
- classes

<!--
[//] # ( <span class="bold">python_cheatsheet2.py[](code/python_cheatsheet2.py)</span> covers the following C/C++ with python interaction )
[//] # ( - access python scripts from C/C++ code )
[//] # ( - access C/C++ code from python script  )
[//] # ( - dynamic library loading in python     )
[//] # ( - script load/reloading in C/C++        )
[//] # ( - handle basic data structures          )
[//] # ( 	- structs                            )
[//] # ( 	- union                              )
[//] # ( 	- pointers                           )
[//] # ( 	- return values                      )
-->

here are some more python code i have made free to the public:
- [https://www.nickshin.com/bookmark_tools/](https://www.nickshin.com/bookmark_tools/)

**external links:**<br>
- <span class="note1">keep a page opened to: [Python: Library Reference](http://docs.python.org/library/index.html)</span>
- <span class="note1">and if you ever thought to yourself, "someone has to have written this in PYTHON"...
chances are: someone did and threw it up on <span class="bold">[PyPI](https://pypi.python.org/pypi)</span></span>

* * *

### Ruby

Please see my [networking notes](#network) for more sample code written in
Ruby used to generate the all of the network code and pretty printed HTML files.

**external links:**<br>
- <span class="note1">[Ruby for the Attention Deficit Disorder Programmer](http://www.fincher.org/tips/Languages/Ruby/)
cheatsheet/crash course</span>
- <span class="note1">on command line arguments:</span>
	- <span class="note1">[stackoverflow.com](http://stackoverflow.com/questions/5688685/getoptlong-ruby-help)</span>
	- <span class="note1">[o'reilly linuxdevcenter.com](http://linuxdevcenter.com/pub/a/linux/2003/09/18/ruby_csv.html?page=2)</span>
- <span class="note1">and if you ever thought to yourself, "someone has to have written this in RUBY"...
chances are: someone did and threw it up on <span class="bold">[RubyGems](http://rubygems.org/)</span></span>

* * *

### Network

<span class="bold">[network_notes1.rb](code/network_notes1.rb)</span> covers networking sockets (open read write close)
(both peer2peer and multi-users) in:
- C/C++
- C#
- Exlixir
- GoLang
- Java
- Node.js
- Perl
- Python
- Ruby
- Scala

if the "all in one file" is too confusing to look at <span class="note1">(hurray for VIM! ":set filetype=lang")</span>,
run the script to generate all of the network code for the different programming languages:
```sh
ruby network_notes1.rb code
```

<span class="bold">[network_notes2.md](code/network_notes2.md)</span> covers the following networking snippets:
- [Node.js](code/network_nodejs.js)
	- http(s)://
	- ws(s)://
	- AMQP(s)://
	- XMPP(s)://
- HTTPd
	- SSL
	- CGI / FastCGI
- AMQP
	- RabbitMQ
- XMPP
	- ejabberd
		- writing server components
		- websockets
		- HTTP binding
		- admin

<span class="bold">[network_notes2_htaccess.pl](code/network_notes2_htaccess.pl)</span>
generates .htaccess files (for authentication access) for
- Apache
- lighttpd

<span class="bold">[network_notes3.md](code/network_notes3.md)</span> covers the following networking snippets:
- Concurrency
- WebSockets
- WebRTC
- SSL (libraries)
- behind firewall <span class="note1">(STUN TURN ICE)</span>

**my notes** on:
- [stunnel.md](code/network_stunnel.md)
- [smtp.md](code/network_smtp.md)

<!--
[//] # ( TODO: update stunnel with info on howto: access work machine from home =) )
[//] # ( TODO: - AWS[](code/network_AWS.md) )
[//] # ( TODO: - selenium[](code/network_selenium.md) )
-->

**external links** (<span class="note1">Writing Network Servers</span>)
- the list was getting large, they are placed here: [network_external_links](code/network_external_links.md)

* * *

### HTML5

<span class="bold">[HTML5-cheatsheet1](HTML5-cheatsheet1)</span> covers the following HTML5 topics:
1. WARNING: these are pretty old and i don't really use them anymore -- left here for reference...
	1. canvas
	1. css3
	1. devicemotion<span class="super">[1]</span>
	1. deviceorientation<span class="super">[1]</span>
	1. eventsource<span class="super">[2]</span>
	1. fullscreen<span class="super">[1]</span>
	1. geolocation<span class="super">[1]</span>
	1. javascript<span class="super">[2]</span> classes and modules
	1. svg
	1. webaudio and webvideo
	1. webGL<span class="super">[1]</span>: requestAnimationFrame
	  <span class="note1">(warning: many mobile <span class="underline">browsers</span> do not have hardware acceleration)</span>
	1. websocket<span class="super">[2]</span>
	1. webstorage: appcache
	1. webstorage: FileReader<span class="super">[3]</span>
	1. webstorage: indexDB<span class="super">[2] [4]</span>
	1. webstorage: localStorage
	1. webworkers<span class="super">[5]</span>

<span class="bold">[HTML5-cheatsheet2](HTML5-cheatsheet2)</span> covers the following demos:
1. WARNING: these are pretty old and i don't really use them anymore -- left here for reference...
	1. AudioAPI
	1. Audio Element (webaudio revisited -- tests): <span class="note1">(NOTE: this is NOT AudioAPI but the &lt;audio&gt; element)</span>
	1. drag &amp; drop<span class="super">[1]</span>
	1. gamepad<span class="super">[6]</span> <span class="note1">(note: it seems better to just map pad to keyboard strokes...)</span>
	1. mouselock<span class="super">[6]</span>
	1. swipegesture<span class="super">[2]</span>: sketchpad + noclickdelay

note: all files are written static (i.e. plain ol' HTML) so they can be looked up or run as-is.
1. copy of reference source (or close to it) for testing purposes
1. terse and was written to be re/usable
1. WARNING: Safari does NOT support FileReader API (but WebKit [on Chrome] and Mozilla does).
1. WARNING: WebKit has a slightly different handler requirement after accessing DB with no results
1. WARNING: WebKit does NOT support subworkers (but Mozilla does).  Mozilla does NOT support SharedWorker (but WebKit does).
1. Work In Progress... coming soon

<span class="note1">(coming soon)</span> <span class="bold">HTML5-cheatsheet3[](HTML5-cheatsheet3)</span> covers the following topics:
- emscripten
	- web assembly
	- webgl2
	- multi-threading
	- file manager (async and local storage)

**external links:**
- <span class="note1">[HTML 5 Rocks](http://www.html5rocks.com/en/) - the mother load of all things HTML5</span>
- <span class="note1">[HTML 5 Canvas Tutorials](http://www.html5canvastutorials.com/) - excellent crash course on using the canvas</span>
- <span class="note1">[HTML 5 Demos and Examples](http://html5demos.com/) - a nice collection of little HTML5 howtos</span>
- <span class="note1">[Stories In Flight: HTML5/CSS3 Cheatsheet](http://www.storiesinflight.com/html5/) - a nice and little and easy to read summary of HTML5 features</span>
- <span class="note1">[HTML5 differences from HTML4](http://www.w3.org/TR/html5-diff/) - a very terse but good read on HTML5 differences</span>

* * *

### PHP

<span class="bold">[php_cheatsheet1.php](code/php_cheatsheet1.php)</span> covers the following PHP usage:
- predefined variables: _GET _POST _SERVER _FILES
- binary and file handling
- passing by reference
- classes

<span class="bold">[php_cheatsheet2.php](code/php_cheatsheet2.php)</span> covers the following PHP usage:
- user agent detection
- crafted headers
- memcache
- NoSQL <span class="note1">(coming soon, my most used snippets...)</span>

**external links**
- <span class="note1">it might be useful to enable
[PHP: short_open_tag](http://www.php.net/manual/en/ini.core.php#ini.short-open-tag)</span>
- <span class="note1">keep a page opened to: [PHP: function reference](http://www.php.net/manual/en/funcref.php)</span>

* * *

### Linux

<span class="bold">[docker_cheatsheet1.md](code/docker_cheatsheet1.md)</span> covers the following:
- some of my most used docker snippets
- local/private registry notes

<span class="bold">docker_cheatsheet2.md[](code/docker_cheatsheet2.md)</span> <span class="note1">(coming soon)</span>
- provisioning <span class="note1">(machine)</span>
- clustering/scheduling <span class="note1">(swarm &amp; swarmkit)</span>
- orchestration <span class="note1">(composer)</span>
- service discovery
- monitoring/security

<!--
[//] # ( https://lostechies.com/gabrielschenker/2016/11/25/docker-and-swarmkit-part-6-new-features-of-v1-13/ )
-->

<span class="bold">docker_cheatsheet3.md[](code/docker_cheatsheet3.md)</span> <span class="note1">(coming soon)</span>
- my favorite Dockerfiles
- unikernels

<!--
[//] # ( https://alpinelinux.org/downloads/                         )
[//] # ( https://github.com/mfornos/awesome-microservices           )
[//] # ( http://unikernel.org/projects/                             )

[//] # ( https://github.com/technolo-g/lookma                       )
[//] # ( https://github.com/Unikernel-Systems/DockerConEU2015-demo/ )

[//] # ( http://runtimejs.org/                                      )
[//] # ( http://erlangonxen.org/                                    )
-->

<span class="bold">[LLVM_Linux_cheatsheet1.sh](code/LLVM_Linux_cheatsheet1.sh)</span> notes on building LLVMLinux with LLVM, Clang and LLDB

<span class="bold">[linux_writingdevicedrivers1.md](code/linux_writingdevicedrivers1.md)</span> covers the following:
- kernel module programming
- character device driver
- usb stick example

<span class="bold">[linux_SSD.md](code/linux_SSD.md)</span> notes on SolidStateDrive optimizations, display DPI settings and surface pro 3 configurations

**external links:**
-  the list was getting large, they are placed here: [Linux_external_links](code/linux_external_links.md)

* * *

### Vim

[https://github.com/nickshin/vimfiles](https://github.com/nickshin/vimfiles)

latest <span class="bold">[vimrc](https://github.com/nickshin/vimfiles/vimrc)</span> file I use:
- editor configuration
- plugin mapings
- and some archived configs and maps for reference

my <span class="bold">[vim_notes.txt](https://github.com/nickshin/vimfiles/vim_notes.txt)</span> on plugins &amp; stuff
- a list of plugins i found useful in the past or currently
- a bit of how to use them and where to find them
- and old settings that i used to use...

<span class="bold">[vim_fetch.sh](https://github.com/nickshin/vimfiles/vim_fetch.sh)</span> plugins
- normally, plugins only need be placed in: **.vim/bundle**
- but sometimes, some packages needs some extra hand holding to get em working (especially when working on a bunch of different OS)
- this script helps me remember them

**external links:**
- HowTos:
	- <span class="note1">[Vim Book](ftp://ftp.vim.org/pub/vim/doc/book/vimbook-OPL.pdf) (get a hard copy so you can write notes in it...)</span>
	- <span class="note1">[Derek Wyatt's Vim Tutorial Videos](http://derekwyatt.org/vim/tutorials/) (HIGHLY RECOMMENDED !!! excellent crash course on Vim)</span>
	- <span class="note1">[vimcasts.org](http://vimcasts.org/episodes/archive) (MUST WATCH for intermediate Vim users)</span>
	- <span class="note1">**:h index** (HIGHLY RECOMMENDED !!! after watching the vids above,
		spend a night with this help page -- don't jump out of it, just skim and keep re-skim'ing this page -- and
		you will be well on your way to mastering Vim)</span>

- Tips:
	- <span class="note1">[vim quick reference card](http://tnerual.eriogerg.free.fr/vimqrc.html)</span>
	- <span class="note1">[Graphical vi-vim Cheat Sheet and Tutorial](http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html)</span>
	- <span class="note1">[How to paste text into Vim command line](http://stackoverflow.com/questions/3997078/how-to-paste-text-into-vim-command-line) <span class="note1">(advanced -- and a lot of good info on registers)</span></span>
	- <span class="note1">[vim tips](http://www.rayninfo.co.uk/vimtips.html) <span class="note1">(NOTE: you may need to click on this link twice -- the first time may send you to a vim webring...)</span></span>

- Writing your own plugins:
	- <span class="note1">[Writing Vim Plugins](http://stevelosh.com/blog/2011/09/writing-vim-plugins/) <span class="note1">by steve losh</span></span>
		- <span class="note1">**:help usr_41**</span>
		- <span class="note1">**:help write-plugin**</span>
		- <span class="note1">[A Byte of Vim](http://files.swaroopch.com/vim/byte_of_vim_v051.pdf) <span class="note1">by Swaroop C H</span></span>
		  <span class="note1">  - search for "en:Scripting"</span>
		- <span class="note1">[Learning the vi Editor/Vim/VimL Script language](https://en.wikibooks.org/wiki/Learning_the_vi_Editor/Vim/VimL_Script_language)</span>

* * *

### 3D Math

<span class="bold">[3D_notes1](code/3D_notes1.md)</span> covers the following 3D math:
- matrix math
- vector math
- lines w/ points, lines, circles equations
- planes w/ points, lines, planes equations

<!--
[//] # ( TODO: <span class="bold">3D_notes2[](code/3D_notes2.md)</span> covers the following 3D math: )
[//] # ( TODO: - quaternions )
[//] # ( TODO: - curves      )
[//] # ( TODO: - surfaces    )
-->

* * *

### Misc

- [my bookmarks](https://www.nickshin.com/bookmark_tools/demo/index.html)
- [Git-LFS](code/gitlfs_gitlab.md) <span class="note1">(with GitLab)</span>
- [rsync](code/rsync_notes.md)
- [sql](code/sql_notes.md)

**external links:**
- <span class="note1">Git:</span>
	- <span class="note1">[GIT cheat sheet](http://www.rsbac.org/documentation/dev/scm/git#the_cheat_sheet_this_is_where_you_find_all_common_commands)</span>
	- <span class="note1">[Understanding the GitHub Flow](https://guides.github.com/introduction/flow/)</span>
	- <span class="note1">[How to Create a shared Git Repository in Debian (ssh, git-daemon, gitweb)](http://linuxclues.blogspot.com/2013/06/git-daemon-ssh-create-repository-debian.html) <span class="note1">(onsite repository)</span></span>
	- <span class="note1">[Lesser Known Git Commands](https://dzone.com/articles/lesser-known-git-commands)</span>
	- <span class="note1">[Git Submodules: Core Concept, Workflows, And Tips](https://dzone.com/articles/core-concept-workflows-and-tips)</span>
	- <span class="note1">[Git Large File Storage](https://git-lfs.github.com/)</span>
	- <span class="note1">[Git rebase](https://medium.freecodecamp.com/git-rebase-and-the-golden-rule-explained-70715eccc372#.qdpwnk4af)</span>
	- <span class="note1">[GitKraken Tips](https://blog.axosoft.com/tag/gitkrakentip/)</span>

- <span class="note1">Cheat Sheets Collections</span>
	- <span class="note1">[Cheat-Sheets.org](http://www.cheat-sheets.org/)</span>
	- <span class="note1">[OverAPI.com](http://overapi.com/)</span>

* * *

## License

[Unlicense](http://unlicense.org/)

* * *




<style>
.bold          { font-weight: bold; }
ol, .note1     { font-size: 11px; }
.super, .note2 { font-size: 9px; }
.super         { vertical-align: super; }
.underline     { text-decoration: underline; }
</style>

