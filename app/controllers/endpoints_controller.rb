class EndpointsController < ApplicationController
  respond_to :json
  def getProductNames
    searchTerm = params[:term].split(" ")
    #This is inefficient, how can we make this better?
      @products_fulltext = FeedProduct.search_by_name(params[:term])
      @products_auto = FeedProduct.where("name ILIKE ?", "%#{params[:term]}%")
      respond_with(@products_auto+@products_fulltext)
  end
  
end
