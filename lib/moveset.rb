require "nokogiri"
require "open-uri"
require "pry"

class Moveset
	attr_accessor :pokemon, :moves

	include Concerns::Basics

	@@all=[]

	def initialize(args)
		super(args)
		@pokemon.moveset = self
		@moves.each do |key, attack|

			if attack[:move].nil?
				binding.pry
				begin
					AttackError
				rescue AttackError => error
					puts error.message
				end
			end
			attack[:move].add_pokemon(@pokemon)
		end
		puts "Done with #{@pokemon.name}!"
	end

	class AttackError < StandardError
		def message
			"The input was not a proper instance of the Attack class"
		end
	end


	def self.all
		@@all
	end

  def self.create_from_url(url1="http://www.angelfire.com/nb/rpg/moves.html", url2="http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_National_Pok%C3%A9dex_number")
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
		while counter < rawContent.length do
			puts counter
			moveset= {}
			if rawContent[counter].text.strip.downcase.include?("level learned") || rawContent[counter].text.strip.split(": ")[1] == "-"
				#getting name of pokemon, used for connecting pokemon w/moves
				pokemonName = pokemonList[pokemonCounter].css("td")[3].text.strip

				# encoding issues
				if pokemonName == "Nidoran\u2640"
					pokemonName = "Nidoran F"
				elsif pokemonName == "Nidoran\u2642"
					pokemonName = "Nidoran M"
				end

				moveset[:pokemon] = Pokemon.find_by_name(pokemonName)

				pokemonCounter += 1
				#getting moves for next pokemon in list order
				moveset[:moves] = {}
				moveNum = 1

				#Very annoying website to parse!
				if rawContent[counter].text.strip.downcase.include?("moves")
					counter += 1
				end

				until rawContent[counter].text.strip.downcase == "" || rawContent[counter].text.strip.downcase.include?("ratings") do
					temp = {}

					moveName = rawContent[counter].text.strip.split(": ")[0]
					level = rawContent[counter].text.strip.split(": ")[1]

					#website corrections: mispelling
					if moveName.downcase.gsub(/\s+/, "")=="hijumpkick"
						moveName="Hi Jump Kick"
					elsif moveName.downcase.gsub(/\s+/, "") == "pinmissle"
						moveName="Pin Missile"
					elsif moveName.downcase.gsub(/\s+/, "") == "sandattack"
						moveName="Sand-Attack"
					elsif moveName.downcase.gsub(/\s+/, "") == "dorndrill"
						moveName="Horn Drill"
					elsif moveName.downcase.gsub(/\s+/, "") == "sctratch"
						moveName="Scratch"
					end

					#more corrections: inconsistent formatting on website
					if level.nil?
						level = "-"
						moveName = moveName.gsub(" -", "").gsub(":","")
					end

					temp[:move] = Attacks.find_by_name(moveName)
					temp[:level] = level
					moveset[:moves][moveNum.to_s.to_sym] = temp
					counter += 1
					moveNum += 1
				end
				new(moveset)
			end
			counter += 1
		end
		nil
	end
end
