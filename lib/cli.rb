class Pokemon::CLI
  attr_accessor :newGame

  def call
    #each player given 6 random pokemon to battle with
    #1 player is Human, other is AI
    #user decides who goes first and what AI difficulty is
    #user has access to Pokedex, Main attacks (out of usable?),
    puts "Welcome to PokemonCLI!"
    puts "You will be given a random party of pokemon to battle with against an AI"
    reply = nil
    until reply == "y"
      diff = nil
      until diff == "e" || diff == "h"
        puts "Set the AI difficulty. (e)asy (h)ard"
        diff = gets.strip.downcase.first
      end

      until reply == "y" || reply == "n"
        puts "Would you like to go first? (y)es (n)o"
        reply = gets.strip.downcase.first
      end

      case reply
      when "y"
        newGame = Game.new(Human.new, AI.new(diff))
        viewPokemon(newGame.player1)
      when "n"
        newGame = Game.new(AI.new(diff),Human.new)
        viewPokemon(newGame.player2)
      end

      until reply == "exit"
        puts "options"
        reply = gets.strip
        case reply
        when
        when
        when
        else
        end

      end
      puts "Would you like to play again? (y)es (n)o"
      reply = gets.strip.downcase.first
    end
    puts "Thanks for playing PokemonCLI. I hope you had fun!"
  end

  def viewPokemon(humanPlayer)
    puts "You have the following pokemon (the first pokemon is your starter):"
    humanPlayer.party.each_with_index{|pokemon, index| puts "##{index}: #{pokemon.name}"}
  end
end
