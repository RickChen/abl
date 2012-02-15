class FeedProductsController < ApplicationController
#  before_filter :redirect_bad_user
  helper_method :sort_column, :sort_direction 
  
  def index
  end

  def show
    @products = FeedProduct.where("id = ?", params[:id])
  end

  def new
  end

  def create
  end

  def edit

  end

  def update

  end

  def destroy 
  end
end
