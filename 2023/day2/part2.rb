require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  SAMPLE
  SAMPLE_ANSWER = 2286

    private
  def algorithm(input)
    sum = 0
    input.each do |line|
      max_red = 1
      max_green = 1
      max_blue = 1
      line.split(':').last.split(';').each do |turn|
        red = turn.scan(/(\d+) red/).dig(0, 0).to_i
        green = turn.scan(/(\d+) green/).dig(0, 0).to_i
        blue = turn.scan(/(\d+) blue/).dig(0, 0).to_i
        max_red = red if red > max_red
        max_green = green if green > max_green
        max_blue = blue if blue > max_blue
      end

      sum += max_red * max_green * max_blue
    end
    sum
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
