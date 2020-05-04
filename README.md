<!--
[//] # (LEFT OFF ON: search for TODO                                          )
[//] # (LEFT OFF ON: search for TODO                                          )

[//] # (network_notes1 - exlixir golang rust scala                            )
[//] # (docker_cheatsheet2 - latest                                           )
[//] # (docker external - favorite dockerfiles                                )
[//] # (network_notes3 - concurrency                                          )

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

#### Nick Shin's Programming Cheatsheets

This page will list some sample code files that I have writen and have
made available to the public domain.

These are mostly to help remind me a few bits of details that (when working
with a pile of different programming and scripting languages) I like to copy
and paste code that I use a lot (efficiently), often (lazy) or rarely (forgetful).

* * *

# C

## [c_cheatsheet1.c](code/c_cheatsheet1.c)
- will describe **design patterns** in C
(even though patterns are normally used with Object Oriented languages)
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

# C++

## [cpp_cheatsheet1.cpp](code/cpp_cheatsheet1.cpp)
- covers the following C++ usage:
	- constructors
	- destructors
	- base, derived, multiple inheritance and friendship classes
	- private vs protected vs public member data access
	- pure and basic virtual function declarations
	- polymorphism
	- type casting

## [cpp_cheatsheet2.cpp](code/cpp_cheatsheet2.cpp)
- covers the following C++ usage:
	- templates
	- const-ness
	- dynamic memory
	- exceptions

## [cpp_cheatsheet3.cpp](code/cpp_cheatsheet3.cpp)
- covers the following:
	- STL programming
		- containers
		- algorithms
	- some Boost library features
		- foreach
		- smart pointers
	- and using class string

**external links:**
- _[Bartlomiej Filipek](https://www.bfilipek.com) - an amazing resource on all things c++_
- _[The World Map of C+++ STL Algorithms](https://www.fluentcpp.com/getthemap/) - a fun way to learn 105 STL Algorithms in less than an hour_
- _[lvalues and rvalues in C++](https://www.youtube.com/watch?v=fbYknr-HPYE) - and more great C++ crash course videos_
- _keep a page opened to: [cppreference.com](http://cppreference.com/)_

<!--
[//] # (	- [C++17](https://en.wikipedia.org/wiki/C%2B%2B17)
[//] # ( 	- [C++14](https://en.wikipedia.org/wiki/C%2B%2B14)
[//] # ( 	- [C++11](https://en.wikipedia.org/wiki/C%2B%2B11)
[//] # ( 		- multithreaded (
[//] # ( 			[atomic](http://www.cplusplus.com/reference/atomic/),
[//] # ( 			[future](http://www.cplusplus.com/reference/future/),
[//] # ( 			[condition](http://www.cplusplus.com/reference/condition_variable/condition_variable/),
[//] # ( 			etc.)
[//] # ( 		- smart pointers (
[//] # ( 			[unique](http://www.cplusplus.com/reference/memory/unique_ptr/),
[//] # ( 			[shared](http://www.cplusplus.com/reference/memory/shared_ptr/),
[//] # ( 			[weak](http://www.cplusplus.com/reference/memory/weak_ptr/),
[//] # ( 			etc.)
[//] # ( 		- new types ( auto inference, range-based for loop, Rvalue, constexpr, un/ordered hash tables, etc. )
[//] # ( 		- lamba functions and syntax
-->

* * *

# LLVM

#### LLVM_Clang_cheatsheet1[](code/LLVM_Clang_cheatsheet1.sh) (_coming soon_)
- notes and boilerplate LLVM &amp; Clang project

**external links:**
- the list is so large, they are placed here: [LLVM_external_links](code/LLVM_external_links.md)

* * *

# Perl

## [perl_cheatsheet1.pl.inc](code/perl_cheatsheet1.inc)
- written to be included in by perl_cheatsheet2 and contains the following perl snippets:
	- unique sort
	- time n date
	- file notes
	- wget

## [perl_cheatsheet2.pl](code/perl_cheatsheet2.pl)
- executable and contains more perl snippets:
	- file IO
	- fork
	- arrays, arrays of arrays, array references, slice n splice
	- hashes, hashes of arrays, hash references
	- references to functions
	- and some boiler plate code

## [perl_cheatsheet3.pm](code/perl_cheatsheet3.pm)
- example perl module

## [perl_cheatsheet4.pl](code/perl_cheatsheet4.pl)

## [perl_cheatsheet5.pl](code/perl_cheatsheet5.pl)
- using the perl module
- while showing the tiny differences on:
	- require
	- use
	- fully qualified names
	- automatic exported names
	- controlled (manually) exported names

**external links:**
- _good collection of perl tips: [Perl Training Australia - Perl Tips](http://perltraining.com.au/tips/)_
- _and if you ever thought to yourself, "someone has to have written this in PERL"...
chances are: someone did and threw it up on **[CPAN](http://www.cpan.org/)**_

* * *

# Python

## [python_cheatsheet1.py](code/python_cheatsheet1.py)
- covers the following python usage:
	- some of my most used python snippets
	- file IO
	- dictionary
	- lists, tuples and arrays
	- classes

<!--
[//] # ( ## python_cheatsheet2.py[](code/python_cheatsheet2.py) )
[//] # ( - covers the following C/C++ with python interaction   )
[//] # (	- access python scripts from C/C++ code             )
[//] # ( 	- access C/C++ code from python script              )
[//] # ( 	- dynamic library loading in python                 )
[//] # ( 	- script load/reloading in C/C++                    )
[//] # ( 	- handle basic data structures                      )
[//] # ( 		- structs                                       )
[//] # ( 		- union                                         )
[//] # ( 		- pointers                                      )
[//] # ( 		- return values                                 )
-->

here are some more python code i have made free to the public:
- [https://www.nickshin.com/bookmark_tools/](https://www.nickshin.com/bookmark_tools/)

**external links:**
- _keep a page opened to: [Python: Library Reference](http://docs.python.org/library/index.html)_
- _and if you ever thought to yourself, "someone has to have written this in PYTHON"...
chances are: someone did and threw it up on **[PyPI](https://pypi.python.org/pypi)**_

* * *

# Ruby

Please see my [networking notes](#network) for more sample code written in
Ruby used to generate the all of the network code and pretty printed HTML files.

**external links:**
- _[Ruby for the Attention Deficit Disorder Programmer](http://www.fincher.org/tips/Languages/Ruby/)
cheatsheet/crash course_
- _on command line arguments:_
	- _[stackoverflow.com](http://stackoverflow.com/questions/5688685/getoptlong-ruby-help)_
	- _[o'reilly linuxdevcenter.com](http://linuxdevcenter.com/pub/a/linux/2003/09/18/ruby_csv.html?page=2)_
- _and if you ever thought to yourself, "someone has to have written this in RUBY"...
chances are: someone did and threw it up on **[RubyGems](http://rubygems.org/)**_

* * *

# Network

## [network_notes1.rb](code/network_notes1.rb)
- covers networking sockets (open read write close) (for both peer2peer and multi-users) in:
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

if the "all in one file" is too confusing to look at _(hurray for VIM! ":set filetype=lang")_,
run the script to generate all of the network code for the different programming languages:

```sh
ruby network_notes1.rb code
```

## [network_notes2.md](code/network_notes2.md)
- covers the following networking snippets:
	- [Node.js](code/network_nodejs.js)
		- http(s)://
		- ws(s)://
		- AMQP(s)://
		- XMPP(s)://
	- Let's Encrypt
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

## [network_notes2_htaccess.pl](code/network_notes2_htaccess.pl) (_OLD_)
- generates .htaccess files (for authentication access) for
	- Apache
	- lighttpd

## [network_notes3.md](code/network_notes3.md)
- covers the following networking snippets:
	- Concurrency
	- WebSockets
	- WebRTC
	- SSL (libraries)
	- behind firewall _(STUN TURN ICE)_

**my notes** on:
- [wireguard.md](code/network_wireguard.md)
- [openvpn.md](code/network_openvpn.md)
- [stunnel.md](code/network_stunnel.md)
- [smtp.md](code/network_smtp.md)

<!--
[//] # ( TODO: update stunnel with info on howto: access work machine from home =) )
[//] # ( TODO: - AWS[](code/network_AWS.md) )
[//] # ( TODO: - selenium[](code/network_selenium.md) )
-->

**external links** (_Writing Network Servers_)
- the list was getting large, they are placed here: [network_external_links](code/network_external_links.md)

* * *

# HTML5

#### [HTML5-cheatsheet1](HTML5-cheatsheet1) (_OLD_)
- WARNING: i do not use these anymore -- left here for reference...
- covered things like: screen orientation, audio, video, websockets and webstorage

#### [HTML5-cheatsheet2](HTML5-cheatsheet2) (_OLD_)
- WARNING: i do not use these anymore -- left here for reference...
- covered demos like: audio, drag &amp; drop, pointerlock and swipegesture

## HTML5-cheatsheet3[](HTML5-cheatsheet3)
- was going to cover the following topics:
	- emscripten
		- web assembly
		- webgl2
		- multi-threading
		- file manager (async and local storage)
- much of this work was plowed into:
	- _[UnrealEngineHTML5](https://github.com/UnrealEngineHTML5/Documentation)_
		- _run your UE4 projects in the (latest) browsers!_
		- i helped maintained this for a handful of years until EPIC has ended official support of the HTML5 platform the end of 2019


**external links:**
- _[HTML5 Gamepad Tester](https://html5gamepad.com/) - fantastic way to test your gamepads on your OS on your browser_
- _[three.js](https://threejs.org/) - the mother load of all things 3D in HTML5_
- _[d3js.js](https://d3js.org/) - the mother load of all things data-driven-docs in HTML5_

<!--
[//]- _[tipboard](http://allegro.tech/tipboard/)_
[//]- _[grafana](https://grafana.com/)_
-->

#### favorite browser extensions:
- _[uBlock Origin](https://github.com/gorhill/uBlock)_
- _[Video Speed Controller](https://github.com/codebicycle/videospeed)_
- _[Markdown Viewer](https://github.com/simov/markdown-viewer)_
- _[Dark Mode](https://mybrowseraddon.com/dark-mode.html)_

<!--
[//]- _[BypassPaywalls](https://mybrowseraddon.com/dark-mode.html)_
[//]- _[Video DownloadHelper](http://www.downloadhelper.net/)_
-->

#### favorite mobile browser:
- _Firefox Focus_
	- _for [Android](https://play.google.com/store/apps/details?id=org.mozilla.focus&hl=en_US)_
	- _for [iOS](https://apps.apple.com/us/app/firefox-focus-privacy-browser/id1055677337)_

* * *

# PHP

## [php_cheatsheet1.php](code/php_cheatsheet1.php)
- covers the following PHP usage:
	- predefined variables: _GET _POST _SERVER _FILES
	- binary and file handling
	- passing by reference
	- classes

## [php_cheatsheet2.php](code/php_cheatsheet2.php)
- covers the following PHP usage:
	- user agent detection
	- crafted headers
	- memcache
	- NoSQL _(coming soon, my most used snippets...)_

**external links**
- _it might be useful to enable [PHP: short_open_tag](http://www.php.net/manual/en/ini.core.php#ini.short-open-tag)_
- _keep a page opened to: [PHP: function reference](http://www.php.net/manual/en/funcref.php)_

* * *

# Linux

## [docker_cheatsheet1.md](code/docker_cheatsheet1.md)
- covers the following:
	- some of my most used docker snippets
	- local/private registry notes

#### docker_cheatsheet2.md[](code/docker_cheatsheet2.md) _(coming soon)_
- provisioning _(machine)_
- clustering/scheduling _(swarm &amp; swarmkit)_
- orchestration _(composer)_
- service discovery
- monitoring/security

<!--
[//] # ( https://lostechies.com/gabrielschenker/2016/11/25/docker-and-swarmkit-part-6-new-features-of-v1-13/ )
[//] # ( orchestration:kubernetes - https://tekton.dev/ )
-->

#### docker_cheatsheet3.md[](code/docker_cheatsheet3.md) _(coming soon)_
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

## [LLVM_Linux_cheatsheet1.sh](code/LLVM_Linux_cheatsheet1.sh)
- notes on building LLVMLinux with LLVM, Clang and LLDB

## [linux_writingdevicedrivers1.md](code/linux_writingdevicedrivers1.md)
- covers the following:
	- kernel module programming
	- character device driver
	- usb stick example

## [linux_SSD.md](code/linux_SSD.md)
- notes on SolidStateDrive optimizations, display DPI settings and surface pro 3 configurations

**external links:**
- the list was getting large, they are placed here: [Linux_external_links](code/linux_external_links.md)

* * *

# Vim

## [https://github.com/nickshin/vimfiles](https://github.com/nickshin/vimfiles)

- latest [vimrc](https://github.com/nickshin/vimfiles/blob/master/vimrc) file I use:
	- editor configuration
	- plugin mapings
	- and some archived configs and maps for reference

- my [vim_notes.txt](https://github.com/nickshin/vimfiles/blob/master/vim_notes.txt) on plugins &amp; stuff
	- a list of plugins i found useful in the past or currently
	- a bit of how to use them and where to find them
	- and old settings that i used to use...

- [vim_fetch.sh](https://github.com/nickshin/vimfiles/blob/master/vim_fetch.sh) plugins
	- normally, plugins only need be placed in: **.vim/bundle**
	- but sometimes, some packages needs some extra hand holding to get em working (especially when working on a bunch of different OS)
	- this script helps me remember them

**external links:**
- HowTos:
	- _[Vim Book](ftp://ftp.vim.org/pub/vim/doc/book/vimbook-OPL.pdf) (get a hard copy so you can write notes in it...)_
	- _[Derek Wyatt's Vim Tutorial Videos](http://derekwyatt.org/vim/tutorials/) (HIGHLY RECOMMENDED !!! excellent crash course on Vim)_
	- _[vimcasts.org](http://vimcasts.org/episodes/archive) (MUST WATCH for intermediate Vim users)_
	- _**:h index** (HIGHLY RECOMMENDED !!! after watching the vids above,
		spend a night with this help page -- don't jump out of it, just skim and keep re-skim'ing this page -- and
		you will be well on your way to mastering Vim)_

- Tips:
	- _[vim quick reference card](http://tnerual.eriogerg.free.fr/vimqrc.html)_
	- _[Graphical vi-vim Cheat Sheet and Tutorial](http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html)_
	- _[How to paste text into Vim command line](http://stackoverflow.com/questions/3997078/how-to-paste-text-into-vim-command-line) (advanced -- and a lot of good info on registers)_
	- _[vim tips](http://www.rayninfo.co.uk/vimtips.html) (NOTE: you may need to click on this link twice -- the first time may send you to a vim webring...)_

- Writing your own plugins:
	- _[Writing Vim Plugins](http://stevelosh.com/blog/2011/09/writing-vim-plugins/) by steve losh_
		- _**:help usr_41**_
		- _**:help write-plugin**_
		- _[A Byte of Vim](http://files.swaroopch.com/vim/byte_of_vim_v051.pdf) by Swaroop C H_
			- _search for "en:Scripting"_
		- _[Learning the vi Editor/Vim/VimL Script language](https://en.wikibooks.org/wiki/Learning_the_vi_Editor/Vim/VimL_Script_language)_

* * *

# 3D Math

## [3D_notes1](code/3D_notes1.md)
- covers the following 3D math:
	- matrix math
	- vector math
	- lines w/ points, lines, circles equations
	- planes w/ points, lines, planes equations

<!--
[//] # ( TODO: ## 3D_notes2[](code/3D_notes2.md) )
[//] # ( TODO: - covers the following 3D math:   )
[//] # ( TODO:	- quaternions )
[//] # ( TODO: 	- curves      )
[//] # ( TODO: 	- surfaces    )
-->

* * *

# Misc

- [my bookmarks](https://www.nickshin.com/bookmark_tools/demo/index.html)
- [Git-LFS](code/gitlfs_gitlab.md) _(with GitLab)_
- [rsync](code/rsync_notes.md)
- [sql](code/sql_notes.md)

**external links:**
- _Git:_
	- _[GIT cheat sheet](http://www.rsbac.org/documentation/dev/scm/git#the_cheat_sheet_this_is_where_you_find_all_common_commands)_
	- _[Understanding the GitHub Flow](https://guides.github.com/introduction/flow/)_
	- _[How to Create a shared Git Repository in Debian (ssh, git-daemon, gitweb)](http://linuxclues.blogspot.com/2013/06/git-daemon-ssh-create-repository-debian.html) (onsite repository)_
	- _[Lesser Known Git Commands](https://dzone.com/articles/lesser-known-git-commands)_
	- _[Git Submodules: Core Concept, Workflows, And Tips](https://dzone.com/articles/core-concept-workflows-and-tips)_
	- _[Git Large File Storage](https://git-lfs.github.com/)_
	- _[Git rebase](https://medium.freecodecamp.com/git-rebase-and-the-golden-rule-explained-70715eccc372#.qdpwnk4af)_
	- _[GitKraken Tips](https://blog.axosoft.com/tag/gitkrakentip/)_

- _Cheat Sheets Collections_
	- _[Cheat-Sheets.org](http://www.cheat-sheets.org/)_
	- _[OverAPI.com](http://overapi.com/)_

* * *

## License

[Unlicense](http://unlicense.org/)

* * *

