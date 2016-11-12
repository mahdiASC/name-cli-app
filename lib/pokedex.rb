require "nokogiri"
require "open-uri"
require "pry"

class Pokedex
	attr_accessor :pokemon, :attacks

    def initialize
		# Loads all pokemon and all attacks into pokedex
		@pokemon = Pokemon.add_by_url
		@attacks = Attacks.add_by_url
		# Missing any relationship between Pokemon and their attacks
		# The pokedex handles bridging Pokemon and their attacks
    end

	
	def link_pokemon_and_attacks
		self.class.parse_data_from_url.each do |attack|
			puts attack[:allMoves][:move]
			Pokemon.find_by_name(attack[:pokemonName]).moves = attack[:allMoves].collect do |key, move|
				puts "#{key} and #{move}"
				# binding.pry
				temp = {}
				temp[:attack] = Attacks.find_by(move[:move])
				temp[:level] = move[:level]
				temp
			end
		end

	end
end
