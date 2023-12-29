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
  SAMPLE_ANSWER = 374

  private

  def algorithm(input)
    galaxy_map = map_galaxies(input)
    expanded = expand(input, galaxy_map)
    expanded_map = map_galaxies(expanded)
    total = 0
    expanded_map.keys.combination(2).each do |(galaxy1, galaxy2)|
      coords1 = expanded_map[galaxy1]
      coords2 = expanded_map[galaxy2]
      total += distance(coords1, coords2)
    end

    total
  end

  def expand(input, galaxy_map)
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
    expanded = []
    input.each_with_index do |row, i|
      columns = row.split('')
      columns_to_expand.sort.reverse.each do |column|
        columns.insert(column, '.')
      end
      expanded << columns
      expanded << columns if rows_to_expand.include?(i)
    end
    expanded
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

  def distance(coords1, coords2)
    (coords2.first - coords1.first).abs + (coords2.last - coords1.last).abs
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
