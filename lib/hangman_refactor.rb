# Parse_File.new("apple").args
# module Hangman

# end
require 'pry'

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
            self.load = true
        else
            self.load = false
        end
    end
end

class GameState
    attr_accessor :finished_board, :board, :used_letters, :word, :turn, :solve_attempts
    def initialize(args)
        unless args[:word] == nil
            @word = args[:word] || Word.new({}).choose_word
            @finished_board =  word.split(//)
            @board = "".rjust(word.length, '_').split(//)
            @used_letters = {} 
            @solve_attempts = {}
            @turn = 0
        else
            @finished_board = Finished_Board.new(args[:finished_board]).finished_board
            @board = Board.new(args[:board]).board
            @used_letters = Used_Pile.new(args[:used_letters]).used_letters || {}
            @solve_attempts = Solves.new(args[:solve_attempts]).solve_attempts || {}
            @turn = used_letters.length + solve_attempts.length
        end
    end

    def play_save_solve
        puts "Type a letter to play, type save to save game, type solve to attempt to solve"
        user_input = gets.chomp!.downcase
        if user_input == "save"
            Save_File.new({:board => self.board, :finished_board => self.finished_board, :used_letters => self.used_letters}).save
        elsif user_input == "solve"
            self.user_attempts_solve
        else
            user_plays_letter(user_input)
        end
    end

    def user_attempts_solve
        solve_attempt = gets.chomp!.downcase
        self.solve_attempts[solve_attempt] = 1
        solve_attempt = solve_attempt.split(//)
        if solve_attempt == self.finished_board
            self.board = self.finished_board
            self.check_win
        else
            puts "That is not correct"
        end
    end

    def user_plays_letter(user_input)
        letter = user_input[0]
        check_if_used(letter)
    end

    def check_win
        if self.finished_board == self.board
            puts "You win!"
            exit
            return true
        end
        return false
    end

    def check_loss
        if self.turn == 7
            puts "You lose!"
            return true
        end
        return false
    end

    def increment_turn
        self.turn += 1
    end

    private

    def check_if_used(letter)
        if self.used_letters[letter] == nil
            add_letter_to_pile(letter)
            add_letter_to_board(letter)
        else
            puts "#{letter} has already been tried. Choose again."
            letter = gets.downcase[0]
            check_if_used(letter)
        end
    end

    def add_letter_to_pile(letter)
        self.used_letters[letter] = 1
    end

    def add_letter_to_board(letter)
        self.finished_board.each_with_index do |element, index|
            if letter == element
                self.board[index] = letter
            end
        end
    end

    
end




# Get a word from a dictionary that is between a lower limit and upper limit in length
class Word
    attr_reader :dictionary, :upper_length_limit, :lower_length_limit
    attr_accessor :word

    def initialize(args)
        if File.exist?("#{args[:path]}")
            @dictionary = File.open("#{args[:path]}").readlines
        else 
            @dictionary =  File.open("dictionary.txt").readlines
        end
        # @dictionary = ["Apple"]
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

class Finished_Board
    attr_reader :finished_board
    def initialize(args)
        @finished_board = args[:finished_board] 
    end
end

class Board
    attr_reader :board 
    def initialize(args)
        @board = args[:board] 
    end
end

class Used_Pile
    attr_accessor :used_letters
    def initialize(args)
        @used_letters = args[:used_letters] || {}
    end
end

class Solves
    attr_accessor :solve_attempts
    def initialize(args)
        @solve_attempts = args[:solve_attempts] || {}
    end
end

class Save_File
    attr_reader :used_letters, :board, :finished_board, :solve_attempts

    def initialize(args)
        @used_letters = args[:used_letters] 
        @board = args[:board]
        @finished_board = args[:finished_board]
        @solve_attempts = args[:solve_attempts]
    end

    def save
        puts "enter a name for the save file"
        filename = gets.chomp! + ".txt"
        File.open("saves/#{filename}", "w+") do |file| 
            file.puts "{:finished_board => #{finished_board}, :board => #{board}, :used_letters => #{used_letters} :solve_attempts => #{solve_attempts}}"
        end
    end
end

class Parse_File
    attr_reader :args
    def initialize(filename)
        # binding.pry
        @args = eval(File.open("saves/#{filename}").read)
    end

end




def turn_counter
    ["[0] You are having a bad dream, like this might be the last day of your life.",
    "[1] The executioner wakes you up and binds your hands.",
    "[2] You are led out of your cell and into the town's square",
    "[3] The crowd jeers when you start walking up the gallows' thirteen steps",
    "[4] You take your place below the noose and gaze into the crowd. There's not a friend amongst them.",
    "[5] The executioner puts the noose around your neck.",
    "[6] You prepare yourself and are ready to die. One more moment and it will be over",
    "[7] The executioner pulls the lever, your body drops and your neck breaks. It is game over"]
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
        load_file = Parse_File.new(file).args
        new_game = GameState.new({:finished_board => load_file, :board => load_file, :used_letters => load_file, :solve_attempts => load_file}) 
    else
        new_game = GameState.new({:word => Word.new({}).choose_word})
        puts "I have chosen a word with #{new_game.word.length} letters."
    end

    game_loop(new_game)

    # game loop
    # choose a letter

    # do you wish to save

end

def game_loop(game)
    until game.check_win == true
        puts turn_counter[game.turn]
        if game.check_loss == true
            exit
        end
        game.play_save_solve
        game.increment_turn
        puts game.board.join
    end
end



# puts check_if_valid_textfile("test.txt")
# puts check_if_exists("test.txt")

play_game

# new_game = Board.new({:word => Word.new({}).choose_word})
# new_used_pile = Used_Pile.new({})
# # p new_game
# new_game.add_letter("l")
# new_used_pile.check_if_used("l")
# p new_game.board
# p new_used_pile.used_letters
# Save_File.new({:board => new_game.board, :finished_board => new_game.finished_board, :used_letters => new_used_pile.used_letters}).save
# load_file = Parse_File.new("apple").args
# new_game = GameState.new({}) 
# fboard = Finished_Board.new({:word => Word.new({}).choose_word})
