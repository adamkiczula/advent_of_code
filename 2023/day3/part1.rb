require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
  SAMPLE
  SAMPLE_ANSWER = 4361
  SYMBOLS = /[\/*@%$+=\-#&]/

  private
  def algorithm(input)
    map = build_map(input)
    parts = []
    input.each_with_index do |line, index|
      line.to_enum(:scan, /\d+/).each do
        match = Regexp.last_match
        start_idx, idx_after_match = match.offset(0)
        end_idx = idx_after_match - 1
        start_idx.upto(end_idx) do |char_index|
          next unless map[index][char_index]
          num = match.to_s.to_i
          parts << match.to_s.to_i
          break
        end
      end
    end
    parts.sum
  end

  def build_map(input)
    map = Hash.new { |h, k| h[k] = Hash.new(false) }
    input.each_with_index do |line, index|
      line.to_enum(:scan, SYMBOLS).each do
        symbol_index = Regexp.last_match.begin(0)
        coords = { symbol_index - 1 => true, symbol_index =>  true, symbol_index + 1 => true }
        map[index - 1].merge!(coords)
        map[index].merge!(coords)
        map[index + 1].merge!(coords)
      end
    end

    map
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
