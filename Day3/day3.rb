require 'minitest/autorun'

# Loads data from file, returns array of lines
class DataLoader
  def self.load(file)
    data = []
    File.open(file).each do |line|
      next if line.chomp.empty?
      data << line.chomp
    end
    data
  end
end

# Convert data from array of lines to 2d array of chars
class DataConverter
  def self.convert(data)
    converted_data = []
    data.each { |d| converted_data << convert_line(d) }
    converted_data
  end

  private

  # Returns array
  def self.convert_line(line)
    line.split('')
  end
end

# Check if a given square has a tree; returns true (tree) or false (open)
class TreeChecker
  def self.check(char)
    char == '#' ? true : false
  end
end

# Actual run the simulation, counting trees hit along the way
class TobogganSimulator
  def self.count(data)
    location_row, location_column = [-1,-3]
    trees_encountered = 0
    puts
    data.each do |line|
      location_row += 1
      break if location_row > data.length
      location_column += 3
      location_column = location_column - line.length if location_column > line.length
      trees_encountered += 1 if TreeChecker.check(line[location_column])
    end
    trees_encountered
  end
end

class DataLoaderTest < Minitest::Test
  def test_parse
    test_file = 'test_input.txt'
    test_data = [
      '..##.......',
      '#...#...#..',
      '.#....#..#.'
    ]
    test_data.each_index do |i|
      actual = DataLoader.load(test_file)
      expected = test_data[i]
      assert_equal(expected, actual[i])
    end
  end
end

class DataConverterTest < Minitest::Test
  def test_convert_line
    line = '..##.......'
    expected = %w[. . # # . . . . . . .]
    converted_line = DataConverter.send(:convert_line,line)
    assert_equal(expected, converted_line)
  end

  def test_convert
    test_data = [
      '..##.......',
      '#...#...#..',
      '.#....#..#.'
    ]
    expected = [
      %w[. . # # . . . . . . .],
      %w[# . . . # . . . # . .],
      %w[. # . . . . # . . # .]
    ]
    actual = DataConverter.convert(test_data)
    assert_equal(expected, actual)
  end
end

class TreeCheckerTest < Minitest::Test
  def test_check_tree
    assert_equal(true, TreeChecker.check('#'))
  end

  def test_check_open_space
    assert_equal(false, TreeChecker.check('.'))
  end
end

class TobogganSimulatorTest < Minitest::Test
  def test_count_trees
    test_data = [
      '..##.......',
      '#...#...#..',
      '.#....#..#.',
      '..#.#...#.#',
      '.#...##..#.',
      '..#.##.....',
      '.#.#.#....#',
      '.#........#',
      '#.##...#...',
      '#...##....#',
      '.#..#...#.#'
    ]
    assert_equal(7, TobogganSimulator.count(test_data))
  end
end