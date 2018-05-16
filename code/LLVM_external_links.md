# External Links: LLVMLinux with LLVM, Clang and LLDB

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/>

* * *

The external links list was getting so large, I placed them here.<br>
These are my choice selections - and doubles as my bookmarks for quick reference lookup.

* * *

## LLVMLinux

### [Building the Linux kernel using Clang](http://llvm.linuxfoundation.org/)

- [LLVMLinux: The Linux Kernel with Dragon Wings](http://events.linuxfoundation.org/sites/events/files/slides/2013-LNCA-LLVMLinux.pdf)
	- slide 17: see **Quick Start Guide** below
		- git clone http://git.linuxfoundation.org/llvmlinux.git
		- The framework consists of scripts and patches
		- Automates fetching, patching, and building
			- LLVM, Clang,
			- Toolchains for cross assembler, linker
			- Linux Kernel
			- QEMU, and test images
	- slide 18: see **Project Overview** below
		- patch management: quilt
		- Choice of clang compiler
			- From-source, prebuilt, native
		- Choice of cross-toolchain (as, ld)
			- Codesourcery, Linaro, Android, native
		- $ cd targets/vexpress
		- $ make CLANG_TOOLCHAIN=prebuilt kernel-build
		- $ make CROSS_ARM_TOOLCHAIN=linaro kernel-build
	- slide 19: support for various targets
		- Versatile Express (QEMU testing mainline)
		- X86_64 (mainline)
		- Qualcomm MSM (3.4)
		- Raspberry-pi (3.2 and 3.6)
		- BeagleBone (3.8 in progress)
		- Nexus 7 (3.1.10), Galaxy S3 (3.0.59)
		- Arm64 (mainline in progress)
	- slide 22:
		- The kernel can be compiled with Clang 3.3 (with the LLVMLinux kernel patches)
- [LLVMLinux Project Overview](http://llvm.linuxfoundation.org/index.php/Main_Page)
	- building just the kernel with an existing clang toolchain
- [Quick Start Guide - LLVMLinux](http://llvm.linuxfoundation.org/index.php/Quick_Start_Guide)
	- Automated Build Framework which builds all the Clang/LLVM, the Linux kernel (with appropriate patches) and testing framework (where possible).
<!--
[//] # ( - [git.linuxfoundation.org/llvm-setup.git](http://git.linuxfoundation.org/llvm-setup.git/) )
-->

<!--
[//] # ( "docker"... save for reference...                                                                                   )
[//] # ( ### [BuildBot](http://buildbot.net/)                                                                                )
[//] # ( - All BuildBot docs are found under: Get Started ==&gt; Read the Docs<br>                                           )
[//] # ( 	hmmm ...  seems there's a ...  Dockerfile for buildbot already ...                                               )
[//] # ( 	- [First Buildbot run with Docker](http://docs.buildbot.net/current/tutorial/docker.html)<br>                    )
[//] # ( 		with these updated steps:                                                                                    )
[//] # ( 		- wget https://raw.github.com/buildbot/buildbot/master/master/contrib/Dockerfile                             )
[//] # ( 		- docker build -t buildbot .                                                                                 )
[//] # ( 		- docker run \-\-rm -p 8010:8010 -p 2222:22 buildbot                                                         )
[//] # ( 		- ssh -p 2222 admin@local # password: admin                                                                  )
[//] # ( 	- [Command-line Tool](http://docs.buildbot.net/current/manual/cmdline.html)                                      )
[//] # ( - [How To Add Your Build Configuration To LLVM Buildbot Infrastructure](http://llvm.org/docs/HowToAddABuilder.html) )
-->

<!--
[//] # ( "embedded"... save for reference
[//] # ( ### [BuildRoot](http://buildroot.uclibc.org/)                                                 )
[//] # ( - [The Buildroot user manual](http://buildroot.uclibc.org/downloads/manual/manual.html)       )
[//] # ( 	- Chapter 6. Buildroot configuration                                                       )
[//] # ( 		- 6.1.2. External toolchain backend: crosstool-NG(yes), Yocto(no - not pure toolchain) )
[//] # ( 	- Chapter 8. General Buildroot usage                                                       )
[//] # ( 		- 8.1. make tips                                                                       )
[//] # ( 		- 8.4. Offline builds                                                                  )
[//] # ( 		- 8.8. Graphing the dependencies between packages                                      )
[//] # ( 		- 8.11.5. Package-specific make targets                                                )
[//] # ( 	- Chapter 9. Project-specific customization                                                )
[//] # ( 		- 9.1. Recommended directory structure                                                 )
[//] # ( 		- 9.7. Step-by-step instructions for storing configuration                             )
-->

### Debian

- [LLVM Debian/Ubuntu nightly packages](http://llvm.org/apt/)
- [Build of the Debian archive with clang](http://clang.debian.net/)

- [Debootstrap - create a Debian base system from scratch](http://wiki.debian.org/Debootstrap)

* * *

## LLVM

### The mother of all [LLVM Documentation](http://llvm.org/docs/)

- LLVM Design &amp; Overview
	- [Introduction to the LLVM Compiler](http://llvm.org/pubs/2008-10-04-ACAT-LLVM-Intro.pdf): Presentation providing a users introduction to LLVM
	- [Intro to LLVM](http://www.aosabook.org/en/llvm.html): Book chapter providing a compiler hacker's introduction to LLVM
- User Guides
	- [Getting Started with the LLVM System](http://llvm.org/docs/GettingStarted.html)
	- [LLVM Tutorial: Table of Contents](http://llvm.org/docs/tutorial/index.html)
	- [LLVM Command Guide](http://llvm.org/docs/CommandGuide/index.html): "man" pages for LLVM tools
	- [The LLVM Lexicon](http://llvm.org/docs/Lexicon.html)
- Programming Documentation
	- [Architecture &amp; Platform Information for Compiler Writers](http://llvm.org/docs/CompilerWriterInfo.html)
- Subsystem Documentation
	- [The LLVM Target-Independent Code Generator](http://llvm.org/docs/CodeGenerator.html)
	- [TableGen](http://llvm.org/docs/TableGen/index.html)
	- [TableGen BackEnd](http://llvm.org/docs/TableGen/BackEnds.html)
	- [Source Level Debugging with LLVM](http://llvm.org/docs/SourceLevelDebugging.html)
	- [System Library](http://llvm.org/docs/SystemLibrary.html)
- Development Process Documentation
	- [Creating an LLVM Project](http://llvm.org/docs/Projects.html)

For LLVM programming, every item listed under
[Programming Documentation](http://llvm.org/docs/index.html#programming-documentation) and
[Subsystem Documentation](http://llvm.org/docs/index.html#subsystem-documentation)
are must reads; And the following are also useful:
- User Guides
	- [LLVM's Analysis and Transform Passes](http://llvm.org/docs/Passes.html)
	- [LLVM Testing Infrastructure Guide](http://llvm.org/docs/TestingGuide.html)
	- [YAML I/O](http://llvm.org/docs/YamlIO.html)
	- [The Often Misunderstood GEP Instruction](http://llvm.org/docs/GetElementPtr.html)
- Development Process Documentation
	- [LLVMBuild Guide](http://llvm.org/docs/LLVMBuild.html)
<!--
[//] # ( 	- [LLVM Makefile Guide](http://llvm.org/docs/MakefileGuide.html)            )
[//] # ( 	- [LLVM Developer Policy](http://llvm.org/docs/DeveloperPolicy.html)        )
[//] # ( 	- [How To Validate a New Release](http://llvm.org/docs/ReleaseProcess.html) )
[//] # ( 	- [Advice on Packaging LLVM](http://llvm.org/docs/Packaging.html)           )
-->

### Another excellent resource [LLVM Developers' Meeting](http://llvm.org/devmtg/)

Note: this list would make more sense if read from **bottom** -&gt; **up**
- [Apr 7, 2014](http://llvm.org/devmtg/2014-04/)
	- [Passes in LLVM](http://llvm.org/devmtg/2014-04/PDFs/Talks/Passes.pdf)
	- [Custom Alias-analysis in an LLVM-backed region-based Dynamic Binary Translator](http://llvm.org/devmtg/2014-04/PDFs/Talks/Spink.pdf)
	- [clang-cl: what it is, how it works, and how to use it](http://llvm.org/devmtg/2014-04/PDFs/Talks/clang-cl.pdf) (works with Visual Studio!)
<!--
[//] # ( 	- [LTO: History and work to be done](http://llvm.org/devmtg/2014-04/PDFs/Talks/LTO-slides.pdf)                                  )
[//] # ( 	- [Efficient code generation for weakly ordered architectures](http://llvm.org/devmtg/2014-04/PDFs/Talks/Reinoud-EuroLLVM.pdf)  )
[//] # ( 		<br>interesting memory models:                                                                                              )
[//] # ( 		- atomic read/modify/write                                                                                                  )
[//] # ( 		- compare and exchange                                                                                                      )
[//] # ( 		- atomic qualifiers on load / store                                                                                         )
[//] # ( 	- [Fabric Engine and KL: LLVM for 3D Digital Content Creation](http://llvm.org/devmtg/2014-04/PDFs/Talks/FabricEngine-LLVM.pdf) )
[//] # ( 	- [BEAMJIT: An LLVM based just-in-time compiler for Erlang](http://llvm.org/devmtg/2014-04/PDFs/Talks/drejhammar.pdf)           )
-->

	- **WORKSHOPS !!!**
		- [Refactoring a large C++ codebase using clang](http://llvm.org/devmtg/2014-04/PDFs/Talks/NickRefactoring.pdf)
			- [CODE](http://llvm.org/devmtg/2014-04/PDFs/Talks/Nick-talk.tar.gz)
		- [Building an LLVM Backend](http://llvm.org/devmtg/2014-04/PDFs/Talks/Building%20an%20LLVM%20backend.pdf)
			- [CODE](http://github.com/frasercrmck/llvm-leg)

	- Posters
		- [LLVM AArch64 buildbot](http://llvm.org/devmtg/2014-04/PDFs/Posters/aarch64_buildbot_poster.pdf)
		- [Fast JIT code generation](http://llvm.org/devmtg/2014-04/PDFs/LightningTalks/fast-jit-code-generation.pdf)
			- [tiny-llvm-codegen](http://github.com/mseaborn/tiny-llvm-codegen)
			- [libcpu](https://github.com/libcpu/libcpu)
		- [DBILL: An Efficient and Retargetable Dynamic Binary Instrumentation Framework using LLVM Backend](http://llvm.org/devmtg/2014-04/PDFs/Posters/DBILL_poster.pdf)

- [Nov 6, 2013](http://llvm.org/devmtg/2013-11/)
	- [New Address Sanitizer Features](http://llvm.org/devmtg/2013-11/slides/Serebryany-ASAN.pdf)
	- [Developer Toolchain for the PlayStation®4](http://llvm.org/devmtg/2013-11/slides/Robinson-PS4Toolchain.pdf)
	- [LLDB for your hardware: Remote Debugging the Hexagon DSP](http://llvm.org/devmtg/2013-11/slides/Riley-DebugginWithLLDB.pdf)
<!--
[//] # ( 	- [LLVM Early Days](http://llvm.org/devmtg/2013-11/slides/Lattner-LLVM%20Early%20Days.pdf)                         )
[//] # ( 	<br> if you ever wondered if MSVC's STL, ATL or MFC is the reason your stuff crashes, this might shead some light: )
[//] # ( 	- [Bringing clang and LLVM to Visual C++ users](http://llvm.org/devmtg/2013-11/slides/Kleckner-ClangVisualC++.pdf) )
-->


- [Apr 29, 2013](http://llvm.org/devmtg/2013-04/)
	- [Rebuild of all Debian packages using Clang instead of gcc](http://llvm.org/devmtg/2013-04/ledru-slides.pdf)
<!--
[//] # ( 	- [LLVM on IBM POWER processors: a progress report](http://llvm.org/devmtg/2013-04/weigand-slides.pdf) )
[//] # ( 		- slide 21+ comparison of LLVM vs. GCC backend notes )
-->

	- **WORKSHOPS !!!**
		- [Howto: Implementing LLVM Integrated Assembler](http://www.embecosm.com/appnotes/ean10/ean10-howto-llvmas-1.0.pdf) (good howto)
		- [The Clang AST - a tutorial](http://llvm.org/devmtg/2013-04/klimek-slides.pdf)

		- Posters
		- [Code Editing in Local Style](http://llvm.org/devmtg/2013-04/conn-poster.pdf)

- [Nov 7, 2012](http://llvm.org/devmtg/2012-11/)
	- [Parsing Documentation Comments in Clang](http://llvm.org/devmtg/2012-11/Gribenko_CommentParsing.pdf)
		- [MemorySanitizer, ThreadSanitizer](http://llvm.org/devmtg/2012-11/Serebryany-ASAN-TSAN-Poster.pdf) (WOW)
	- [Building a Checker in 24 hours](http://llvm.org/devmtg/2012-11/Zaks-Rose-Checker24Hours.pdf) (good howto)
<!--
[//] # ( 	- [The AArch64 backend: status and plans ](http://llvm.org/devmtg/2012-11/Northover-AArch64.pdf) )
[//] # ( 	- [Modules](http://llvm.org/devmtg/2012-11/Gregor-Modules.pdf)                                   )
-->


- [Apr 12, 2012](http://llvm.org/devmtg/2012-04-12/)
	- [lld - the LLVM Linker](http://llvm.org/devmtg/2012-04-12/Slides/Michael_Spencer.pdf)
	- [Turning control flow graphs into function call graphs](http://llvm.org/devmtg/2012-04-12/Slides/Pablo_Barrio.pdf)
<!--
[//] # ( 	- [Building Linux with LLVM](http://llvm.org/devmtg/2012-04-12/Slides/Mark_Charlebois.pdf) )
-->
	- **WORKSHOPS !!!**
		- [What LLVM can do for you](http://llvm.org/devmtg/2012-04-12/Slides/Workshops/David_Chisnall.pdf) (good howto)
<!--
[//] # ( 		- [Building a backend in 24 hours](http://llvm.org/devmtg/2012-04-12/Slides/Workshops/Anton_Korobeynikov.pdf) )
-->


- [Nov 18, 2011](http://llvm.org/devmtg/2011-11/)
	- [DXR: Semantic Code Browsing with Clang](http://llvm.org/devmtg/2011-11/Cranmer_DXRSemanticCodeBrowsingwithClang.pdf)
	- [SKIR: Just-in-Time Compilation for Parallelism with LLVM ](http://llvm.org/devmtg/2011-11/Fifield_SKIR.pdf)
	- [Finding races and memory errors with LLVM instrumentation](http://llvm.org/devmtg/2011-11/Serebryany_FindingRacesMemoryErrors.pdf) (WOW)
	- [Thread Safety Annotations in Clang](http://llvm.org/devmtg/2011-11/Hutchins_ThreadSafety.pdf) (WOW)

<!--
[//] # ( - [Sep 16, 2011](http://llvm.org/devmtg/2011-09-16/)                                                                             )
[//] # ( 	- [More Target Independent LLVM Bitcode](http://llvm.org/devmtg/2011-09-16/EuroLLVM2011-MoreTargetIndependentLLVMBitcode.pdf) )
[//] # ( 	- [Jet: A Language and Heterogeneous Compiler for Fluid Simulations](http://llvm.org/devmtg/2011-09-16/EuroLLVM2011-JET.pdf)  )
-->


- [Nov 4, 2010](http://llvm.org/devmtg/2010-11/)
	- [Creating cling, an interactive interpreter interface for clang](http://llvm.org/devmtg/2010-11/Naumann-Cling.pdf)
	- [Hardening LLVM With Random Testing](http://llvm.org/devmtg/2010-11/Yang-HardenLLVM.pdf)
<!--
[//] # ( 	- [Connecting the EDG front-end to LLVM](http://llvm.org/devmtg/2010-11/Golin-EDGToLLVM.pdf)                                                       )
[//] # ( 		- *** slide 10 C++ lowered to C                                                                                                                )
[//] # ( 		- and a lot of other examples of the ARMcc not fully handled properly with clang                                                               )
[//] # ( 	- [Experiences on using LLVM to compile Click packet processing code to Stanford NetFPGA hardware](http://llvm.org/devmtg/2010-11/Rubow-Click.pdf) )
-->


- [Oct 2, 2009](http://llvm.org/devmtg/2009-10/)
	- [Future Works in LLVM Register Allocation](http://llvm.org/devmtg/2009-10/RegisterAllocationFutureWorks.pdf)
<!--
[//] # ( 	- [OpenCL](http://llvm.org/devmtg/2009-10/OpenCLWithLLVM.pdf) )
-->


- [Aug 23, 2008](http://llvm.org/devmtg/2008-08-23/)
	- [py2llvm: Python to LLVM translator](http://llvm.org/devmtg/2008-08-23/py2llvm.pdf)
	- [Binaries are not only output](http://llvm.org/devmtg/2008-08-23/binaries_are_not_only_output.pdf)

- [Aug 1, 2008](http://llvm.org/devmtg/2008-08/)
	- [Building an Efficient JIT](http://llvm.org/devmtg/2008-08/Begeman_EfficientJIT.pdf)
<!--
[//] # ( 	- [Adobe Image Foundation and Adobe PixelBender](http://llvm.org/devmtg/2008-08/Rose_AdobePixelBender.pdf) )
-->


- [May 25, 2007](http://llvm.org/devmtg/2007-05/)
	- [LLVM in OpenGL and for Dynamic Languages](http://llvm.org/devmtg/2007-05/10-Lattner-OpenGL.pdf)

### Interesting Projects

- [The ELLCC Embedded Compiler Collection](http://ellcc.org/) (cross-compiling)
- [Dagger](http://dagger.repzret.org/) (decompiling)

- [LLVM PTX Samples](https://github.com/jholewinski/llvm-ptx-samples) (OpenCL)

* * *

## Clang

### [Clang Documentation](http://clang.llvm.org/docs/index.html)

- Using Clang as a Compiler
	- [Cross-compilation using Clang](http://clang.llvm.org/docs/CrossCompilation.html)
		- Cross Compiling LLVM itself
			- [Building LLVM with CMake](http://llvm.org/docs/CMake.html)
			- [How To Build On ARM](http://llvm.org/docs/HowToBuildOnARM.html)
			- [How To Cross-Compile Clang/LLVM using Clang/LLVM](http://llvm.org/docs/HowToCrossCompileLLVM.html)
- Using Clang as a Library
	- [Choosing the Right Interface for Your Application](http://clang.llvm.org/docs/Tooling.html)
	- [compiler-rt runtime libraries](http://compiler-rt.llvm.org/)
		- [AddressSanitizer](http://clang.llvm.org/docs/AddressSanitizer.html)
		- [ThreadSanitizer](http://clang.llvm.org/docs/ThreadSanitizer.html)
		- [MemorySanitizer](http://clang.llvm.org/docs/MemorySanitizer.html)
	- [External Clang Examples](http://clang.llvm.org/docs/ExternalClangExamples.html) (* * * SUPER * * *)
		- Dirt simple HowTos
			- [ToyClangPlugin](https://github.com/AlexDenisov/ToyClangPlugin)
			- [Tutorial for building tools using LibTooling and LibASTMatchers](http://clang.llvm.org/docs/LibASTMatchersTutorial.html)
- Using Clang Tools
	- [Polly - Polyhedral optimizations for LLVM](http://polly.llvm.org/)
	- [Clang-Format Style Options](http://clang.llvm.org/docs/ClangFormatStyleOptions.html)


### Tips

- [Getting Started: Building and Running Clang](http://clang.llvm.org/get_started.html)
- [Hacking on Clang](http://clang.llvm.org/hacking.html)

- [Clang Static Analyzer: usage](https://clang-analyzer.llvm.org/scan-build.html)
- [Clang Static Analyzer: tutorial](http://web.cs.ucla.edu/~tianyi.zhang/tutorial.html)


### Interesting Projects

- [The Clang Universal Driver Project](http://clang.llvm.org/UniversalDriver.html)

* * *

## LLDB

### [LLDB Architecture](http://lldb.llvm.org/architecture/index.html)

- Use and Extension
	- [Tutorial](http://lldb.llvm.org/tutorial.html)
	- [GDB and LLDB Command Examples](http://lldb.llvm.org/lldb-gdb.html)
	- [Variable Formatting](http://lldb.llvm.org/varformats.html)
	- [Python Reference](http://lldb.llvm.org/python-reference.html)
	- [Python Example](http://lldb.llvm.org/scripting.html)

- Resources
	- [Python API Documentation](http://lldb.llvm.org/python_reference/index.html)
	- [C++ API Documentation](http://lldb.llvm.org/cpp_reference/html/index.html)

* * *

## LLD

### [LLD - The LLVM Linker](http://lld.llvm.org/)

<!--
- Use and Extension
	- [Tutorial](http://lldb.llvm.org/tutorial.html)
	- [GDB and LLDB Command Examples](http://lldb.llvm.org/lldb-gdb.html)
	- [Variable Formatting](http://lldb.llvm.org/varformats.html)
	- [Python Reference](http://lldb.llvm.org/python-reference.html)
	- [Python Example](http://lldb.llvm.org/scripting.html)

- Resources
	- [Python API Documentation](http://lldb.llvm.org/python_reference/index.html)
	- [C++ API Documentation](http://lldb.llvm.org/cpp_reference/html/index.html)
-->

* * *

