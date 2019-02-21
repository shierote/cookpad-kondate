class ApplicationController < ActionController::Base
before_action :set_search_value
  def set_search_value
    @initial_value = params["q"] if params["q"]
  end

end
