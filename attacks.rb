# http://www.psypokes.com/rby/attacks.php
require "nokogiri"
require "open-uri"

class Attack
	attr_accessor :name, :desc, :type, :pp, :power, :acc

	@@all=[]

	def initialize (hash)
		hash.each{|key, val| send("#{key}=", val)}
		@@all << self
	end
	
	def self.all
		@@all
	end

	def add_by_url_parse(url)

	end
end

x = Attack.new({name:"phill"})