require 'minitest/autorun'

# Loads data as lines; keeps blank lines; returns array
class DataLoader
  def self.load(file)
    data = []
    File.open(file).each do |line|
      data << line.chomp
    end
    data
  end
end

# Takes DataLoader.data as input; outputs an array of group answers
class DataConverter
  def self.convert(data)
    group_answers = []
    total_group_count = 0
    group_answers[total_group_count] = []
    data.each do |line|
      if line.strip.empty?
        total_group_count += 1
        group_answers[total_group_count] = []
        next
      end
      answers = split_line_into_answers(line)
    end
    group_answers
  end

  private

  # First, split the line into individual answers into an array
  def self.split_line_into_answers(line)
    line.split('')
  end

  # Then, combine those with all the other answers
  def self.combine_with_other_group_answers
  end

  # Finally, clean up data by dropping duplicates
  def self.clean_up_duplicates
  end
end
### TESTS ###

class DataConverterTest < Minitest::Test
  def setup
    @data = DataLoader.load('test_input.txt')
  end

  def test_split_line_into_answers
    {
      'abc' => %w[a b c],
      'ab' => %w[a b],
      'a' => %w[a],
    }.each do |line, expected|
      actual = DataConverter.send(:split_line_into_answers, line)
      assert_equal(expected, actual)
    end
  end

  def test_has_correct_number_of_groups
    assert_equal(5, DataConverter.convert(@data).length)
  end
end

class DataloaderTest < Minitest::Test
  def setup
    @test_file = 'test_input.txt'
  end

  def test_load_works
    assert_equal(15, DataLoader.load(@test_file).length)
  end
end
