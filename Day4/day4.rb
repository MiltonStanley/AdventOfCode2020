require 'minitest/autorun'

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

class PassportTest < Minitest::Test
  def test_valid?
    assert_equal(false, Passport.valid?)
  end
end