require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  SAMPLE
  SAMPLE_ANSWER = 30

  private
  def algorithm(input)
    scores = input.each_with_object({}) do |line, scores|
      scores[card_number(line)] = score(line)
    end

    sum = input.size
    input.each do |line|
      card_number = card_number(line)
      sum += score_card(card_number, scores)
    end
    sum
  end

  def score_card(card_number, score_cache)
    return 0 if card_number > score_cache.size
    sum = score_cache[card_number]
    1.upto(score_cache[card_number]) do |i|
      sum += score_card(card_number + i, score_cache)
    end
    sum
  end

  def card_number(line)
    line.scan(/Card\s+(\d+):/).dig(0, 0).to_i
  end

  def score(line)
    # print '.'
    parts = line.split(/\s+/)
    pipe_index = parts.index('|')
    winning = parts[2..(pipe_index - 1)]
    card = parts[(pipe_index + 1)..-1]
    matching_digits = winning & card
    matching_digits.size
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
