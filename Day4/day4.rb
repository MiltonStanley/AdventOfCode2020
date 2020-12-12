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
    4
  end

  private

  # First, split the line into field pairs
  #   and return array of strings ['key:val', 'key:val'] etc
  def split_into_key_val_pairs(line)
    parts = line.split(' ')
  end
  
  # Then, split the field pairs into key-val hash pairs
  #   and return a hash.
  def compile_line(parts)
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
    assert_equal(4, DataConverter.convert(@data))
  end
end

class PassportTest < Minitest::Test
  def test_valid?
    assert_equal(false, Passport.valid?)
  end
end