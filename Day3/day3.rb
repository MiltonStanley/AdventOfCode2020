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

# Check if a given square has a tree; returns true (tree) or false (open)
class TreeChecker
  def self.check(char)
    char == '#' ? true : false
  end
end

# New, simple simulator
class TobogganSimulator
  def self.count(data, *update)
    right_increment = 3 || update[:right_increment]
    down_increment = 1 || update[:down_increment]
    column = 0 - right_increment
    row = 0 - down_increment

    tree_count = 0

    data.each do |line|
      column += right_increment
      row += down_increment
      mod_row = row % down_increment
      next if mod_row != 0
      mod_column = column % line.length
      tree_count += 1 if TreeChecker.check(line[mod_column])
    end
    tree_count
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

class TreeCheckerTest < Minitest::Test
  def test_check_tree
    assert_equal(true, TreeChecker.check('#'))
  end

  def test_check_open_space
    assert_equal(false, TreeChecker.check('.'))
  end
end

class TobogganSimulatorTest < Minitest::Test

  def setup
    @test_data = [
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
  end

  def test_count_trees
    assert_equal(7, TobogganSimulator.count(@test_data))
  end

  def test_count_trees_updated
    assert_equal(7, TobogganSimulator.count(@test_data, [3,1]))
  end
end


data = DataLoader.load('input.txt')

puts TobogganSimulator.count(data)