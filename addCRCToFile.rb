#!/usr/bin/env ruby
# encoding: UTF-8

##
#	Appends a CRC32 in the given file name
#
#  e.g.:   my.sample.file.mpg -> my.sample.file.[1f2e3d4c].mpg
#
# @author rdoi
# @created 12/2013

require 'zlib'
include Zlib

require 'term/ansicolor'
include Term::ANSIColor

def getCRC(fname)
  puts fname
	f = nil
	File.open(fname, 'rb') { |h| f= h.read } ; nil
	return crc32(f,0).to_s(16)
end

def addCRC(fname)

	if (fname.nil? || !File.exists?(fname))
	  puts "File not found: #{ARGV[0]}"

	else
		crc= getCRC(fname)

		if (fcrc= /[0-9a-fA-F]{8}/.match(fname))
		  if (fcrc[0].downcase == crc)
		    puts "Valid #{crc}: #{fname}".green.bold
		  else
		    puts "INVALID #{crc}: #{fname}".red.bold
		  end

		else

			fext=File.extname(fname)
			fbase=File.basename(fname,fext)
			fpath=File.dirname(fname)
			newName=File.join(fpath,"#{fbase}.[#{crc}]#{fext}")

			puts "#{fname} -> #{newName}" #.blue.bold
			File.rename(fname,newName)
		end
	end

end

if (__FILE__ == $0)
	if (ARGV.length < 1)
	  puts "Appends a CRC32 in the given file name\n\n"
	  puts "e.g:  my.sample.file.mpg -> my.sample.file.[1f2e3d4c].mpg\n\n"
	  puts "Use   #{File.basename(__FILE__,'.rb')} [file]"
		exit
	else
	  addCRC(ARGV[0])
	end
end
