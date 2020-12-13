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
    (contains_all_fields?)
  end

  def contains_all_fields?
    !(self['byr'].nil? || self['iyr'].nil? || self['eyr'].nil? || self['hgt'].nil? || 
      self['hcl'].nil? || self['ecl'].nil? || self['pid'].nil?)# || self['cid'].nil?)
  end
end

# Count how many passports are valid
class ValidPassportCounter
  def self.get_valid_count(data)
    valid_count = 0
    all_passports = DataConverter.convert(data)
    all_passports.each do |this_passport|
      valid_count += 1 if this_passport.valid?
    end
    valid_count
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
    @passport = Passport.new
    @passport_with_missing = Passport.new
    @passport_with_missing.merge!( { 'hcl' => '#ae17e1' })
    full = {'ecl' => 'gry',
    'pid' => '860033327',
    'eyr' => '2020',
    'hcl' => '#fffffd',
    'byr' => '1937',
    'iyr' => '2017',
    'cid' => '147',
    'hgt' =>  '183cm' }
    @passport_with_all = Passport.new
    @passport_with_all.merge!(full)
  end

  def test_valid_when_empty
    assert_equal(false, @passport.valid?)
  end

  def test_valid_when_missing
    assert_equal(false, @passport_with_missing.valid?)
  end

  def test_valid_when_full
    assert_equal(true, @passport_with_all.valid?)
  end

  def test_contains_all_fields_when_blank?
    actual = @passport.send(:contains_all_fields?)
    assert_equal(false, actual)
  end

  def test_contains_all_fields_when_missing?
    actual = @passport_with_missing.send(:contains_all_fields?)
    assert_equal(false, actual)
  end

  def test_contains_all_fields_when_full?
    actual = @passport_with_all.send(:contains_all_fields?)
    assert_equal(true, actual)
  end

  def test_merge
    expected = { 'hcl' => '#ae17e1', 'iyr' => '2013' }
    @passport.merge!({ 'hcl' => '#ae17e1' })
    @passport.merge!({ 'iyr' => '2013' } )
    assert_equal(expected, @passport)
  end
end

class ValidPassportCounterTest < Minitest::Test
  def setup
    @data = DataLoader.load('test_input.txt')
    @all_passports = DataConverter.convert(@data)
  end

  def test_valid_count
    expected = 2
    actual = ValidPassportCounter.get_valid_count(@data)
    assert_equal(expected, actual)
  end
end

data = DataLoader.load('input.txt')

puts ValidPassportCounter.get_valid_count(data)