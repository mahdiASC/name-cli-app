require "pry"

class TempAttacks
    attr_accessor :name, :desc, :type, :pp, :power, :acc

    def initialize(attack)
        #Takes a Pokedex Attack and converts it into a temporary one for use in game by Players
        if !attack.is_a?(Attacks)
            begin
                raise AttacksError
            rescue AttacksError => error
                error.message
            end
        end

        attack.instance_variables.each do |var|
            if var.to_s != "@pokemon"
                self.instance_variable_set(var, attack.instance_variable_get(var))
            end
        end
        nil
    end

    class AttacksError < StandardError
        def message
            "The input was not a proper instance of the Attacks class"
        end
    end
end
