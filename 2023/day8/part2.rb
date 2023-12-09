require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
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

    answers = []
    map.keys.map do |key|
      next unless key.end_with?('A')
      step_count = 0
      current_key = key
      until current_key.end_with?('Z') do
        steps.each do |step|
          step_count += 1
          current_key = map[current_key][step]
          break if current_key.end_with?('Z')
        end
      end

      answers << step_count
    end
    answers.reduce(1, :lcm)
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
