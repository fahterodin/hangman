# randomly select a word between 5 and 12 character long

# create class game
#   initialize
#     @secrete_word = select a random word from dictionary
#     start the round
#
#   round
#     show an array with _ equal the lenght of the secret
#     gets.chomp
#     compare the @secret_word with the input_word
#     update the guesses_count
#     start another round until count equal 8   
# 
#   compare
#     both words to array
#     compare each letter one by one
#       if they are equal push it to another array
#       else push a _

require 'yaml'

class Game
  words = File.readlines('google-10000-english-no-swears.txt')
  @@dictionary = Array.new(0)
  @@count = 1

  words.each do |word|
    word = word.chomp
    @@dictionary << word if word.length > 4 && word.length < 13
  end

  def initialize
    puts 'Would you like to load the game? y/n'
    return from_yaml if gets.chomp == 'y'

    @secret_word = @@dictionary.sample.split('')
    @guess_word = Array.new(@secret_word.length) { |v| v = '_' }
    round
  end

  private

  def round
    return puts " You lose! The secret word was #{@secret_word.join()}" if @@count == 9

    puts " Guess number #{@@count}"
    display_guess
    puts ' Choose a letter | Press 1 to save the game'
    input_letter = gets.chomp.downcase
    return to_yaml if input_letter == '1'

    compare(input_letter)
    display_guess
    @@count += 1
    round
  end

  def compare(input_letter)
    @secret_word.each_with_index do |letter, idx|
      if letter == input_letter
        @guess_word[idx] = letter
      end
    end
    if @secret_word == @guess_word
      puts " You win! The secret word was #{@secret_word.join()}"
    end
  end

  def display_guess
    @guess_word.each { |v| print " #{v}" }
    2.times { puts '' }
  end

  def to_yaml
    f = File.open('dump.yml', 'w')
    YAML.dump({
      secret_word: @secret_word,
      guess_word: @guess_word,
      count: @@count
    }, f)
    f.close
  end

  def from_yaml
    data = YAML.load(File.read('dump.yml'))
    @secret_word = data[:secret_word]
    @guess_word = data[:guess_word] 
    @@count = data[:count]
    round
  end
end

Game.new

# make an option at the start of the turn that ask to save the game
# make an option at the start of the game to ask to load the previos game
