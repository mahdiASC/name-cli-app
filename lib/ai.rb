class AI < Player
  attr_accessor :token, :party, :difficulty

  def initialize(token,party, difficulty)
    super(token, party)
    @difficulty = difficulty
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
  end
end
