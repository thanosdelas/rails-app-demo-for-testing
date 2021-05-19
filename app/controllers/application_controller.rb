class ApplicationController < ActionController::Base

  Rails.cache.clear

  def initialize
    super
    # self.response = {}
    @site_url = "http://localhost:3000"   
    @page = "not set"
  end

  # You can also use 
  # before_action :set_global_variables
  def set_global_variables
    @site_url = "localhost:3000"
    @page = "not set"
  end

  def json(data)

    response = {
      status: "ok",
      message: "success",
      data: data
    }

    return render json: response
  end

end
