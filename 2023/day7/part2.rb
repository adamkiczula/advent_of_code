require_relative '../solution_base'

class Solution < SolutionBase
  SAMPLE_INPUT = <<~SAMPLE
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
  SAMPLE
  SAMPLE_ANSWER = 5905
  SORT_SCORE = {
    'A' => 'a',
    'K' => 'b',
    'Q' => 'c',
    'T' => 'd',
    '9' => 'e',
    '8' => 'f',
    '7' => 'g',
    '6' => 'h',
    '5' => 'i',
    '4' => 'j',
    '3' => 'k',
    '2' => 'l',
    'J' => 'm'
  }
  WILD_CARD = 'J'

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
    wild_card_count = grouped.delete(WILD_CARD) || 0
    return 0 if five_of_a_kind?(grouped, wild_card_count)
    return 1 if four_of_a_kind?(grouped, wild_card_count)
    return 2 if full_house?(grouped, wild_card_count)
    return 3 if three_of_a_kind?(grouped, wild_card_count)
    return 4 if two_pair?(grouped, wild_card_count)
    return 5 if one_pair?(grouped, wild_card_count)
    6 # high card
  end

  def five_of_a_kind?(grouped, wild_card_count)
    wild_card_count == 5 || grouped.values.any? { |count| count == 5 - wild_card_count }
  end

  def four_of_a_kind?(grouped, wild_card_count)
    grouped.values.any? { |count| count == 4 - wild_card_count }
  end

  def full_house?(grouped, wild_card_count)
    case wild_card_count
    when 1
      two_pair?(grouped, 0)
    when 2
      one_pair?(grouped, 0)
    else
      grouped.values.any? { |count| count == 3 } && grouped.values.any? { |count| count == 2 }
    end
  end

  def three_of_a_kind?(grouped, wild_card_count)
    grouped.values.any? { |count| count == 3 - wild_card_count }
  end

  def two_pair?(grouped, wild_card_count)
    case wild_card_count
    when 1
      grouped.values.count { |count| count == 2 } == 1
    when 2
      true
    else
      grouped.values.count { |count| count == 2 } == 2
    end
  end

  def one_pair?(grouped, wild_card_count)
    grouped.values.any? { |count| count == 2 - wild_card_count }
  end
end

Solution.run(File.dirname(__FILE__)) if __FILE__ == $0
