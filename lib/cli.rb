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
        reply = nil
      diff = nil
      until diff == "e" || diff == "h"
        puts "Set the AI difficulty. (e)asy (h)ard"
        diff = gets.strip.downcase[0]
      end

      until reply == "y" || reply == "n"
        puts "Would you like to go first? (y)es (n)o"
        reply = gets.strip.downcase[0]
      end

      system "clear"
      puts "Setting up game. Please wait..."
      case reply
      when "y"
        newGame = Game.new(Human.new, AI.new(diff))
        system "clear"
        viewPokemon(newGame.player1)
      when "n"
        newGame = Game.new(AI.new(diff),Human.new)
        system "clear"
        viewPokemon(newGame.player2)
      end

      until reply == "e" || newGame.over?
          if newGame.currentPlayer.is_a?(AI)
              #AI logic goes here
          else #human player has UI
              puts "=================================================="
              puts "ENEMY POKEMON: #{newGame.aiPlayer.currentPokemon} | HP: #{newGame.aiPlayer.currentPokemon.hp}"
              puts "CURRENT POKEMON: #{newGame.humanPlayer.currentPokemon} | HP: #{newGame.humanPlayer.currentPokemon.hp}"
              puts "Pick an option: (a)ttack (s)witch (p)okedex (e)xit"
              reply = gets.strip.downcase[0]
              case reply
              when "a"
                  startAttack(newGame)
              when "s"
                  switchPokemon(newGame)
              when "p"
                  accessPokedex
              end
          end
      end

      until reply == "y" || reply == "n"
          puts "Would you like to play again? (y)es (n)o"
          reply = gets.strip.downcase[0]
      end
    end
    puts "Thanks for playing PokemonCLI. I hope you had fun!"
  end

  def startAttack(game)
      #add Ruby sleep 1

      #Check if attacks are able to be used (PPs avail) use struggle in place of real move and cut option to pick attack
      if game.humanPlayer.currentPokemon.totalPP == 0
          puts "#{game.humanPlayer.currentPokemon.name.upcase} is out of moves!"
          puts "#{game.humanPlayer.currentPokemon.name.upcase} used STRUGGLE!"
          struggle = TempAttacks.new(Attacks.find_by_name("struggle"))
          struggle.makeAttack(game.humanPlayer,game.aiPlayer)
          game.addTurn
      else
          minorView(game.humanPlayer.currentPokemon)
          reply = nil
          until reply == "back" || reply == "exit"
              puts "What will #{game.humanPlayer.currentPokemon.name.upcase} do? (1-#{game.humanPlayer.currentPokemon.moveset.size}) (back)"
              #What if out of PP?
              reply = gets.strip.downcase
              if (1..game.humanPlayer.currentPokemon.moveset.size).to_a.include?(reply.to_i)
                  if game.humanPlayer.currentPokemon.moveset[reply.to_i-1].pp.to_i == 0
                      puts "That move does not have enough Power Points (PP)"
                  else
                      puts "#{game.humanPlayer.currentPokemon.name.upcase} used #{game.humanPlayer.currentPokemon.moveset[reply.to_i-1].name.upcase}!"
                      attackOutput = game.humanPlayer.currentPokemon.moveset[reply.to_i-1].makeAttack(game.humanPlayer,game.aiPlayer) #this returns a string or array of what happens
                      game.addTurn
                      if attackOutput.is_a?(String)
                          if attackOutput == "miss"
                              puts "The attack missed!"
                          elsif attackOutput == "lazy"
                              puts "The programmer was too lazy to program this attack! Pick antoher one!"
                              game.humanPlayer.currentPokemon.moveset.slice!(reply.to_i-1)
                          end
                      elsif attackOutput.is_a?(Hash)
                          # [critical multiplyer, type multiplier]
                          if attackOutput[:crit]>1 || attackOutput[:typeMult]!=1
                            message = attackOutput[:crit]>1 ? "A critical hit!": ""
                            message += attackOutput[:typeMult]>1 ? " It's super effective!" : attackOutput[:typeMult]<1 "It's not very effective..." : ""
                            puts message
                          end
                      end
                  end
              end
          end
      end
  end

  def viewPokemon(humanPlayer)
    puts "You have the following pokemon (the first pokemon is your starter):"
    humanPlayer.party.each_with_index{|pokemon, index| puts "##{index+1}: #{pokemon.name}"}
  end

  def switchPokemon(game)
      puts "#####################"
      puts "Your Party:"
      partyView(game.humanPlayer)
      puts "#####################"

      reply = nil
      until reply == "back" || reply == "exit"
          puts "Which pokemon do you want to switch to (1-6)? (back)"
          reply = gets.strip.downcase
          case reply.to_i
          when 1,2,3,4,5,6
              if validSwitch?(game.humanPlayer, reply.to_i-1)
                  puts "Come back #{game.humanPlayer.currentPokemon.name}! Go, #{game.humanPlayer.party[reply.to_i-1].name}!"
                  game.humanPlayer.changePokemon(reply.to_i)
                  game.addTurn
                  reply = "exit"
              else
                  puts "That pokemon is already out!"
              end
          end
      end
  end

  def validSwitch?(player, index)
      player.currentPokemon != player.party[index]
  end

  def partyView(player)
      player.party.each_with_index do |poke, index|
          if poke.hp.to_i == 0
              status = "'Fainted!'"
          elsif poke == player.currentPokemon
              status = "'Already out'"
          else
              status = "'OK'"
          end
          puts "##{index+1} #{poke.name} | STATUS #{status} | TYPE: #{poke.type.join(" + ")} | HP:#{poke.hp} | ATK: #{poke.atk} | DEF: #{poke.def} | SPECIAL: #{poke.spec} | SPD: #{poke.spd}"
      end
  end

  def accessPokedex
      reply = nil
      until reply == "exit"
          puts "Pokedex Options: Search (p)okemon or (a)ttacks? (exit)"
          reply = gets.strip.downcase
          case reply
          when "a","attacks"
              pokeReply = nil
              until pokeReply == "exit"
                  puts "Pokedex: Attacks: Search (n)ame or (t)ype or (d)escription or (show all)? (exit)"
                  pokeReply = gets.strip.downcase
                  case pokeReply
                  when "n",'name'
                      puts "Type a name to search Pokedex: Attacks"
                      putsAttacks(gets, "name")
                  when "t",'type'
                      puts "Type a type to search Pokedex: Attacks"
                      putsAttacks(gets, "type")
                  when "d",'description'
                      puts "Type a word or phrase to search Pokedex: Attacks"
                      putsAttacks(gets, "desc")
                  when "show all"
                  end
              end
          when "p", "pokemon"
              pokeReply = nil
              until pokeReply == "exit" #BACK INSTEAD OF EXIT
                  puts "Pokedex: Pokemon: Search (n)ame or (t)ype or (a)ttack name or (show all)? (exit)"
                  pokeReply = gets.strip.downcase
                  case pokeReply
                  when "n",'name'
                      puts "Type a name to search Pokedex: Pokemon"
                      putsPokemon(gets, "name")
                  when "t",'type'
                      puts "Type a type to search Pokedex: Pokemon"
                      putsPokemon(gets, "type")
                  when "a",'attack', 'attack name'
                      puts "Type an attack name to search Pokedex: Pokemon"
                      putsPokemon(gets, "moveset")
                  when "show all"
                      putsPokemon("", "showAll")
                  end
              end
          end
      end
  end


  def putsAttacks(search, category)
      if category == "showAll"
          attackList = Attacks.all
      else
          attackList = Attacks.find_by(search, category)
      end
      if attackList.size <1
          puts "!!!Could not find in Pokedex!!!"
      else
          attackList.each_with_index do |attack,index|
              puts "##{index+1} #{attack.name}:: TYPE: #{attack.type} POWER: #{attack.power} ACC: #{attack.acc} PP: #{attack.pp}"
          end
          reply = nil
          until reply == "exit"
              puts "Select from the list of attacks (from 1-#{attackList.size}) to learn more. (exit)"
              reply = gets.downcase.strip
              if reply != "exit"
                  fullView(attackList[reply.to_i-1])
              end
          end
      end
  end

  def putsPokemon(search, category)
      if category == "showAll"
          puts "ALL POKEMON (in order of highest combined stats):"
          pokeList = Pokemon.all
      else
          pokeList = Pokemon.find_by(search, category)
      end
      if pokeList.size <1
          puts "!!!Could not find in Pokedex!!!"
      else
          pokeList.each_with_index do |poke,index|
              # binding.pry
              puts "##{index+1} #{poke.name}:: TYPE: #{poke.type.join(" + ")} HP:#{poke.hp} ATK: #{poke.atk} DEF: #{poke.def} SPECIAL: #{poke.spec} SPD: #{poke.spd}"
          end
          reply = nil
          until reply == "exit"
              puts "Select from the list of pokemon (from 1-#{pokeList.size}) to learn more. (exit)"
              reply = gets.downcase.strip
              if reply != "exit"
                  fullView(pokeList[reply.to_i-1])
              end
          end
      end
  end

  def minorView(pokemon)
      puts '^^^^^^^^^^^^^^^^^^'
      puts "NAME: #{pokemon.name.upcase}"
      puts '------------------'
      pokemon.moveset.each do |move|
          puts "#{move.name} | TYPE: #{move.type} | PP: #{move.pp}" + move.pp == 0 ? " | 'OUT OF PP!'" : ""
      end
      puts '------------------'
  end

  def fullView(obj)
      puts '^^^^^^^^^^^^^^^^^^'
      puts "NAME: #{obj.name.upcase}"
      puts '------------------'
      obj.instance_variables.drop_while{|item| item == :@name}.each do |item|
          case item
          when :@pokemon
              #Only for attacks
              puts "POKEMON with this attack: #{obj.pokemon.join(", ")}"
          when :@moveset
              #Only for pokemon
              puts "ATTACKS:"
              obj.moveset.moves.each do |move|
                #   binding.pry
                  puts "#{move[1][:move].name} | LVL: #{move[1][:level]} | TYPE: #{move[1][:move].type} | POWER: #{move[1][:move].power} | ACC: #{move[1][:move].acc} | PP: #{move[1][:move].pp}"
              end
          when :@type
              puts "#{item.to_s.gsub!("@","").upcase}: #{obj.instance_variable_get(item).join(" + ")}"
          else
              puts "#{item.to_s.gsub!("@","").upcase}: #{obj.instance_variable_get(item)}"
          end
      end
      puts '^^^^^^^^^^^^^^^^^^'
  end
end
