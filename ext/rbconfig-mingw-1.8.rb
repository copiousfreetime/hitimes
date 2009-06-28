
# This file was created by mkconfig.rb when ruby was built.  Any
# changes made to this file will be lost the next time ruby is built.

module Config
  RUBY_VERSION == "1.8.6" or
    raise "ruby lib version (1.8.6) doesn't match executable version (#{RUBY_VERSION})"

  TOPDIR = File.dirname(__FILE__).chomp!("/lib/ruby/1.8/i386-mingw32")
  DESTDIR = '' unless defined? DESTDIR
  CONFIG = {}
  CONFIG["DESTDIR"] = DESTDIR
  CONFIG["INSTALL"] = '/opt/local/bin/ginstall -c'
  CONFIG["prefix"] = (TOPDIR || DESTDIR + "#{ENV["HOME"]}/ruby-mingw32")
  CONFIG["EXEEXT"] = ".exe"
  CONFIG["ruby_install_name"] = "ruby"
  CONFIG["RUBY_INSTALL_NAME"] = "ruby"
  CONFIG["RUBY_SO_NAME"] = "msvcrt-ruby18"
  CONFIG["SHELL"] = "/bin/sh"
  CONFIG["PATH_SEPARATOR"] = ":"
  CONFIG["PACKAGE_NAME"] = ""
  CONFIG["PACKAGE_TARNAME"] = ""
  CONFIG["PACKAGE_VERSION"] = ""
  CONFIG["PACKAGE_STRING"] = ""
  CONFIG["PACKAGE_BUGREPORT"] = ""
  CONFIG["exec_prefix"] = "$(prefix)"
  CONFIG["bindir"] = "$(exec_prefix)/bin"
  CONFIG["sbindir"] = "$(exec_prefix)/sbin"
  CONFIG["libexecdir"] = "$(exec_prefix)/libexec"
  CONFIG["datarootdir"] = "$(prefix)/share"
  CONFIG["datadir"] = "$(datarootdir)"
  CONFIG["sysconfdir"] = "$(prefix)/etc"
  CONFIG["sharedstatedir"] = "$(prefix)/com"
  CONFIG["localstatedir"] = "$(prefix)/var"
  CONFIG["includedir"] = "$(prefix)/include"
  CONFIG["oldincludedir"] = "/usr/include"
  CONFIG["docdir"] = "$(datarootdir)/doc/$(PACKAGE)"
  CONFIG["infodir"] = "$(datarootdir)/info"
  CONFIG["htmldir"] = "$(docdir)"
  CONFIG["dvidir"] = "$(docdir)"
  CONFIG["pdfdir"] = "$(docdir)"
  CONFIG["psdir"] = "$(docdir)"
  CONFIG["libdir"] = "$(exec_prefix)/lib"
  CONFIG["localedir"] = "$(datarootdir)/locale"
  CONFIG["mandir"] = "$(datarootdir)/man"
  CONFIG["ECHO_C"] = ""
  CONFIG["ECHO_N"] = "-n"
  CONFIG["ECHO_T"] = ""
  CONFIG["LIBS"] = "-lwsock32 "
  CONFIG["build_alias"] = "i686-darwin9.2.2"
  CONFIG["host_alias"] = "i386-mingw32"
  CONFIG["target_alias"] = "i386-mingw32"
  CONFIG["MAJOR"] = "1"
  CONFIG["MINOR"] = "8"
  CONFIG["TEENY"] = "6"
  CONFIG["build"] = "i686-pc-darwin9.2.2"
  CONFIG["build_cpu"] = "i686"
  CONFIG["build_vendor"] = "pc"
  CONFIG["build_os"] = "darwin9.2.2"
  CONFIG["host"] = "i386-pc-mingw32"
  CONFIG["host_cpu"] = "i386"
  CONFIG["host_vendor"] = "pc"
  CONFIG["host_os"] = "mingw32"
  CONFIG["target"] = "i386-pc-mingw32"
  CONFIG["target_cpu"] = "i386"
  CONFIG["target_vendor"] = "pc"
  CONFIG["target_os"] = "mingw32"
  CONFIG["CC"] = "i386-mingw32-gcc"
  CONFIG["CFLAGS"] = "-g -O2 "
  CONFIG["LDFLAGS"] = "-L. "
  CONFIG["CPPFLAGS"] = ""
  CONFIG["OBJEXT"] = "o"
  CONFIG["CPP"] = "i386-mingw32-gcc -E"
  CONFIG["GREP"] = "/usr/bin/grep"
  CONFIG["EGREP"] = "/usr/bin/grep -E"
  CONFIG["GNU_LD"] = "yes"
  CONFIG["CPPOUTFILE"] = "-o conftest.i"
  CONFIG["OUTFLAG"] = "-o "
  CONFIG["YACC"] = "bison -y"
  CONFIG["YFLAGS"] = ""
  CONFIG["RANLIB"] = "i386-mingw32-ranlib"
  CONFIG["AR"] = "i386-mingw32-ar"
  CONFIG["AS"] = "i386-mingw32-as"
  CONFIG["ASFLAGS"] = ""
  CONFIG["NM"] = "i386-mingw32-nm"
  CONFIG["WINDRES"] = "i386-mingw32-windres"
  CONFIG["DLLWRAP"] = "i386-mingw32-dllwrap"
  CONFIG["OBJDUMP"] = "i386-mingw32-objdump"
  CONFIG["LN_S"] = "ln -s"
  CONFIG["SET_MAKE"] = ""
  CONFIG["INSTALL_PROGRAM"] = "$(INSTALL)"
  CONFIG["INSTALL_SCRIPT"] = "$(INSTALL)"
  CONFIG["INSTALL_DATA"] = "$(INSTALL) -m 644"
  CONFIG["RM"] = "rm -f"
  CONFIG["CP"] = "cp"
  CONFIG["MAKEDIRS"] = "mkdir -p"
  CONFIG["ALLOCA"] = ""
  CONFIG["DLDFLAGS"] = " -Wl,--enable-auto-image-base,--enable-auto-import,--export-all"
  CONFIG["ARCH_FLAG"] = ""
  CONFIG["STATIC"] = ""
  CONFIG["CCDLFLAGS"] = ""
  CONFIG["LDSHARED"] = "i386-mingw32-gcc -shared -s"
  CONFIG["DLEXT"] = "so"
  CONFIG["DLEXT2"] = "dll"
  CONFIG["LIBEXT"] = "a"
  CONFIG["LINK_SO"] = ""
  CONFIG["LIBPATHFLAG"] = " -L\"%s\""
  CONFIG["RPATHFLAG"] = ""
  CONFIG["LIBPATHENV"] = ""
  CONFIG["TRY_LINK"] = ""
  CONFIG["STRIP"] = "strip"
  CONFIG["EXTSTATIC"] = ""
  CONFIG["setup"] = "Setup"
  CONFIG["MINIRUBY"] = "ruby -I#{ENV['HOME']}/pkgs/ruby-1.8.6-p114 -rfake"
  CONFIG["PREP"] = "fake.rb"
  CONFIG["RUNRUBY"] = "$(MINIRUBY) -I`cd $(srcdir)/lib; pwd`"
  CONFIG["EXTOUT"] = ".ext"
  CONFIG["ARCHFILE"] = ""
  CONFIG["RDOCTARGET"] = ""
  CONFIG["XCFLAGS"] = " -DRUBY_EXPORT"
  CONFIG["XLDFLAGS"] = " -Wl,--stack,0x02000000"
  CONFIG["LIBRUBY_LDSHARED"] = "i386-mingw32-gcc -shared -s"
  CONFIG["LIBRUBY_DLDFLAGS"] = " -Wl,--enable-auto-image-base,--enable-auto-import,--export-all -Wl,--out-implib=$(LIBRUBY)"
  CONFIG["rubyw_install_name"] = "rubyw"
  CONFIG["RUBYW_INSTALL_NAME"] = "rubyw"
  CONFIG["LIBRUBY_A"] = "lib$(RUBY_SO_NAME)-static.a"
  CONFIG["LIBRUBY_SO"] = "$(RUBY_SO_NAME).dll"
  CONFIG["LIBRUBY_ALIASES"] = ""
  CONFIG["LIBRUBY"] = "lib$(LIBRUBY_SO).a"
  CONFIG["LIBRUBYARG"] = "$(LIBRUBYARG_SHARED)"
  CONFIG["LIBRUBYARG_STATIC"] = "-l$(RUBY_SO_NAME)-static"
  CONFIG["LIBRUBYARG_SHARED"] = "-l$(RUBY_SO_NAME)"
  CONFIG["SOLIBS"] = "$(LIBS)"
  CONFIG["DLDLIBS"] = ""
  CONFIG["ENABLE_SHARED"] = "yes"
  CONFIG["MAINLIBS"] = ""
  CONFIG["COMMON_LIBS"] = "m"
  CONFIG["COMMON_MACROS"] = ""
  CONFIG["COMMON_HEADERS"] = "windows.h winsock.h"
  CONFIG["EXPORT_PREFIX"] = ""
  CONFIG["MAKEFILES"] = "Makefile GNUmakefile"
  CONFIG["arch"] = "i386-mingw32"
  CONFIG["sitearch"] = "i386-msvcrt"
  CONFIG["sitedir"] = "$(prefix)/lib/ruby/site_ruby"
  CONFIG["configure_args"] = " '--host=i386-mingw32' '--target=i386-mingw32' '--build=i686-darwin9.2.2' '--prefix=#{ENV['HOME']}/ruby-mingw32' 'build_alias=i686-darwin9.2.2' 'host_alias=i386-mingw32' 'target_alias=i386-mingw32'"
  CONFIG["NROFF"] = "/usr/bin/nroff"
  CONFIG["MANTYPE"] = "doc"
  CONFIG["ruby_version"] = "$(MAJOR).$(MINOR)"
  CONFIG["rubylibdir"] = "$(libdir)/ruby/$(ruby_version)"
  CONFIG["archdir"] = "$(rubylibdir)/$(arch)"
  CONFIG["sitelibdir"] = "$(sitedir)/$(ruby_version)"
  CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
  CONFIG["topdir"] = File.dirname(__FILE__)
  MAKEFILE_CONFIG = {}
  CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}
  def Config::expand(val, config = CONFIG)
    val.gsub!(/\$\$|\$\(([^()]+)\)|\$\{([^{}]+)\}/) do |var|
      if !(v = $1 || $2)
	'$'
      elsif key = config[v = v[/\A[^:]+(?=(?::(.*?)=(.*))?\z)/]]
	pat, sub = $1, $2
	config[v] = false
	Config::expand(key, config)
	config[v] = key
	key = key.gsub(/#{Regexp.quote(pat)}(?=\s|\z)/n) {sub} if pat
	key
      else
	var
      end
    end
    val
  end
  CONFIG.each_value do |val|
    Config::expand(val)
  end
end
RbConfig = Config # compatibility for ruby-1.9
CROSS_COMPILING = nil unless defined? CROSS_COMPILING
