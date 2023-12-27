require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
  SAMPLE
  SAMPLE_ANSWER = 8
  PIPES = {
    '|' => { 'N' => true, 'S' => true },
    '-' => { 'E' => true, 'W' => true },
    'L' => { 'N' => true, 'E' => true },
    'J' => { 'N' => true, 'W' => true },
    '7' => { 'S' => true, 'W' => true },
    'F' => { 'S' => true, 'E' => true },
  }

  private

  def algorithm(input)
    max_y = input.size
    max_x = input.first.chomp.size
    s_coords = nil
    input.each_with_index do |line, y|
      line.chomp.split('').each_with_index do |char, x|
        next if char == '.'
        if char == 'S'
          s_coords = [x, y]
          next
        end
        @connections ||= Hash.new { |h, k| h[k] = [] }
        adjacent(char, x, y, max_x, max_y, input).each do |adj_x, adj_y|
          @connections[[adj_x, adj_y]] << [x, y]
        end
      end
    end
    visited = []
    coords = s_coords
    count = 0
    loop do
      visited << coords
      count += 1 unless coords == s_coords
      coords = @connections[coords].reject { |next_coords| visited.include?(next_coords) }.first
      break if coords.nil?
    end
    (count / 2.0).round
  end

  def adjacent(pipe, x, y, max_x, max_y, input)
    coords = []
    case pipe
    when '|'
      coords << [x, y - 1] if y > 0
      coords << [x, y + 1] if y + 1 < max_y
    when '-'
      coords << [x - 1, y] if x > 0
      coords << [x + 1, y] if x + 1 < max_x
    when 'L'
      coords << [x, y - 1] if y > 0
      coords << [x + 1, y] if x + 1 < max_x
    when 'J'
      coords << [x, y - 1] if y > 0
      coords << [x - 1, y] if x > 0
    when '7'
      coords << [x, y + 1] if y + 1 < max_y
      coords << [x - 1, y] if x > 0
    when 'F'
      coords << [x, y + 1] if y + 1 < max_y
      coords << [x + 1, y] if x + 1 < max_x
    end
    coords.reject! do |adj_x, adj_y|
      adj_pipe = input[adj_y][adj_x]
      next if adj_pipe == 'S'
      adj_x < x && !PIPES.dig(adj_pipe, 'E') ||
        adj_x > x && !PIPES.dig(adj_pipe, 'W') ||
        adj_y < y && !PIPES.dig(adj_pipe, 'S') ||
        adj_y > y && !PIPES.dig(adj_pipe, 'N')
    end
    coords
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
