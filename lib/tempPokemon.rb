require "pry"
class TempPokemon < Pokemon
  attr_accessor :name, :hp, :atk, :def, :spec, :spd, :moveset

  def initialize(pokemon)
    #copies almost everything from a pokedex pokemon
    if !pokemon.is_a?(Pokemon)
      begin
        raise PokemonError
      rescue PokemonError => error
        error.message
      end
    end

    # parsing data from pokedex pokemon
    pokemon.instance_variables.each do |item|
      if item != :@moveset
        temp = pokemon.instance_variable_get(item)
      else
        #Using just the 4 most advanced moves (not caring about linking attacks to pokemon)
        temp=[]
        if pokemon.instance_variable_get(item).moves.length <4
            pokemon.instance_variable_get(item).moves.collect do |key,move|
                temp << TempAttacks.new(move[:move])
            end
        else
          moves=pokemon.instance_variable_get(item).moves
          ((moves.length-3)..(moves.length)).to_a.each do |index|
            temp << TempAttacks.new(moves[index.to_s.to_sym][:move])
          end
        end
      end
      self.instance_variable_set(item,temp)
    end
    nil
  end

  class PokemonError < StandardError
		def message
			"The input was not a proper instance of the Pokemon class"
		end
	end
end
