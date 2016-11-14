class AI < Player
    attr_accessor :token, :party, :currentPokemon, :difficulty

  def initialize(difficulty)
    @difficulty = difficulty
  end

  def make_move
    if @difficulty=="easy"
      easy_move
    else
      advanced_move
    end
    #should return a hash of the opponent's stat to change (string) and the amount (integer)
    #Otherwise, some special effect
  end

  def easy_move

  end

  def advanced_move

  end
end
