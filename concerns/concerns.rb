require "pry"
module Concerns
    module Basics
        def initialize (hash)
          hash.each{|key, val| send("#{key}=", val)}
      		self.class.all << self
      	end

        def view
          puts "#{self.name.upcase}"
          puts '------------------'
            self.instance_variables.each do |item|
              puts "#{item.to_s.gsub!("@","").upcase}: #{self.instance_variable_get(item)}"
            end
            nil
        end
    end

    module ClassMods
        def clear
            all.clear
        end


        class CategoryError < StandardError
          def message
            puts "The category was not a proper instance variable of the #{self} class"
          end
        end

        #find or create by name?
        def find_by(search, category="name")
            #category is a string
            #search is a string
            # if include?(category)
            #   begin
            #     raise CategoryError
            #   rescue CategoryError => error
            #     puts error.message
            #   end
            # end

            all.select do |item|
                #Inconsistent naming -.-
                item.instance_variable_get("@#{category}").downcase.gsub(/\s+/, "") == search.downcase.gsub(/\s+/, "")
            end
            #returns the item or nil if not found
        end

        def find_by_name(name)
          all.detect do |item|
              #Inconsistent naming -.-
              item.instance_variable_get("@name").downcase.gsub(/\s+/, "") == name.downcase.gsub(/\s+/, "")
          end
        end

        def find_or_create(hash)
            find_by_name(hash[:name]).nil? ? new(hash) : find_by_name(hash[:name])
        end
    end
end
