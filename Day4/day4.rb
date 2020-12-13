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

# Takes DataLoader.data as input; outputs an array of passports
class DataConverter
  def self.convert(data)
    passports = []
    passport_count = 0
  end

  private

  # First, split the line into field pairs
  #   and return array of strings ['key:val', 'key:val'] etc
  def self.split_into_fields(line)
    parts = line.split(' ')
  end
  
  # Then, split the array of fields into key-val hash pairs
  #   and return a hash. 
  def self.compile_line(parts)
    line_hash = {}
    parts.each do |pair|
      pair = convert_array_pair_to_key_val(pair)
      line_hash.merge!(pair)
    end
    line_hash
  end

  # Convert 'key:val' to { 'key' => 'val' }
  def self.convert_array_pair_to_key_val(pair)
    key, val = pair.split(':')
    { key => val }
  end
end

# Passport info holder
class Passport < Hash

  def initialize(*args)
    @byr = args[:byr]
    @iyr = args[:iyr]
    @eyr = args[:eyr]
    @hgt = args[:hgt]
    @hcl = args[:hcl]
    @ecl = args[:ecl]
    @pid = args[:pid]
    @cid = args[:cid]
  end

  def self.valid?
    !(@byr.nil? && @iyr.nil? && @eyr.nil? && @hgt.nil? && @hcl.nil? && @ecl.nil? && @pid.nil? && @cid.nil?)
  end
end

### TESTS ###

class DataloaderTest < Minitest::Test
  def setup
    @test_file = 'test_input.txt'
  end

  def test_load_works
    assert_equal(13, DataLoader.load(@test_file).length)
  end
end

class DataConverterTest < Minitest::Test
  def setup
    @data = DataLoader.load('test_input.txt')
  end

  def test_has_correct_number_of_passports
    #assert_equal(4, DataConverter.convert(@data))
  end

  def test_split_into_pairs_1
    line = 'hcl:#ae17e1 iyr:2013'
    expected = %w[hcl:#ae17e1 iyr:2013]
    actual = DataConverter.send(:split_into_fields, line)
    assert_equal(expected, actual)
  end

  def test_split_into_pairs_2 
    line = 'iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884'
    expected = %w[iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884]
    actual = DataConverter.send(:split_into_fields, line)
    assert_equal(expected, actual)
  end

  def test_split_into_pairs_3
    line = 'eyr:2024'
    expected = %w[eyr:2024]
    actual = DataConverter.send(:split_into_fields, line)
    assert_equal(expected, actual)
  end

  def test_compile_line_1
    line = %w[hcl:#ae17e1 iyr:2013]
    expected = { 'hcl' => '#ae17e1', 'iyr' => '2013' }
    actual = DataConverter.send(:compile_line, line)
    assert_equal(expected, actual)
  end

  def test_compile_line_2
    line = %w[iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884]
    expected = { 'iyr' => '2013', 'ecl' => 'amb', 'cid' => '350', 'eyr' => '2023', 'pid' => '028048884' }
    actual = DataConverter.send(:compile_line, line)
    assert_equal(expected, actual)
  end

  def test_compile_line_3
    line = %w[eyr:2024]
    expected = { 'eyr' => '2024' }
    actual = DataConverter.send(:compile_line, line)
    assert_equal(expected, actual)
  end

  def test_convert_array_pair_to_key_val
    pair = 'hcl:#ae17e1'
    expected = { 'hcl' => '#ae17e1' }
    actual = DataConverter.send(:convert_array_pair_to_key_val, pair)
    assert_equal(expected, actual)
  end
end

class PassportTest < Minitest::Test
  def test_valid?
    assert_equal(false, Passport.valid?)
  end
end