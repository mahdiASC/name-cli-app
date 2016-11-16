require "pry"

class TempAttacks
  attr_accessor :name, :desc, :type, :pp, :power, :acc

  ATTACKTYPES={
    "normal"={
      :immune=>["ghost"],
      :half=>["rock"],
      :double=>[]
    },
    "fire"={
      :immune=>[],
      :half=>["fire","water","rock","dragon"],
      :double=>["grass","ice","bug"]
    },
    "water"={
      :immune=>[],
      :half=>["water","grass","dragon"],
      :double=>["fire","ground","rock"]
    },
    "electric"={
      :immune=>["ground"],
      :half=>["electric","grass","dragon"],
      :double=>["water","flying"]
    },
    "grass"={
      :immune=>[],
      :half=>["fire","grase","poison", "flying", "bug","dragon"],
      :double=>["water", "ground","rock"]
    },
    "ice"={
      :immune=>[],
      :half=>["water","ice"],
      :double=>["grass",'flying','dragon']
    },
    "fighting"={
      :immune=>['ghost'],
      :half=>['poison', 'flying','psychic','bug'],
      :double=>['normal','ice','rock']
    },
    "poison"={
      :immune=>[],
      :half=>['poison','ground','rock','ghost'],
      :double=>['grass','bug']
    },
    "ground"={
      :immune=>['flying'],
      :half=>['grass','bug'],
      :double=>['fire','electric','poison','rock']
    },
    "flying"={
      :immune=>[],
      :half=>['electric','rock'],
      :double=>['grass','poison','bug']
    },
    "psychic"={
      :immune=>[],
      :half=>['psychic'],
      :double=>['fighting','poison']
    },
    "bug"={
      :immune=>[],
      :half=>['fire','fighting','flying','ghost'],
      :double=>['grass','poison','psychic']
    },
    "rock"={
      :immune=>[],
      :half=>['fighting','ground'],
      :double=>['fire','ice','flying','bug']
    },
    "ghost"={
      :immune=>[],
      :half=>[],
      :double=>['ghost']
    },
    "dragon"={
      :immune=>[],
      :half=>[],
      :double=>['dragon']
    }
  }

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

  # Formula
  # https://www.gamefaqs.com/gameboy/367023-pokemon-red-version/faqs/54432


end
