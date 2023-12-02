require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_ANSWER = 281
  SAMPLE_INPUT = <<~SAMPLE
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
  SAMPLE
  STRING_TO_DIGIT = {
    'one' => '1',
    'two' => '2',
    'three' => '3',
    'four' => '4',
    'five' => '5',
    'six' => '6',
    'seven' => '7',
    'eight' => '8',
    'nine' => '9'
  }.freeze

  private
  def algorithm(input)
    input.sum do |l|
      first = first_digit(l)
      last = last_digit(l)
      "#{first}#{last}".to_i
    end
  end

  def extract_digit(s)
    STRING_TO_DIGIT.fetch(s, s)
  end

  def first_digit(line)
    extract_digit(line.scan(/\d|one|two|three|four|five|six|seven|eight|nine/).first)
  end

  def last_digit(line)
    # if it's dumb and it works, is it really dumb?
    reverse_line = line.reverse
    match = reverse_line.scan(/\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/).first
    extract_digit(match.reverse)
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
