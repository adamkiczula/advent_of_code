require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
  SAMPLE
  SAMPLE_ANSWER = 142

  private
  def algorithm(input)
    input.sum do |l|
      digits = l.scan(/\d/)
      "#{digits.first}#{digits.last}".to_i
    end
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
