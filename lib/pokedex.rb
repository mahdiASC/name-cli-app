require "nokogiri"
require "open-uri"
require "pry"

class Pokedex
	attr_accessor :pokemon, :attacks

    def initialize
		# Loads all pokemon and all attacks into pokedex
		Pokemon.create_from_url
		@pokemon = Pokemon.all
		Attacks.create_from_url
		@attacks = Attacks.all

		# Moveset handles bridginge the Pokemon with their moves
		Moveset.create_from_url
		puts "Done!"
    end
end
