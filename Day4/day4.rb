require 'minitest/autorun'

class DataLoader
  def self.load(file)
    data = []
    File.open(file).each do |line|
      data << line.chomp
    end
    data
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

class PassportTest < Minitest::Test
  def test_valid?
    assert_equal(false, Passport.valid?)
  end
end