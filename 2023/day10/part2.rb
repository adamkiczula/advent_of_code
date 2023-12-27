require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
  SAMPLE
  SAMPLE_ANSWER = 4
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
    pipes = []
    min_x_by_y = {}
    min_y_by_x = {}
    max_x_by_y = {}
    max_y_by_x = {}
    coords = s_coords
    loop do
      pipes << coords
      min_x_by_y[coords[1]] = coords[0] if min_x_by_y[coords[1]].nil? || coords[0] < min_x_by_y[coords[1]]
      min_y_by_x[coords[0]] = coords[1] if min_y_by_x[coords[0]].nil? || coords[1] < min_y_by_x[coords[0]]
      max_x_by_y[coords[1]] = coords[0] if max_x_by_y[coords[1]].nil? || coords[0] > max_x_by_y[coords[1]]
      max_y_by_x[coords[0]] = coords[1] if max_y_by_x[coords[0]].nil? || coords[1] > max_y_by_x[coords[0]]
      coords = @connections[coords].reject { |next_coords| pipes.include?(next_coords) }.first
      break if coords.nil?
    end

    input.each_with_index do |line, y|
      line.chomp.split('').each_with_index do |char, x|
        if pipes.include?([x, y])
          print char_to_pipe(char)
        elsif min_x_by_y[y].nil? || max_x_by_y[y].nil? ||
              min_y_by_x[x].nil? || max_y_by_x[x].nil? ||
              x < min_x_by_y[y] || x > max_x_by_y[y] || y < min_y_by_x[x] || y > max_y_by_x[x]
          print ' '
        else
          print '.'
        end
      end
      puts
    end

    # doesn't output solution, but prints the map
    # you can then use a paint program to fill in the outside of the map
    # anything not filled is enclosed by pipes
    nil
  end

  def char_to_pipe(char)
    case char
    when '|'
      "\u2502"
    when '-'
      "\u2500"
    when 'L'
      "\u2514"
    when 'J'
      "\u2518"
    when '7'
      "\u2510"
    when 'F'
      "\u250C"
    when 'S'
      "\u253C"
    end
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
