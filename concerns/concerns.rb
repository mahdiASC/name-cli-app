require "pry"
module Concerns
    module Basics
        def initialize (hash)
    		hash.each{|key, val| send("#{key}=", val)}
    		self.class.all << self
    	end

        def view
            self.instance_variables.each do |item|
                if item.is_a?(String)
                    puts "#{item}".gsub!("@","").upcase + ": "+ self.instance_variable_get(item)
                elsif item.is_a?(Attack)
                    puts "Move: Level Learned"
                    item.each do |move|
                        puts "#{move[:attack].name}: #{move[:level]}"
                    end
                end
            end
        end
    end

    module ClassMods
        def clear
            all.clear
        end

        #find or create by name?
        def find_by(search, category="name")
            #category is a string
            #search is a string
            all.select do |item|
                #Inconsistent naming -.-
                item.instance_variable_get("@#{category}").downcase.gsub(/\s+/, "") == search.downcase.gsub(/\s+/, "")
            end
            #returns the item or nil if not found
        end

        def find_by_name(name)
            if !find_by(name).nil?
                find_by(name)[0]
            else
                nil
            end
        end

        def find_or_create(hash)
            if !find_by_name(hash[:name]).nil?
                find_by_name(hash[:name])
            else
                new(hash)
            end
        end
    end

end
