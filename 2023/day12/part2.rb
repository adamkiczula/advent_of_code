require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
  SAMPLE
  SAMPLE_ANSWER = 525152

  def algorithm(input)
    total = 0
    input.each do |line|
      springs, groups = line.split(' ')
      groups = groups.split(',').map(&:to_i)
      springs = springs.split('')

      # unfold the records
      groups *= 5
      springs << '?'
      springs *= 5
      springs.pop

      cache = {}
      result = count_arrangements(springs, groups, cache, 0)
      total += result
    end

    total
  end

  def count_arrangements(springs, groups, cache, i)
    if groups.size == 0
      return 0 if springs[i..-1]&.include?('#')
      return 1
    end
    i += 1 while i < springs.size && springs[i] != '?' && springs[i] != '#'
    return 0 if i >= springs.size
    return cache[[i, groups.size]] if cache.key?([i, groups.size])
    group = groups.first
    result = 0
    if can_fit?(springs, (i...(i + group)))
      result += count_arrangements(springs, groups[1..-1], cache, i + group + 1)
    end
    if springs[i] == '?'
      result += count_arrangements(springs, groups, cache, i + 1)
    end
    cache[[i, groups.size]] = result
    result
  end

  def can_fit?(springs, range)
    return false if range.end > springs.size
    return false if springs[range].any? { |s| s == '.' }
    return false if range.end < springs.size && springs[range.end] == '#'
    true
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
