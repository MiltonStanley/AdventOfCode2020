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

	def calculate_three
		sum = find_sum_of_three
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
		[x, y].sort
	end

	def find_sum_of_three
		x, y, z = nil
		@data.each_index do |i|
			a = @data[i]
			@data[i+1..-1].each_index do |j|
				b = @data[j]
				@data[j+1..-i].each do |c|
					sum = a + b + c
					if sum == @goal_sum
						x, y, z = a, b, c
						break
					end
				end
			end
		end
		[x, y, z].sort
	end

	def get_product(summers)
		summers.inject(:*)
	end
end

class CalculatorTest < Minitest::Test

	def setup
		@test_data = [1721, 979, 366, 299, 675, 1456]
		@test_goal_sum = 2020
		@test_answer = 514579
		@test_answer_three = 241861950
		@tester = Calculator.new(@test_data, @test_goal_sum)
	end

	def test_initialize_works
		assert @tester != nil
	end

	def test_find_sum_works
		sum = @tester.send(:find_sum)
		assert_equal([1721, 299].sort, sum)
	end

	def test_get_product_works
		product = @tester.send(:get_product,[2, 4])
		assert_equal(8, product)
	end

	def test_calculate_works
		assert_equal(@test_answer, @tester.calculate)
	end

	def test_find_sum_of_three_works
		sum = @tester.send(:find_sum_of_three)
		assert_equal([979, 366, 675].sort, sum)
	end

	def test_calculate_three_works
		assert_equal(@test_answer_three, @tester.calculate_three)
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