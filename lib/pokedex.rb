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

	def self.parse_data_from_url(url1="http://www.angelfire.com/nb/rpg/moves.html", url2="http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_National_Pok%C3%A9dex_number")
        # http://www.angelfire.com/nb/rpg/moves.html
		# http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_National_Pok%C3%A9dex_number
		# First url has pokemon moves in proper pokemon order
		# Second url has pokemon names in proper pokemon order

		#using list of pokemon moves in their correct pokemon order
		html1 = open(url1)
		doc1 = Nokogiri::HTML(html1)
		rawContent=doc1.css("body #lycosFooterAd~*")

		#using correct order list of pokemon (cannot be parsed from first url)
		html2 = open(url2)
		doc2 = Nokogiri::HTML(html2)
		pokemonList=doc2.css("table")[1].css("tr~tr")

		counter = 0
		pokemonCounter = 0
		output=[]
		until counter == rawContent.length-1 do
			moveset={}
			if rawContent[counter].text.strip.downcase.include?("level learned") || rawContent[counter].text.strip.split(": ")[1] == "-"
				#getting name of pokemon, used for connecting pokemon w/moves
				moveset[:pokemonName] = pokemonList[pokemonCounter].css("td")[3].text.strip
				if moveset[:pokemonName] == "Nidoran\u2640"
					moveset[:pokemonName] = "Nidoran F"
				elsif moveset[:pokemonName] == "Nidoran\u2642"
					moveset[:pokemonName] = "Nidoran M"
				end


				pokemonCounter += 1
				#getting moves for next pokemon in list order
				moveset[:allMoves] = {}
				moveNum = 1

				#Very annoying website to parse!
				if rawContent[counter].text.strip.downcase.include?("moves:")
					counter += 1
				end

				until rawContent[counter].text.strip.downcase == "" || rawContent[counter].text.strip.downcase.include?("ratings") do
					temp = {}
					temp[:move] = rawContent[counter].text.strip.split(": ")[0]
					temp[:level] = rawContent[counter].text.strip.split(": ")[1]
					moveset[:allMoves][moveNum.to_s.to_sym] = temp
					counter += 1
					moveNum += 1
				end
				output << moveset
			end
			counter += 1
		end
		output
		#{:pokemonName =>"name", :allMoves =>{:"1"=>{:move=>"moveName",:level=>"1"},...}}
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
