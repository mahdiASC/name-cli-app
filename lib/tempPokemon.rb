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
        self.instance_variable_set(item, pokemon.instance_variable_get(item))
      else
        #Using just the 4 most advanced moves (not caring about linking attacks to pokemon)
        if pokemon.instance_variable_get(item).moves.length <4
          self.instance_variable_set(item, pokemon.instance_variable_get(item).moves)
        else
          moves=pokemon.instance_variable_get(item).moves
          output = {}
          ((moves.length-3)..(moves.length)).to_a.each do |index|
            output[index.to_s.to_sym]= moves[index.to_s.to_sym]
          end
          self.instance_variable_set(item,output)
        end
      end

    end
    nil
  end

  class PokemonError < StandardError
		def message
			"The input was not a proper instance of the Pokemon class"
		end
	end
end
