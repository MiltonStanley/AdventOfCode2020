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

# Parses each line of data, returns [rule, password]
class DataLineParser
	def self.parse(line)
		rule, password = line.split(': ')
	end
end

# Parses rule, returns [RANGE, letter]
# IF parse includes optional 2nd var true, return [array, letter]
#    array is 2 values
class RuleParser
	def self.parse(rule, updated=false)
		count, letter = rule.split(' ')
		return [convert_count_to_index(count), letter] if updated
		return [convert_count_to_range(count), letter] unless updated
	end

	private

	def self.convert_count_to_range(count)
		start, stop = count.split('-')
		(start.to_i..stop.to_i)
	end

	def self.convert_count_to_index(count)
		count.split('-').map(&:to_i)
	end
end

# Check a single password, return validity
class PasswordChecker
	def self.check(line, updated=false)
		rule, password = DataLineParser.parse(line)
		range, letter = RuleParser.parse(rule, updated)
		validity = valid?(range, letter, password) unless updated
		validity = updated_valid?(range, letter, password) if updated
		return validity
	end

	private

	def self.valid?(range, letter, password)
		count = password.count(letter)
		range.include? count.to_i
	end

	def self.updated_valid?(arry, letter, password)
		good_positions = 0
		arry.each { |i| good_positions += 1 if password[i-1] == letter }
		good_positions == 1 ? true : false
	end
end

# Check all the passwords
class PasswordDatabaseChecker
	def initialize(data, updated=false)
		@data = data
		@valid_passwords = []
		@updated = updated
		check_all
	end

	def check_all
		@data.each_index do |i|
			valid = PasswordChecker.check(@data[i], @updated)
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

	def test_parse_updated
		expected = [[1,3], 'a']
		actual = RuleParser.parse('1-3 a', true)
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

	def test_valid_when_true
		range = 1..3
		letter = 'a'
		password = 'abcde'
		actual = PasswordChecker.send(:valid?, range, letter, password)
		assert_equal(true, actual)
	end

	def test_valid_when_false
		range = 1..3
		letter = 'b'
		password = 'cdefg'
		actual = PasswordChecker.send(:valid?, range, letter, password)
		assert_equal(false, actual)
	end

	def test_valid_when_true_updated
		arry = [1, 3]
		letter = 'a'
		password = 'abcde'
		actual = PasswordChecker.send(:updated_valid?, arry, letter, password)
		assert_equal(true, actual)
	end

	def test_valid_when_too_few_updated
		arry = [1, 3]
		letter = 'b'
		password = 'cdefg'
		actual = PasswordChecker.send(:updated_valid?, arry, letter, password)
		assert_equal(false, actual)
	end

	def test_valid_when_too_many_updated
		arry = [2, 9]
		letter = 'c'
		password = 'ccccccccc'
		actual = PasswordChecker.send(:updated_valid?, arry, letter, password)
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
		@tester_updated = PasswordDatabaseChecker.new(data, true)
	end

	def test_initialize
		actual = @tester.instance_variable_get(:@data).class
		assert_equal(Array, actual)
	end

	def test_get_valid_count
		actual = @tester.get_valid_count
		assert_equal(2, actual)
	end

	def test_get_valid_count_updated
		actual = @tester_updated.get_valid_count
		assert_equal(1, actual)
	end
end

data = DataLoader.load('input.txt')

puts PasswordDatabaseChecker.new(data).get_valid_count
puts PasswordDatabaseChecker.new(data, true).get_valid_count
puts