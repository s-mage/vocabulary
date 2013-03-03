#encoding: utf-8

class Vocabulary::Dataset
  # Dataset is table with vocabulary itself.
  #
  def initialize
    @dataset = Vocabulary::DB[:voc]
  end

  # Insert dialog in console.
  #
  def insert
    print("[en]> ")
    en = STDIN.gets.chomp
    print("[ru]> ")
    ru = STDIN.gets.chomp
    @dataset.insert(en: en, ru: ru) unless en.empty? || ru.empty?
  end

  # Create hash with all vocabulary from table dataset.
  #
  def all_vocabulary
    @dataset.select(:en, :ru).inject({}) do |hash, pair|
      hash.merge pair[:en] => pair[:ru]
    end
  end

  # Translate word with table dataset.
  #
  def translate(word)
    @dataset.select(:en, :ru).where(en: word).or(ru: word)
  end

  # Generate random pair from the dataset.
  #
  def random_pair
    cnt = @dataset.map { |r| r[:id] }
    rand_id = cnt[rand(0...cnt.size)]
    @dataset.select(:en, :ru).where(id: rand_id)
  end

  # Test user answers for num times.
  #
  def quiz(num, lang1, lang2)
    num.times do
      random_pair.map do |pair|
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
      insert_pair = current_string.split(' - ')

      if insert_pair.size == 2
        @dataset.insert(en: insert_pair.first, ru: insert_pair.last)
      end

      print "> "
      current_string = STDIN.gets.chomp
    end
  end
end
