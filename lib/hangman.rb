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
    end

    def save
        puts "enter a name for the save file"
        filename = gets.chomp! + ".txt"
        File.open("saves/#{filename}", "w+") do |file| 
            file.puts "{:finished_board => #{finished_board}, :board => #{board}, :used_letters => #{used_letters}}"
        end
    end
end

class Parse_File
    attr_reader :args
    # filtered_dictionary = File.open("filtered_dictionary.txt", "w+"){
    #     |file| file.puts File.open("dictionary.txt").readlines.map(&strip).select(&between_five_twelve)
    # }
    def initialize(filename)
        @args = eval(File.open("saves/#{filename}.txt").read)
    end

end


class Game
    attr_accessor :load
    def initialize
        @load = false
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
            self.load = true
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

def check_if_exists(file)
    if File.exist?("saves/#{file}")
        return true
    end
    return false
end

def check_if_valid_textfile(file)
    unless file.end_with?(".txt")
        return false
    end
    true
end

def file_validation(file)
    until check_if_valid_textfile(file) == true && check_if_exists(file) == true
        if check_if_valid_textfile(file) == false
            puts "Please input a valid file in the format {filename.txt} or enter exit to go back to the start"
            file = gets.chomp!
            if file == "exit"
                return false
            end
        elsif check_if_exists(file) == false
            puts "Error: File not found."
            puts "Please input a valid file in the format {filename.txt} enter exit to go back to the start"
            file = gets.chomp!
            if file == "exit"
                return false
            end
        end
    end
    true
end


def play_game
    game = Game.new()

    if game.load == true
        puts "Enter the filepath for your save "
        file = gets.chomp!
        if file_validation(file) == false
            play_game
        end



    end

end

# puts check_if_valid_textfile("test.txt")
# puts check_if_exists("test.txt")

# play_game

# new_game = Hangman_Board.new({:word => Word.new({}).choose_word})
# new_used_pile = Used_Pile.new({})
# # p new_game
# new_game.add_letter("l")
# new_used_pile.check_if_used("l")
# p new_game.board
# p new_used_pile.used_letters
# Save_File.new({:board => new_game.board, :finished_board => new_game.finished_board, :used_letters => new_used_pile.used_letters}).save
new_game = Hangman_Board.new(Parse_File.new("apple").args)
p new_game