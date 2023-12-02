class SolutionBase
  def self.run(directory)
    solution = new(directory)
    puts "Sample Passed: #{solution.check_sample}"
    puts "Answer: #{solution.answer}"
  end

  def initialize(directory)
    @lines = File.readlines(File.join(directory, 'input.txt'))
  end

  def answer
    algorithm(lines)
  end

  def check_sample
    algorithm(self.class::SAMPLE_INPUT.split("\n")) == self.class::SAMPLE_ANSWER
  end

  private

  attr_reader :lines
end