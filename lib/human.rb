class Human < Player
    attr_accessor :token, :party, :currentPokemon

  def make_move

  end

  def changePokemon(index)
      @currentPokemon = party[index.to_i-1]
  end

end
