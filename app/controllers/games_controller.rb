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

  def compute_score
    answer = params[:answer]
    letters = session[:letters]
    dict_url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    word_data = JSON.parse(open(dict_url).read)

    if valid_word?(word_data) && given_letters?(answer, letters)
      session[:result] = "Congratulations! #{answer.upcase} is a valid word."
      session[:score] = scoring(answer)
    elsif !given_letters?(answer, letters)
      session[:result] = "Sorry but #{answer.upcase} can't be built out of #{letters}."
      session[:score] = 0
    elsif !valid_word?(word_data)
      session[:result] = "Sorry but #{answer.upcase} does not seem to be a valid English
       word."
      session[:score] = 0
    end

    redirect_to score_path
  end

  def score
    @result = session[:result]
    @score = session[:score]
  end

  private

  def valid_word?(hash)
    hash['found'] == true
  end

  def given_letters?(word, array)
    letters = word.split(//)
    letters.all? { |letter| array.include?(letter.upcase) }
  end

  def scoring(word)
    (word.length + 5) ** 3
  end
end
