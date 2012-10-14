class TravelsController < ApplicationController

  def create
    @travel = Travel.new()  
  end

end
