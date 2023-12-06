require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    Time:      7  15   30
    Distance:  9  40  200
  SAMPLE
  SAMPLE_ANSWER = 71503

  private
  def algorithm(input)
    time = input[0].split(/\s+/)[1..-1].join('').to_i
    record = input[1].split(/\s+/)[1..-1].join('').to_i
    wins = 0
    1.upto(time-1) do |charge_time|
      distance = calculate_distance(charge_time, time)
      wins += 1 if distance > record
    end
    wins
  end

  def calculate_distance(charge_time, race_length)
    race_time = race_length - charge_time
    race_time * charge_time
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
