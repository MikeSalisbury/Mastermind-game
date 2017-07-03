class Code
  PEGS = {
     "R" => :red,
     "G" => :green,
     "B" => :blue,
     "Y" => :yellow,
     "O" => :orange,
     "P" => :purple
   }

  attr_reader :pegs

    def initialize(array)
      @pegs = array
    end

    def self.parse(input)
      array = input.upcase.chars
      input.upcase.chars do |el|
        if !PEGS[el]
          raise "Your input includes an invalid color"
        end
      end
      Code.new(array)
    end

    def self.random
      random = PEGS.keys.sample(4)
      Code.new(random)
    end

    def [](idx)
      @pegs[idx]
    end

    def exact_matches(input)
      exact_match = 0
        @pegs.each_with_index do |el, i|
          if input[i] == el
            exact_match += 1
          end
      end

      exact_match
    end

    def near_matches(input)
      near_match = 0
      counter_array = Hash.new(0)

      input.pegs.each do |el|
        counter_array[el] += 1
      end
      counter_peg = Hash.new(0)
      @pegs.each do |el|
        counter_peg[el] += 1
      end

      counter_array.each do |k, v|
        if counter_peg[k] && v < counter_peg[k]
          near_match += v
        elsif counter_peg[k] && v >= counter_peg[k]
          near_match += counter_peg[k]
        end
      end

      near_match - exact_matches(input)
    end

    def ==(guess)
      if guess.class == Code
        return @pegs == guess.pegs
      end
      false

    end

end

class Game
  attr_reader :secret_code

  def initialize(code = nil)
    @secret_code = code ||= Code.random
  end

  def get_guess
    guess = gets.chomp.upcase.split
    Code.new(guess)
  end

  def display_matches(guess)
      p "You have #{guess.exact_matches(@secret_code)} exact matches"
      p "You have #{guess.near_matches(@secret_code)} near matches"
  end

  def valid_guess?(guess)
    return guess.pegs.length == 4 && guess.pegs.all? {|color| Code::PEGS[color] }
  end


  def play
    guesses = 0
    until guesses == 10
      p 'available colors are R, G, B, Y, O, P'
      p 'Please make a guess of 4 colors separated by a space - (B B B B)'
      guess = get_guess
      guesses += 1
      if valid_guess?(guess)
        if guess ==(@secret_code)
          puts "you've broken the code! the code was #{@secret_code.pegs}, you used #{guesses} guesses."
          break
        else
          p "Your guess was incorrect"
          display_matches(guess)
        end
      else
        p "Invalid color or format selected"
        guesses -= 1
      end
    end

    if guesses == 10
      p "You've used all of your guesses. You lose!"
    end
  end

  if $0 == __FILE__
    game = Game.new
    game.play
  end

end
