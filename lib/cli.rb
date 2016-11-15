class Pokemon::CLI
  attr_accessor :newGame

  def call


  end

    puts "Welcome to PokemonCLI!"
    puts "You will be given a random party of pokemon to battle with against and AI"

    reply1 = nil
    until !reply1.nil? do
        puts "Would you like to go first? (y)es (n)o"
        reply1 = gets.strip.downcase
        if reply1[0]!="y" && reply1[0]!="n"
            puts "Invalid response!"
            reply1 = nil
        end
    end


        reply2 = nil
        until !reply2.nil? do
            puts "What AI difficulty do you want? (e)asy (h)ard"
            reply2 = gets.strip.downcase
            if reply2[0]!="e" && reply2[0]!="h"
                puts "Invalid response!"
                reply2 = nil
            end
        end

        if reply1[0] == "y"
            player1 = Human.new
            player2 = AI.new(reply2)
        else
            player1 = AI.new(reply2)
            player2 = Human.new
        end
        @newGame = Game.new(player1, player2)
        @newGame
    end

    def play
    end

end
