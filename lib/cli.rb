class Pokemon::CLI
  attr_accessor :newGame

  def call
    #each player given 6 random pokemon to battle with
    #1 player is Human, other is AI
    #user decides who goes first and what AI difficulty is
    #user has access to Pokedex, Main attacks (out of usable?),
    system "clear"
    puts "Welcome to PokemonCLI!"
    puts "You will be given a random party of LVL 100 pokemon to battle with against an AI"
    reply = nil
    until reply == "n"
      diff = nil
      until diff == "e" || diff == "h"
        puts "Set the AI difficulty. (e)asy (h)ard"
        diff = gets.strip.downcase[0]
      end

      until reply == "y" || reply == "n"
        puts "Would you like to go first? (y)es (n)o"
        reply = gets.strip.downcase[0]
      end

      case reply
      when "y"
        newGame = Game.new(Human.new, AI.new(diff))
        viewPokemon(newGame.player1)
      when "n"
        newGame = Game.new(AI.new(diff),Human.new)
        viewPokemon(newGame.player2)
      end

      until reply == "e"
        puts "Pick an option: (a)ttack (s)witch (p)okedex (e)xit"
        reply = gets.strip.downcase[0]
        case reply
        when "a"
            puts "a input"
        when "s"
            puts "s input"
        when "p"
            accessPokedex
        end

      end

      until reply == "y" || reply == "n"
          puts "Would you like to play again? (y)es (n)o"
          reply = gets.strip.downcase[0]
      end
    end
    puts "Thanks for playing PokemonCLI. I hope you had fun!"
  end

  def viewPokemon(humanPlayer)
    puts "You have the following pokemon (the first pokemon is your starter):"
    humanPlayer.party.each_with_index{|pokemon, index| puts "##{index+1}: #{pokemon.name}"}
  end

  def accessPokedex
      reply = nil
      until reply == "exit"
          puts "Pokedex Options: Search (p)okemon or (a)ttacks? (exit)"
          reply = gets.strip.downcase[0]
          case reply
          when "a"
              puts "Pokedex: Attacks: Search (n)ame or (t)ype or (d)escription or (show all)? (exit)"

          when "p"
              puts "Pokedex: Pokemon: Search (n)ame or (t)ype or (a)ttack name or (show all)? (exit)"
          end
      end
  end
end
