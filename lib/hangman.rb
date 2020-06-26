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
    attr_accessor :initial_board 
    attr_reader :finished_board
    def initialize(args)
        @finished_board = args[:initial_board] || args[:word].split(//)
        @initial_board = args[:initial_board] || "".rjust(args[:word].length, '_').split(//)
    end

    def add_letter(letter)
        finished_board.each_with_index do |element, index|
            if letter == element
                initial_board[index] = letter
            end
        end
    end

    def check_win
        if finished_board == initial_board
            puts "You win!"
        end
    end
end

class Used_Pile

end

# List of things to serialize
# finished board - gives us the word to complete
# current board - progress
# used letter pile
# number of turns left
# 

# new_word = Word.new(:path => "../dictionary_12.txt", :upper_length_limit => 12, :lower_length_limit => 5).choose_word
# puts new_word

new_board = Hangman_Board.new(:word => Word.new({}).choose_word)
p new_board.finished_board
p new_board.initial_board
new_board.add_letter("p")
new_board.add_letter("a")
new_board.add_letter("l")
new_board.add_letter("e")
new_board.check_win
p new_board.initial_board