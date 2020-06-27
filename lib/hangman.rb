# Get a word from a dictionary that is between a lower limit and upper limit in length
class Word
    attr_reader :dictionary, :upper_length_limit, :lower_length_limit
    attr_accessor :word

    def initialize(args)
        # if File.exist?("#{args[:path]}")
        #     @dictionary = File.open("#{args[:path]}").readlines
        # else 
        #     @dictionary =  File.open("../dictionary.txt").readlines
        # end
        @dictionary = ["Apple"]
        @upper_length_limit = args[:upper_length_limit] || 12
        @lower_length_limit = args[:lower_length_limit] || 5
        @word = ""
    end

    def choose_word
        self.word = ""
        until (word.length >= self.lower_length_limit && word.length <= self.upper_length_limit)
            random_number = rand(dictionary.length - 1)
            self.word = dictionary[random_number].to_s.strip.downcase
        end
        self.word
    end
end

class Hangman_Board
    attr_accessor :board 
    attr_reader :finished_board
    def initialize(args)
        @finished_board = args[:finished_board] || args[:word].split(//)
        @board = args[:board] || "".rjust(args[:word].length, '_').split(//)
    end

    def add_letter(letter)
        finished_board.each_with_index do |element, index|
            if letter == element
                board[index] = letter
            end
        end
    end

    def check_win
        if finished_board == board
            puts "You win!"
        end
    end
end

class Used_Pile
    attr_accessor :used_letters

    def initialize(args)
        @used_letters = args[:used_letters] || {} 
    end

    def check_if_used(letter)
        if used_letters[letter] == nil
            add_letter(letter)
        else
            puts "#{letter} has already been tried. Choose again."
        end
    end

    private

    def add_letter(letter)
        used_letters[letter] = 1
    end

    
end

class Save_File
    attr_reader :used_letters, :board, :finished_board

    def initialize(args)
        @used_letters = args[:used_letters] 
        @board = args[:board]
        @finished_board = args[:finished_board]
        @turn = used_letters.size
    end
end

# "Welcome to hangman"

class Game
    def initialize
        self.start_game
    end

    def start_game 
        puts "Welcome to hangman!"
        puts "Would you like to load a previous save file? [y/n] "
        choice = gets.chomp!.downcase
        until choice == "y" || choice == "n"
            puts "Please use a valid input. "
            choice = gets.chomp!.downcase
        end
        if choice == "y"
            puts "you chose yes"
        else
            puts "you chose no"
        end
    end


end

def turn_counter
    ["The executioner wakes you up and binds your hands.",
    "You are led out of your cell and into the town's square",
    "The crowd jeers when you start walking up the gallows' thirteen steps",
    "You take your place below the noose and gaze into the crowd. There's not a friend amongst them.",
    "The executioner puts the noose around your neck.",
    "You prepare yourself and are ready to die. One more moment and it will be over",
    "The executioner pulls the lever, your body drops and your neck breaks. It is game over"]
end

game = Game.new()

puts turn_counter[0]
