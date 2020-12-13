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
    total_passport_count = 0
    passports[total_passport_count] = Passport.new
    data.each do |line|
      if line.strip.empty?
        total_passport_count += 1
        passports[total_passport_count] = Passport.new
        next
      end
      compile_line = compile_line(split_into_fields(line))

      passports[total_passport_count].merge!(compile_line)
    end
    passports
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
  def valid?
    !(self['byr'].nil? || self['iyr'].nil? || self['eyr'].nil? || self['hgt'].nil? || 
      self['hcl'].nil? || self['ecl'].nil? || self['pid'].nil?)# || self['cid'].nil?)
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
    assert_equal(4, DataConverter.convert(@data).length)
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

  def test_convert
    expected = '#ae17e1'
    passports = DataConverter.convert(@data)
    actual = passports[2]['hcl']
    assert_equal(expected, actual)
  end
end

class PassportTest < Minitest::Test
  def setup
    @data = DataLoader.load('test_input.txt')
    @all_passports = DataConverter.convert(@data)
    @passport = Passport.new
  end

  def test_valid?
    assert_equal(false, @passport.valid?)
  end

  def test_merge
    expected = { 'hcl' => '#ae17e1', 'iyr' => '2013' }
    @passport.merge!({ 'hcl' => '#ae17e1' })
    @passport.merge!({ 'iyr' => '2013' } )
    assert_equal(expected, @passport)
  end

  def test_valid_count
    valid_count = 0
    @all_passports.each do |this_passport|
      valid_count += 1 if this_passport.valid?
    end
    assert_equal(2, valid_count)
  end
end