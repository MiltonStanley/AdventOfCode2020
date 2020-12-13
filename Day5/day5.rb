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

class BinaryPartitioner
  def self.partition(code)
    row = code[0..6]
    seat = code[7..9]
    #row = convert(row)
    #seat = convert(seat)
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
    #  assert_equal(expected,actual)
    end
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