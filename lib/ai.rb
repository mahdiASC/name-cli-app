class AI < Player
  attr_accessor :token, :currentPokemon, :difficulty
  attr_reader :party

  def initialize(difficulty)
    @difficulty = difficulty[0]
  end

  def make_move
    if @difficulty=="easy"
      easy_move
    else
      advanced_move
    end
  end

  def easy_move

  end

  def advanced_move
    @currentPokemon.moveset.max do |move|
      if move.pp >0
        move.power.to_i
      else
        0
      end
    end
  end
end
