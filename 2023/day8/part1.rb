require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
  SAMPLE
  SAMPLE_ANSWER = 6

  private
  def algorithm(input)
    steps = input.shift.chomp.split('')
    map = input.each_with_object({}) do |line, hash|
      next if line.chomp.empty?
      key, left, right = line.scan(/\w+/)
      hash[key] = { 'L' => left, 'R' => right }
    end

    step_count = 0
    current_key = 'AAA'
    until current_key == 'ZZZ' do
      steps.each do |step|
        step_count += 1
        current_key = map[current_key][step]
        break if current_key == 'ZZZ'
      end
    end

    step_count
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
