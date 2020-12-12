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
  def self.count(data, update={}) 
    right_increment = update[:right_increment] || 3
    down_increment = update[:down_increment] || 1
    column = 0 - right_increment
    row = 0 - down_increment

    tree_count = 0

    data.each do |line|
      column += right_increment
      row += 1
      mod_row = row % down_increment
      mod_column = column % line.length
      tree_count += 1 if TreeChecker.check(line[mod_column])
    end
    tree_count
  end

  def self.multiply_count(data, traversals)
    total = []
    traversals.each { |update| total << self.count(data, update) }
    total.inject(&:*)
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

  def test_count_trees_updated_1
    update = {:right_increment => 1, :down_increment => 1}
    assert_equal(2, TobogganSimulator.count(@test_data, update))
  end

  def test_count_trees_updated_2
    update = {:right_increment => 3, :down_increment => 1}
    assert_equal(7, TobogganSimulator.count(@test_data, update))
  end

  def test_count_trees_updated_3
    update = {:right_increment => 5, :down_increment => 1}
    assert_equal(3, TobogganSimulator.count(@test_data, update))
  end

  def test_count_trees_updated_4
    update = {:right_increment => 7, :down_increment => 1}
    assert_equal(4, TobogganSimulator.count(@test_data, update))
  end

  def test_count_trees_updated_5
    update = {:right_increment => 1, :down_increment => 2}
    assert_equal(2, TobogganSimulator.count(@test_data, update))
  end

  def test_count_multiplier
    test_traversals = [
      {:right_increment => 1, :down_increment => 1},
      {:right_increment => 3, :down_increment => 1},
      {:right_increment => 5, :down_increment => 1},
      {:right_increment => 7, :down_increment => 1},
      {:right_increment => 1, :down_increment => 2}
    ]
    #assert_equal(336, TobogganSimulator.multiply_count(@test_data,test_traversals))
  end
end


data = DataLoader.load('input.txt')

puts TobogganSimulator.count(data)

all_traversals = [
  {:right_increment => 1, :down_increment => 1},
  {:right_increment => 3, :down_increment => 1},
  {:right_increment => 5, :down_increment => 1},
  {:right_increment => 7, :down_increment => 1},
  {:right_increment => 1, :down_increment => 2}
]
#puts TobogganSimulator.multiply_count(data, all_traversals)
