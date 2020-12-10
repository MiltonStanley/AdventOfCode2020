require 'minitest/autorun'

# Loads data from file, returns array of lines
class DataLoader
	def self.load(file)
		data = []
		File.open(file).each do |line|
			data << line.chomp
		end
		data
	end
end

# Parses each line of data, returns [rule, password]
class DataLineParser
	def self.parse(line)
		rule, password = line.split(': ')
	end
end

# Parses rule, returns [RANGE, letter]
class RuleParser
	def self.parse(rule)
		count, letter = rule.split(' ')
		[convert_count_to_range(count), letter]
	end

	private

	def self.convert_count_to_range(count)
		start, stop = count.split('-')
		(start.to_i..stop.to_i)
	end
end

# Check a single password, return validity
class PasswordChecker
	def self.check(line)
		rule, password = DataLineParser.parse(line)
		range, letter = RuleParser.parse(rule)
		validity = get_validity(range, letter, password)
	end

	private

	def self.get_validity(range, letter, password)
		count = password.count(letter)
		range.include? count.to_i
	end
end

# Check all the passwords
class PasswordDatabaseChecker
	def initialize(data)
		@data = data
		@valid_passwords = []
	end

	def check_all
		@data.each_index do |i|
			valid = PasswordChecker.check(@data[i])
			@valid_passwords << i if valid
		end
	end

	def get_valid_count
		@valid_passwords.count
	end
end

class DataLoaderTest < Minitest::Test
	def test_load_works
		actual = DataLoader.load('test_data.txt')
		expected = [
			'1-3 a: abcde',
			'1-3 b: cdefg',
			'2-9 c: ccccccccc'
		]
		assert_equal(expected, actual)
	end
end

class DataLineParserTest < Minitest::Test
	def test_parse
		expected = ['1-3 a', 'abcde']
		actual = DataLineParser.parse('1-3 a: abcde')
		assert_equal(expected, actual)
	end
end

class RuleParserTest < Minitest::Test
	def test_parse
		expected = [1..3,'a']
		actual = RuleParser.parse('1-3 a')
		assert_equal(expected, actual)
	end

	def test_convert_count_to_range
		range = RuleParser.send(:convert_count_to_range, '1-3')
		assert_equal(1..3, range)
	end
end

class PasswordCheckerTest < Minitest::Test
	def setup
		@test_data = [
			'1-3 a: abcde',
			'1-3 b: cdefg',
			'2-9 c: ccccccccc'
		]
	end

	def test_get_validity_when_true
		range = 1..3
		letter = 'a'
		password = 'abcde'
		actual = PasswordChecker.send(:get_validity, range, letter, password)
		assert_equal(true, actual)
	end

	def test_get_validity_when_false
		range = 1..3
		letter = 'b'
		password = 'cdefg'
		actual = PasswordChecker.send(:get_validity, range, letter, password)
		assert_equal(false, actual)
	end

	def test_first_line
		actual = PasswordChecker.check(@test_data[0])
		assert_equal(true, actual)
	end	

	def test_second_line
		actual = PasswordChecker.check(@test_data[1])
		assert_equal(false, actual)
	end	

	def test_third_line
		actual = PasswordChecker.check(@test_data[2])
		assert_equal(true, actual)
	end	
end

class PasswordDatabaseCheckerTest < Minitest::Test
	def setup
		data = DataLoader.load('test_data.txt')
		@tester = PasswordDatabaseChecker.new(data)
	end

	def test_initialize
		actual = @tester.instance_variable_get(:@data).class
		assert_equal(Array, actual)
	end

	def test_get_valid_count
		@tester.check_all
		actual = @tester.get_valid_count
		assert_equal(2, actual)
	end
end