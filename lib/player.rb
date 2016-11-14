class Player
    attr_accessor :token, :currentPokemon
    attr_reader :party



    def party=(party)
        @party = party
        @currentPokemon = party[0]
    end

    def partyHP
        party.collect {|pokemon| pokemon[:hp]}.reduce(:+)
    end

    def viewParty
        @party.each do |pokemon|
            puts '------------------'
            pokemon.instance_variables.each do |key|
                puts "#{key.to_s.gsub!("@","").upcase}: #{pokemon.instance_variable_get(key)}"
            end
            puts '------------------'
        end
    end
end
