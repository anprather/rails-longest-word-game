require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].upcase

    if !compare?(@word.split(''), @letters.split(''))
      @result = "sorry but #{@word} can't be built out of #{@letters}"
    elsif !check_api?(@word)
      @result = "Sorry, but the word #{@word} does not exist...play again?"
    else
      @result = "Congratulations, you win!"
    end
  end

  def check_api?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result_serialized = open(url).read
    result = JSON.parse(result_serialized)

    result['found']
  end

  def compare?(word, letters)
    word.each do |letter|
      return false if letters.count(letter).zero?
      return false if word.count(letter) > letters.count(letter)
    end
    true
  end
end
