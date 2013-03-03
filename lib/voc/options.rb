#encoding: utf-8

module Vocabulary::Options
  # Directions of translation are supported.
  #
  direction = [:en, :ru]

  opts = OptionParser.new do |opts|
    opts.banner = 'Usage: voc [options]'
    messages = { t: 'Translate word in both ways',
                 a: 'Add new words pair',
                 d: 'Choose direction of quiz(en,ru)',
                 q: 'Test your knowledge CNT times',
                 all: 'Prints all vocabulary',
                 m: 'Add many word pairs, separated by " - "',
                 h: 'Show this message' }

    dataset = Vocabulary::Dataset.new


    opts.on("-a", "--add", messages[:a]) do
      dataset.insert
    end

    opts.on("-t", "--translate WORD", messages[:t]) do |word|
      dataset.translate(word).map { |r| puts r[:en] + " - " + r[:ru] }
    end

    opts.on("-d", "--direction D", [:en, :ru], messages[:d]) do |d|
      direction = [:ru, :en] if d == :en
      direction = [:en, :ru] if d == :ru
    end

    opts.on("-q", "--quiz CNT", messages[:q]) do |cnt|
      dataset.quiz(cnt.to_i, direction.first, direction.last)
    end

    opts.on("--all", messages[:all]) do |v|
      dataset.all_vocabulary.each_pair do |key, value|
        puts "%-40s %s" % [key, value]
      end
    end

    opts.on("-m", "--multiadd", messages[:m]) do
      dataset.multiadd
    end

    opts.on_tail("-h", "--help", messages[:h]) do
      puts opts
      exit
    end
  end.parse!
end