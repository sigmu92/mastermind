require 'pry'

class Player
  attr_accessor :name
  def initialize(name: 'unknown')
    @name = name
  end
end

class Board
  attr_accessor :board
  def initialize
    @board = board_generate
  end

  def board_generate
    Array.new(12){%w[- - - - | o o o o]}
  end

  def update_guesses(row, guesses)
    for i in 0..3
      board[row][i] = guesses[i]
    end 
  end

  def update_response(row, responses)
    for i in 5..8
      board[row][i] = responses[i-5]
    end 
  end

  def display_board
    puts '*****************'
    board.each do |row|
      row.each { |column| print "#{column} " }
      puts ''
    end
    puts '*****************'
  end
end

class Code

  attr_accessor :code
  attr_reader :COLORS

  COLORS = %w[R B Y G W P]

  def initialize(code = code_generate)
    @code = code
  end

  def code_generate
    arr = []
    for i in 1..4
      arr.push(COLORS[(rand(COLORS.length))])
    end
    arr
  end

  def evaluate(guess)
    checks = []
    temp_code = get_expend(code)
    checks += check_exact(guess, temp_code)
    checks += check_inexact(guess, temp_code)
    checks.push('o') until checks.length == 4
    checks
  end

  # Private

  def get_expend(code)
    expend = []
    code.each{|let| expend.push(let)}
    expend
  end

  def check_exact(guess, round_code)
    exacts = []
    guess.each_with_index do |let, i|
      next if let != round_code[i] 
      exacts.push('B')
      let = ''
      round_code[i] = ''
    end
    exacts
  end

  def check_inexact(guess, round_code)
    inexacts = []
    guess.each do |let|
      if round_code.include?(let) && let != ''
        inexacts.push('W')
        round_code[round_code.index(let)]=''
      end
    end
    inexacts
  end

end

class Game
  attr_accessor :guess, :response
  attr_reader :code, :board
  def initialize(board, code)
    @guess = []
    @response = []
    @board = board
    @code = code
  end

  def run()
    round = 0
    until round == 12
      response = []
      guess = get_guess
      board.update_guesses(round, guess)
      response = code.evaluate(guess)
      board.update_response(round, response)
      board.display_board
      round += 1
      if response == %w[B B B B]
        game_end(round)
        break
      end 
    end
    if round == 12
      puts "You lose! The code was #{code.code.join(' ')}"
    end
  end

  def get_guess
    puts 'Please enter your guess!! Possible colors: R B Y G W P: '
    input = gets.chomp.upcase.split('')
    until valid_guess?(input)
      puts 'Invalid guess!! Guess again:'
      input = gets.chomp.upcase.split('')
    end
    input
  end

  def valid_guess?(input)
    valid = %w[R B Y G W P]
    invalid = input.select {|let| !valid.include?(let)}
    invalid.length.zero? && input.length == 4
  end

  def game_end(round)
    puts "You guessed the code in #{round} rounds!!"
  end
end


def welcome
  puts 'Welcome to Mastermind!!'
end

welcome
board = Board.new
code = Code.new
game = Game.new(board, code)
game.run

