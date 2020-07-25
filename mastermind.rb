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
  attr_reader :code
  COLORS = %w[R B Y G W P]
  def initialize
    @code = code_generate
  end

  def code_generate
    arr = []
    for i in 1..4
      arr.push(COLORS[(rand(5)+1)])
    end
    return arr
  end
end

class Game
  attr_accessor :guess, :response, :round_code
  attr_reader :code, :board
  def initialize(board, code)
    @guess = []
    @response = []
    @board = board
    @code = code.code
    @round_code = []
  end

  def run()
    round = 0
    until round == 11
      response = []
      guess = get_guess
      board.update_guesses(round, guess)
      round_code = get_expend(code)
      response = evaluate(guess, round_code)
      board.update_response(round, response)
      board.display_board
      if response == %w[B B B B]
        game_end(round)
        break
      end
      round += 1
    end
    if round == 11
      puts "You lose! The code was #{code.join(' ')}"
    end
  end

  def get_expend(code)
    expend = []
    code.each{|let| expend.push(let)}
    expend
  end

  def get_guess
    puts 'Please enter your guess!! Possible colors: R B Y G W P (Enter a space between each letter): '
    input = gets.chomp
    until valid_guess?(input)
      puts 'Invalid guess!! Guess again:'
      input = gets.chomp
    end
    input.split(' ')
  end

  def valid_guess?(input)
   
    valid = %w[R B Y G W P]
    inputArr = input.split(" ")
    invalid = inputArr.select {|let| !valid.include?(let)}
    invalid.length.zero? && inputArr.length == 4
  end

  def evaluate(guess, round_code)
    checks = []
    checks += check_exact(guess, round_code)
    checks += check_inexact(guess, round_code)
    until checks.length == 4
      checks.push('o')
    end
    checks
  end

  def check_exact(guess, round_code)
    exacts = []
    for i in 0..3
      if guess[i] == round_code[i]
        exacts.push('B')
        guess[i] = ''
        round_code[i] = ''
      end
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

