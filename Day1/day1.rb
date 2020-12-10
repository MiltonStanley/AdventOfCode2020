require 'minitest/autorun'

class DataLoader
	def self.load(file)
		data = []
		File.open(file).each do |number|
			data << number.to_i
		end
		data
	end
end

class Calculator
	def initialize(data, goal_sum)
		@data = data
		@goal_sum = goal_sum
	end

	def calculate
		sum = find_sum
		get_product(sum)
	end

	private

	def find_sum()
		x, y = nil
		@data.each_index do |i|
			a = @data[i]
			@data[i+1..-1].each do |b|
				sum = a + b
				if sum == @goal_sum
					x,y = a,b 
					break
				end		
			end
		end
		[x, y]
	end

	def get_product(summers)
		x, y = summers
		x * y
	end
end

class CalculatorTest < Minitest::Test

	def setup
		@test_data = [1721, 979, 366, 299, 675, 1456]
		@test_goal_sum = 2020
		@test_answer = 514579
		@tester = Calculator.new(@test_data, @test_goal_sum)
	end

	def test_initialize_works
		assert @tester != nil
	end

	def test_find_sum_works
		sum = @tester.send(:find_sum)
		assert_equal([1721, 299], sum)
	end

	def test_get_product_works
		product = @tester.send(:get_product,[2, 4])
		assert_equal(8, product)
	end

	def test_calculate_works
		assert_equal(@test_answer, @tester.calculate)
	end
end

class DataLoaderTest < MiniTest::Test

	def test_load_works
		actual = DataLoader.load('testData.txt')
		expected = [1721, 979, 366, 299, 675, 1456]
		assert_equal(expected, actual)
	end

end


file_name = 'day1Data.txt'
data = DataLoader.load(file_name)
puts Calculator.new(data, 2020).calculate