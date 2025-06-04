require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split

    @total_score = session[:total_score] || 0

    if !included_in_grid?(@word, @letters)
      @message = "The word can't be built out of the original grid."
      @score = 0
    elsif !english_word?(@word)
      @message = "The word is in the grid but not a valid English word."
      @score = 0
    else
      @message = "Well done!"
      @score = @word.length

      session[:total_score] ||= 0
      session[:total_score] += @score
      @total_score = session[:total_score]
    end
  end
end

private

def included_in_grid?(word, grid)
  word.upcase.chars.all? do |letter|
    word.upcase.count(letter) <= grid.count(letter)
  end
end

def english_word?(word)
  url = "https://dictionary.lewagon.com/#{word.downcase}"
  response = URI.open(url).read
  json = JSON.parse(response)
  json['found']
end
