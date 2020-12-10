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

class DataLoaderTest < Minitest::Test
	def test_load_works
		actual = DataLoader.load('day2_test_data.txt')
		expected = [
			'1-3 a: abcde',
			'1-3 b: cdefg',
			'2-9 c: ccccccccc'
		]
		assert_equal(expected, actual)
	end
end