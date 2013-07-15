#!/usr/bin/env ruby
#encoding: utf-8

require_relative '../lib/vocabulary'

module Vocabulary::CLI
  # Directions of translation are supported.
  #
  direction = [:en, :ru]
  model = Vocabulary::Dataset.new

  # Insert dialog in console.
  #
  def insert
    print("[en]> ")
    en = STDIN.gets.chomp
    print("[ru]> ")
    ru = STDIN.gets.chomp
    model.insert(en, ru)
  end

  # Test user answers for num times.
  #
  def quiz(num, lang1, lang2)
    num.times do
      model.random_pair.map do |pair|
        puts pair[lang1]
        print "> "
        user_answer = STDIN.gets.chomp
        puts pair[lang2] unless pair[lang2] == user_answer
      end
    end
  end

  # Multiple addition to vocabulary.
  #
  def multiadd
    puts 'When you want to stop just type :!'
    current_string = ''

    while not current_string == ':!'
      model.string_processing(current_string)
      print "> "
      current_string = STDIN.gets.chomp
    end
  end

  opts = OptionParser.new do |opts|
    opts.banner = 'Usage: voc [options]'
    messages = { t: 'Translate word in both ways',
                 a: 'Add new words pair',
                 d: 'Choose direction of quiz(en,ru)',
                 q: 'Test your knowledge CNT times',
                 all: 'Prints all vocabulary',
                 m: 'Add many word pairs, separated by " - "',
                 i: 'Import text file to vocabulary',
                 h: 'Show this message' }

    opts.on("-a", "--add", messages[:a]) do
      insert
    end

    opts.on("-t", "--translate WORD", messages[:t]) do |word|
      model.translate(word).map { |r| puts r[:en] + " - " + r[:ru] }
    end

    opts.on("-d", "--direction D", [:en, :ru], messages[:d]) do |d|
      direction = [:ru, :en] if d == :en
      direction = [:en, :ru] if d == :ru
    end

    opts.on("-q", "--quiz CNT", messages[:q]) do |cnt|
      quiz(cnt.to_i, direction.first, direction.last)
    end

    opts.on("--all", messages[:all]) do |v|
      model.all_vocabulary.each_pair do |key, value|
        puts "%-40s %s" % [key, value]
      end
    end

    opts.on("-m", "--multiadd", messages[:m]) do
      multiadd
    end

    opts.on('-i', '--import FILE', messages[:i]) do |file|
      model.import_file(file)
    end

    opts.on_tail("-h", "--help", messages[:h]) do
      puts opts
      exit
    end
  end.parse!
end