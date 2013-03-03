require 'test/unit'

class MyUnitTests < Test::Unit::TestCase

  def setup
    puts "setup!"
  end

  def teardown
    puts "Teardown!"
  end

  def test_basic
    puts "I RAN!"
  end

end
