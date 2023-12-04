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
  SAMPLE_ANSWER = 467835
  SYMBOLS = /\*/

  private
  def algorithm(input)
    map = build_map(input)
    used_gears = Hash.new { |h, k| h[k] = [] }
    input.each_with_index do |line, index|
      line.to_enum(:scan, /\d+/).each do
        match = Regexp.last_match
        start_idx, idx_after_match = match.offset(0)
        end_idx = idx_after_match - 1
        start_idx.upto(end_idx) do |char_index|
          gear_id = map[index][char_index]
          next unless gear_id
          used_gears[gear_id] << match.to_s.to_i
          break
        end
      end
    end
    sum = 0
    used_gears.each do |_, numbers|
      next unless numbers.size == 2
      ratio = numbers.first * numbers.last
      sum += ratio
    end
    sum
  end

  def build_map(input)
    map = Hash.new { |h, k| h[k] = Hash.new(false) }
    input.each_with_index do |line, index|
      line.to_enum(:scan, SYMBOLS).each do
        symbol_index = Regexp.last_match.begin(0)
        gear_id = "#{index},#{symbol_index}"
        coords = { symbol_index - 1 => gear_id, symbol_index => gear_id, symbol_index + 1 => gear_id }
        map[index - 1].merge!(coords)
        map[index].merge!(coords)
        map[index + 1].merge!(coords)
      end
    end

    map
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
