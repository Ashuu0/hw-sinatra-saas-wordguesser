class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)
    raise ArgumentError, 'input single letter!' unless letter.is_a?(String) && letter.length == 1 && letter.match?(/[[:alpha:]]/ )
    letter.downcase!

    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.include?(letter) and !@guesses.include?(letter)
      @guesses += letter
      true
    elsif !@word.include?(letter) && !@guesses.include?(letter)
      @wrong_guesses += letter
      true
    end
  end

  def word_with_guesses
    result = ""
    @word.each_char do |letter|
      if @guesses.include?(letter)
        result = (result + letter) 
      else
        result = (result + '-')
      end
    end
    return result
    
  end

  def check_win_or_lose
    counter = 0

    return :lose if @wrong_guesses.length >= 7

    @word.each_char do |letter|
      counter = counter+1 if @guesses.include? letter
    end
    if counter == @word.length then 
      :win
    else 
      :play 
    end
  end

end