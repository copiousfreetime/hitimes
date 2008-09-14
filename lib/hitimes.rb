#--
# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

module Hitimes
  #   
  # returns:: [String] The full expanded path of the parent directory of 'lib'
  #           going up the path from the current file.  Trailing
  #           File::SEPARATOR is guaranteed.
  #   
  def self.root_dir
    unless @root_dir
      path_parts = ::File.expand_path(__FILE__).split(::File::SEPARATOR)
      lib_index  = path_parts.rindex("lib")
      @root_dir = path_parts[0...lib_index].join(::File::SEPARATOR) + ::File::SEPARATOR
    end 
    return @root_dir
  end 

  # returns:: [String] The full expanded path of the +lib+ directory below
  #           _root_dir_.  All parameters passed in are joined onto the 
  #           result. Trailing File::SEPARATOR is guaranteed if 
  #           _*args_ are *not* present.
  #   
  def self.lib_path(*args)
    self.sub_path("lib", *args)
  end 

  def self.sub_path(sub,*args)
    sp = ::File.join(root_dir, sub) + File::SEPARATOR
    sp = ::File.join(sp, *args) if args
  end

end
require 'hitimes/version'
require 'hitimes/timer'
