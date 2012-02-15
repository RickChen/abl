class ProductsController < ApplicationController
  before_filter :redirect_bad_user, :only => [:destroy, :edit]
  helper_method :sort_column, :sort_direction 
  
  def index
    @product = Product.new 
    @products = FeedProduct.where("avg_score IS NOT NULL")
    @products = @products.search(params[:search]).order(sort_column+" "+sort_direction).paginate(:per_page => 4, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb 
      format.js
    end
  end

  def show  
    @products = FeedProduct.where("id = ?", params[:id])
  end

  def new
    if current_user
      @product = Product.new
      @product.pid = params[:pid]
      @product.name = params[:product_name]
      @product.user = current_user      
    else
      redirect_to login_path, :notice => "This is member feature only you need to login or sign up first!"
    end
  end

  def create
    @product = Product.new(params[:product])
    @product.user = current_user
    
    feedProductExists = FeedProduct.exists?(:name => params[:product][:name])
    if !feedProductExists
      flash.now[:alert] = "You have not selected a valid product, please try again."
      render :action => 'new'
    elsif @product.save
      redirect_to products_path, :notice => "Thanks! Your review has been added and will be available soon!"
    else
      render :action => 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to edit_product_path(@product), :notice  => "Successfully updated product. Your changes will be reflected soon!"
    else
      render :action => 'edit'
    end
  end

  def destroy 
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_url, :alert => "Successfully removed product. Your changes will be reflected soon!"
  end
  
  private
  
  def sort_column
    Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end
