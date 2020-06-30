module Hangman

    class Save_File

    end

    class Letter
        attr_accessor :letter

        def initialize
            puts "Please select a letter to play. Only the first letter will be used."
            @letter = gets.downcase[0]
        end
    
        # def choose_letter
        #     self.letter = gets.downcase[0]
        # end

        def check_if_used(discard_pile)
            if discard_pile[self.letter] == nil
                add_letter_to_discard_pile(letter)
            else
                puts "#{self.letter} has already been tried. Choose again."
                self.letter = gets.downcase[0]
                check_if_used(discard_pile)
            end
        end
    
        def add_letter_to_discard_pile(discard_pile)
            discard_pile[self.letter] = 1
        end


    end

    class Discard
        attr_accessor :discard_pile

        def initialize(args)
            @discard_pile = args[:discard_pile] || {}
        end

    end



end

new_discard = Hangman::Discard.new({})
p new_discard
new_letter = Hangman::Letter.new().check_if_used(new_discard)
p new_letter
p new_discard