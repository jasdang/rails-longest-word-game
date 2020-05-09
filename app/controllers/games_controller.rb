require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ((rand * 25).round + 65).chr
    end
    session[:letters] = @letters
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters]

    dict_url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    @word_data = JSON.parse(open(dict_url).read)

    @result = ''
    if valid_word?(@word_data) && given_letters?(@answer, @letters)
      @result = "Congratulations! #{@answer.upcase} is a valid word."
    elsif !given_letters?(@answer, @letters)
      @result = "Sorry but #{@answer.upcase} can't be built out of #{@letters}."
    elsif !valid_word?(@word_data)
      @result = "Sorry but #{@answer.upcase} does not seem to be a valid English
       word."
    end
    @test = session[:letters]
  end

  private

  def valid_word?(hash)
    hash['found'] == true
  end

  def given_letters?(word, array)
    letters = word.split(//)
    letters.all? { |letter| array.include?(letter.upcase) }
  end
end
