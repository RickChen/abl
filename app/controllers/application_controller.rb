class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery
  
  def index
  end
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
