class SearchController < ApplicationController
  def index
    getImageRoute()
    render json: { }
  end

  @private
  def getImageRoute
    puts request.url
  end
end
