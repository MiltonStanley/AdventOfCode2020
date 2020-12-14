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
  def self.convert(data, part2=false)
    group_answers = []
    total_group_count = 0
    group_answers[total_group_count] = []
    data.each do |line|
      if line.strip.empty?

        total_group_count += 1
        group_answers[total_group_count] = []
        next
      end
      answers_array = split_line_into_answers(line)
      unless part2
        combine_with_other_group_answers(group_answers[total_group_count], answers_array)
        group_answers[total_group_count] = clean_up_duplicates(group_answers[total_group_count])
      end
      if part2
        group_answers[total_group_count] = build_group(group_answers[total_group_count], answers_array)
      end
      # if part2
      #   part2_combine_ans(group_answers[total_group_count], answers_array)
      #   break
      # end
    end
    group_answers
  end

  private

  def self.group_finalizer(group)
    group.inject(:&).flatten
  end

  def self.build_group(group, single)
    group << single
    group
  end

  # First, split the line into individual answers into an array
  def self.split_line_into_answers(line)
    line.split('')
  end

  # Then, combine those with all the other answers
  def self.combine_with_other_group_answers(group, this)
    group.concat(this)
  end

  # Finally, clean up data by dropping duplicates
  def self.clean_up_duplicates(group)
    group.uniq
  end
end

# Sums the answers for all groups
class GroupCountSummer
  def self.sum(group_answers)
    sum = 0
    group_answers.each { |g| sum += g.length }
    sum
  end
end

### TESTS ###

class GroupCountSummerTest < Minitest::Test
  def test_sum
    data = DataLoader.load('test_input.txt')
    groups = DataConverter.convert(data)
    actual = GroupCountSummer.sum(groups)
    expected = 11
    assert_equal(expected, actual)
  end
end

class DataConverterTest < Minitest::Test
  def setup
    @data = DataLoader.load('test_input.txt')
  end

  def test_clean_up_duplicates
    group = %w[a b c c d e f]
    expected = %w[a b c d e f]
    actual = DataConverter.send(:clean_up_duplicates, group)
    assert_equal(expected, actual)
  end

  def test_combine_with_other_group_answers
    group = %w[a b c]
    this = %w[x y z]
    expected = %w[a b c x y z]
    actual = DataConverter.send(:combine_with_other_group_answers, group, this)
    assert_equal(expected, actual)
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

  def test_has_right_answers_per_group_part1
    answers = [3, 3, 3, 1, 1]
    answers.each_index do |i|
      groups = DataConverter.convert(@data)
      expected = answers[i]
      actual = groups[i].length
      assert_equal(expected, actual)
    end
  end

  def test_part2_group_finalizer
    group = [[["a"], ["b"], ["c"]]]
    expected = %w[a b c]
    actual = DataConverter.send(:group_finalizer, group)
    assert_equal(expected, actual)
  end

  def test_build_group_part2_group0
    expected = [%w[a b c]]
    line = %w[a b c]
    actual = DataConverter.send(:build_group, [], line)
    assert_equal(expected, actual)
  end

  def test_build_group_part2_group1
    expected = [['a'], ['b'], ['c']]
    lines = [['a'], ['b'], ['c']]
    actual = []
    lines.each { |line| actual = DataConverter.send(:build_group, actual, line) }
    assert_equal(expected, actual)
  end

  def test_build_group_part2_group2
    expected = [['a', 'b'], ['a', 'c']]
    lines = [['a', 'b'], ['a', 'c']]
    actual = []
    lines.each { |line| actual = DataConverter.send(:build_group, actual, line) }
    assert_equal(expected, actual)
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

data = DataLoader.load('input.txt')
groups = DataConverter.convert(data)
puts GroupCountSummer.sum(groups)