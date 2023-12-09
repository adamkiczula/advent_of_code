require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
  SAMPLE
  SAMPLE_ANSWER = 2

  private
  def algorithm(input)
    input.sum do |line|
      numbers = line.split(/\s+/).map(&:to_i)
      previous_number(numbers)
    end
  end

  def previous_number(numbers)
    diffs = []
    numbers.each_with_index do |number, index|
      diffs << numbers[index+1] - number if numbers[index+1]
    end
    prediction = diffs.uniq.size == 1 ? diffs.first : previous_number(diffs)
    numbers.first - prediction
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
