class SolutionBase
  def self.run(directory)
    solution = new(directory)
    puts "Running sample..."
    solution.check_sample
    puts "Running..."
    answer = solution.answer
    puts "Answer: #{answer}" if answer
  end

  def initialize(directory)
    @lines = File.readlines(File.join(directory, 'input.txt'))
  end

  def answer
    algorithm(lines)
  end

  def check_sample
    sample_answer = algorithm(self.class::SAMPLE_INPUT.split("\n"))
    passed = sample_answer == self.class::SAMPLE_ANSWER
    puts "Sample Answer: #{passed}" if sample_answer
  end

  private

  attr_reader :lines
end