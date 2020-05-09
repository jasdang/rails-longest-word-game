class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ((rand * 25).round + 65).chr
    end
  end
  def score
  end
end
