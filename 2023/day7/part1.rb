require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
  SAMPLE
  SAMPLE_ANSWER = 6440
  SORT_SCORE = {
    'A' => 'a',
    'K' => 'b',
    'Q' => 'c',
    'J' => 'd',
    'T' => 'e',
    '9' => 'f',
    '8' => 'g',
    '7' => 'h',
    '6' => 'i',
    '5' => 'j',
    '4' => 'k',
    '3' => 'l',
    '2' => 'm'
  }

  private
  def algorithm(input)
    parsed = []
    input.each do |line|
      hand, bid = line.split(/\s+/)
      cards = hand.split('')
      parsed << { hand:, cards:, bid:, score: score_hand(cards), secondary: sort_score(cards) }
    end
    parsed.sort_by! { |hand| [hand[:score], hand[:secondary]] }.reverse!
    total = 0
    parsed.each_with_index do |hand, index|
      total += hand[:bid].to_i * (index + 1)
    end
    total
  end

  def sort_score(cards)
    cards.map { |card| SORT_SCORE[card] }.join('')
  end

  def score_hand(cards)
    grouped = cards.group_by(&:itself).transform_values(&:count)
    return 0 if five_of_a_kind?(grouped)
    return 1 if four_of_a_kind?(grouped)
    return 2 if full_house?(grouped)
    return 3 if three_of_a_kind?(grouped)
    return 4 if two_pair?(grouped)
    return 5 if one_pair?(grouped)
    6 # high card
  end

  def five_of_a_kind?(grouped)
    grouped.values.any? { |count| count == 5 }
  end

  def four_of_a_kind?(grouped)
    grouped.values.any? { |count| count == 4 }
  end

  def full_house?(grouped)
    grouped.values.any? { |count| count == 3 } && grouped.values.any? { |count| count == 2 }
  end

  def three_of_a_kind?(grouped)
    grouped.values.any? { |count| count == 3 }
  end

  def two_pair?(grouped)
    grouped.values.count { |count| count == 2 } == 2
  end

  def one_pair?(grouped)
    grouped.values.any? { |count| count == 2 }
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
