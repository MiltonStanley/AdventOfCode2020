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

class LargestIDFinder
  def self.find(data)
    ids = []
    data.each do |code|
      id = BinaryPartitioner.partition(code)[2]
      ids << id
    end
    ids.max
  end

  def self.return_all_ids(data)
    ids = []
    data.each do |code|
      id = BinaryPartitioner.partition(code)[2]
      ids << id
    end
    ids.sort
  end
end

class BinaryPartitioner
  def self.partition(code)
    row = code[0..6]
    seat = code[7..9]
    row = convert(row)
    seat = convert(seat)
    id = calculate_seat_id([row, seat])
    return [row, seat, id]
  end

  def self.calculate_seat_id(seat)
    seat[0] * 8 + seat[1]
  end

  def self.convert(code)
    binary = convert_code_to_binary(code)
    binary.to_i(2)
  end

  def self.convert_code_to_binary(code)
    binary = code.dup
    binary.gsub!('B', '1')
    binary.gsub!('F', '0')
    binary.gsub!('R', '1')
    binary.gsub!('L', '0')
    binary
  end
end

class MissingSeatFinder
  def self.find(ids, max)
    missing_seat = nil
    (1..max).each do |id|
      next if ids.include? id
      missing_seat = id if neighbors_exist?(id, ids)
    end
    missing_seat
  end

  def self.neighbors_exist?(id, ids)
    (ids.include?(id-1) && ids.include?(id+1))
  end
end

class DataloaderTest < Minitest::Test
  def setup
    @test_file = 'test_input.txt'
  end

  def test_load_works
    assert_equal(3, DataLoader.load(@test_file).length)
  end
end

class BinaryPartitionerTest < Minitest::Test
  def test_inputs
    {
      'BFFFBBFRRR' => [70, 7, 567],
      'FFFBBBFRRR' => [14, 7, 119],
      'BBFFBBFRLL' => [102, 4, 820]
    }.each do |code, expected|
      actual = BinaryPartitioner.partition(code)
      assert_equal(expected,actual)
    end
  end

  def test_calculate_seat_id
    expected = 357
    seat_array = [44, 5]
    actual = BinaryPartitioner.send(:calculate_seat_id, seat_array)
    assert_equal(expected, actual)
  end

  def test_convert
    {
      'FBFBBFF' => 44,
      'RLR' => 5
    }.each do |code, expected|
      actual = BinaryPartitioner.send(:convert, code)
      assert_equal(expected, actual)
    end
  end

  def test_convert_code_to_binary
    {
      'FBFBBFF' => '0101100',
      'RLR' => '101'
    }.each do |code, expected|
      actual = BinaryPartitioner.send(:convert_code_to_binary, code)
      assert_equal(expected, actual)
    end
  end
end

class LargestIDFinderTest <Minitest::Test
  def test_find_highest_id
    data = DataLoader.load('test_input.txt')
    actual = LargestIDFinder.find(data)
    expected = 820
    assert_equal(expected, actual)
  end

  def test_return_alL_ids
    data = DataLoader.load('test_input.txt')
    actual = LargestIDFinder.return_all_ids(data)
    expected = [119, 567, 820]
    assert_equal(expected, actual)
  end
end

class MissingSeatFinderTest < Minitest::Test
  def setup
    @ids = [3, 4, 5, 6, 7, 8, 9, 10, 12]
  end

  def test_find_missing_seat
    id = MissingSeatFinder.find(@ids, 12)
    assert_equal(11, id)
  end

  def test_neighbors_exist?
    {
      4 => true,
      10 => false,
      11 => true,
      12 => false
    }.each do |id, expected|
      actual = MissingSeatFinder.send(:neighbors_exist?, id, @ids)
      assert_equal(expected, actual)
    end
  end
end

data = DataLoader.load('input.txt')

puts LargestIDFinder.find(data)

max = LargestIDFinder.find(data)
seats = LargestIDFinder.return_all_ids(data)

puts MissingSeatFinder.find(seats, max)