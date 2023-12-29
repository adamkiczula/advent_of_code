require_relative '../solution_base'
require 'set'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
  SAMPLE
  # SAMPLE_ANSWER = 1030 # 10 expansion factor
  # SAMPLE_ANSWER = 8410 # 100 expansion factor
  SAMPLE_ANSWER = 82000210 # 1000000 expansion factor
  EXPANSION_FACTOR = 1000000

  private

  def algorithm(input)
    galaxy_map = map_galaxies(input)
    rows_to_expand, columns_to_expand = calculate_expansion(input, galaxy_map)
    total = 0
    galaxy_map.keys.combination(2).each do |(galaxy1, galaxy2)|
      coords1 = galaxy_map[galaxy1]
      coords2 = galaxy_map[galaxy2]
      total += distance(coords1, coords2, rows_to_expand, columns_to_expand)
    end

    total
  end

  def calculate_expansion(input, galaxy_map)
    rows_with_galaxies = Set.new
    columns_with_galaxies = Set.new
    galaxy_map.each do |_, position|
      rows_with_galaxies << position.first
      columns_with_galaxies << position.last
    end
    all_rows = Set.new(0..input.size - 1)
    all_columns = Set.new(0..input.first.size - 1)
    rows_to_expand = all_rows - rows_with_galaxies
    columns_to_expand = all_columns - columns_with_galaxies
    [rows_to_expand, columns_to_expand]
  end

  def map_galaxies(input)
    galaxy_map = {}
    next_galaxy = 1
    input.each_with_index do |row, i|
      columns = row.is_a?(Array) ? row : row.split('')
      columns.each_with_index do |column, j|
        if column == '#'
          galaxy_map[next_galaxy] = [i, j]
          next_galaxy += 1
        end
      end
    end
    galaxy_map
  end

  def distance(coords1, coords2, rows_to_expand, columns_to_expand)
    expanded_rows = rows_to_expand.select do |row|
      row < coords1.first && row > coords2.first || row < coords2.first && row > coords1.first
    end
    expanded_columns = columns_to_expand.select do |column|
      column < coords1.last && column > coords2.last || column < coords2.last && column > coords1.last
    end
    (coords2.first - coords1.first).abs +
      (coords2.last - coords1.last).abs +
      (expanded_rows.size * (EXPANSION_FACTOR - 1)) +
      (expanded_columns.size * (EXPANSION_FACTOR - 1))
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
