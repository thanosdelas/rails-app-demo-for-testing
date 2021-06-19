class ApplicationController < ActionController::Base

  Rails.cache.clear

  # Rails.application.config.middleware.insert_before 0, Rack::Cors do
  #   allow do
  #     origins 'example.com'

  #     resource '*',
  #       headers: :any,
  #       methods: [:get, :post, :put, :patch, :delete, :options, :head]
  #   end
  # end

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

    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, HEAD, PATCH, CONNECT'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    return render json: response
  end

end
