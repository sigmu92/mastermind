require 'pry'

class Player
  attr_accessor :name
  def initialize(name: 'unknown')
    @name = name
  end
end

class Board
  def initialize
    board = board_generate
  end
  
end

class Code
  COLORS = ['R', 'B', 'Y', 'G', 'W', 'B']
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

binding.pry