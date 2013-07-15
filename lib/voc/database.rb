#encoding: utf-8

class Vocabulary::Dataset
  # Dataset is table with vocabulary itself.
  #
  def initialize
    @dataset = Vocabulary::DB[:voc]
  end

  # Insert word-translation pair to database.
  #
  def insert(en, ru)
    @dataset.insert(en: en, ru: ru) unless (en.empty? || ru.empty?)
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

  # Adding pair of words, separated by ' - ', to database.
  #
  def string_processing(string)
    insert_pair = string.split(' - ')

    if insert_pair.size == 2
      @dataset.insert(en: insert_pair.first, ru: insert_pair.last)
    end
  end

  # Importing file to database.
  #
  def import_file(file)
    records = IO.readlines(file)
    Vocabulary::DB.transaction do
      records.each { |record| string_processing record }
    end
  end
end