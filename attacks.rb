require "nokogiri"
require "open-uri"
require "pry"

class Attacks
	attr_accessor :name, :desc, :type, :pp, :power, :acc

	@@all=[]

	# Should have a list of pokemon it belongs to
	def initialize (hash)
		hash.each{|key, val| send("#{key}=", val)}
		@@all << self
	end

	def self.all
		@@all
	end

	def self.add_by_url(url)
		# http://www.psypokes.com/rby/attacks.php
		html = open(url)
		doc = Nokogiri::HTML(html)
		# binding.pry
		# tr~tr means tr preceeded by a tr
		doc.css("table.psypoke tr~tr").each do |row|
			# binding.pry
			attack=row.css("td").collect do |column|
				column.text
			end
			# binding.pry
			self.new({name:attack[0], desc:attack[1], type:attack[2], pp:attack[3], power:attack[4], acc:attack[5]})
		end
	end

	def self.clear
		@@all.clear
	end

	def self.find_by_name

	end

	def self.find_by_type
	end
	def self.find_by_power
	end
	def self.find_by_acc
	end


end
