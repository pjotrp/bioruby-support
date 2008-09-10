#!/usr/bin/env ruby

# Copyright 2007-2008 Clinton Forbes and Pjotr Prins

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/.

# Original script by Clinton Forbes and was inspired by Pythons doctest
# feature - BioRuby adapted edition by Pjotr Prins
#
# Doctests have can be pasted from the bioruby shell and have the format
#
#   bioruby> seq = Bio::Sequence::NA.new("atgcatgcaaaa")
#   ==> "atgcatgcaaaa"
#
#   # complemental sequence (Bio::Sequence::NA object)
#   bioruby> seq.complement
#   ==> "ttttgcatgcat"
#
# See doc/Tutorial.rd for more examples.
#
# Notes: one global variable '$verbose' is defined for output and can
# be shared by called code (maybe this will change in the future)

$: << '/home/wrk/izip/cvs/opensource/bioruby/lib/'

begin
  require 'rubygems'
  gem 'bio', '>= 1.1.0'
rescue LoadError
  require 'bio'
end

def vprint s
  print s if $verbose
end

# When running tests, addresses of objects are never likely 
# to be the same, so we wipe them out so tests don't fail
def normalize_result(input)
  input.gsub(/:0x([a-f0-9]){8}/, ':0xXXXXXXXX')
end

def run_doc_tests(doc_test)
  execution_context = Kernel.binding()
  statement = ''
  asserts = 0
  succeeded = 0

  # code regexp caters for standard IRB prompt and Rails script/console
  # prompt.
  code_regex = Regexp.new(/^\s*(>>|bioruby>|irb.*?>) (.*)/)
  result_regex = Regexp.new(/^(  =:?)?=> (.*)/)

  doc_test.split("\n").each do |line|
    if code_regex =~ line
      statement << code_regex.match(line)[2] << "\n"
    elsif result_regex =~ line
      expected_result = normalize_result(result_regex.match(line)[2])
      print statement if $verbose
      result = normalize_result(eval(statement, execution_context).inspect)
      if result != expected_result
        print "FAILED\n" #add line number logic here
        print "Code:\n" << statement
        print "Expected: " << expected_result
        print "But got: " << result
        return asserts, succeeded, false
      end
      asserts += 1
      succeeded += 1

      statement = ''
    end
  end

  return asserts, succeeded, true
end

def process_ruby_files(file_name)
  asserts, asserts_succeeded = 0 , 0
  tests, succeeded = 0, 0
  code = File.read(file_name)
  file_name_printed = false
  code.scan(/=begin\s#doctest ([^\n]*)\n(.*?)=end/m) do |doc_test|
    if ! file_name_printed
      vprint "Processing '#{file_name}'"
      file_name_printed = true
    end
    vprint "Testing '#{doc_test[0]}'..." 
    (asserts, asserts_succeeded, passed) = run_doc_tests(doc_test[1])
    vprint "OK\n" if passed and $verbose
    tests += 1
    succeeded += 1 if passed
  end

  return asserts, asserts_succeeded, tests, succeeded
end

if ARGV.size == 0
  print "Usage: doctest.rb [-v] source(s)\n"
  exit 1
end

$verbose = false

if ARGV[0] == '-v'
  $verbose = true
  ARGV.shift
end

ruby_file_names = ARGV

vprint "Looking for doctests in #{ruby_file_names.length} files\n"
assert_tests, asserts_succeeded = 0, 0 
total_tests, total_succeeded = 0, 0
ruby_file_names.each do |ruby_file_name|
  (asserts, asserts_succeeded, tests, succeeded) = process_ruby_files ruby_file_name
  assert_tests += asserts
  asserts_succeeded += asserts_succeeded
  total_tests += tests
  total_succeeded += succeeded
end
printf "Total assertions: %4d, Succeeded: %4d\n",assert_tests, asserts_succeeded
printf "Total tests:      %4d, Succeeded: %4d\n",total_tests, total_succeeded

