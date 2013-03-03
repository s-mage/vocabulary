#!/usr/bin/env ruby
#encoding: utf-8

require 'sequel'
require 'optparse'

module Vocabulary
  # File, where vocabulary is.
  #
  DBFILE = File.expand_path('../../bin/vocabulary.db', __FILE__)

  # Adapter to vocabulary.
  #
  DB = Sequel.sqlite(DBFILE)
end

require_relative 'voc/database'
require_relative 'voc/options'