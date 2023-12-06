# frozen_string_literal: true

require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
  SAMPLE
  SAMPLE_ANSWER = 46

  private
  def algorithm(input)
    seeds_ranges = input.shift.split(/\s+/)[1..-1].map(&:to_i)
    maps = build_maps(input)
    min_location = nil
    t_start = Time.now.to_i
    seeds_ranges.each_slice(2) do |range_start, length|
      puts "processing range_start: #{range_start}, length: #{length}"
      range_start.upto(range_start + length - 1) do |seed|
        location = get_mapping(maps, seed, 'seed')
        min_location = location if min_location.nil? || location < min_location
      end
      puts "current min_location: #{min_location}"
    end
    t_end = Time.now.to_i
    puts "time elapsed: #{t_end - t_start} seconds" # 32829 seconds!
    puts "min_location: #{min_location}"

    min_location
  end

  def build_maps(input)
    current_map = nil
    input.each_with_object({}) do |line, maps|
      if line.include?('map:')
        current_map = line.split(/\s+/).first
        maps[current_map] = []
      elsif line.match?(/^\s*$/)
        current_map = nil
      else
        destination, source, length = line.split(/\s+/).map(&:to_i)
        maps[current_map] << { destination:, source:, length: }
      end
    end
  end

  def get_mapping(map, source, type)
    key = get_mapping_key(map, type)
    offset = 0
    map[key].each do |range|
      if range[:source] <= source && source <= range[:source] + range[:length]
        offset = range[:destination] - range[:source]
        break
      end
    end
    next_value = source + offset
    next_type = key.split('-').last
    if next_type == 'location'
      next_value
    else
      get_mapping(map, next_value, next_type)
    end
  end

  def get_mapping_key(map, type)
    map.keys.find { |key| key.start_with?(type) }
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
