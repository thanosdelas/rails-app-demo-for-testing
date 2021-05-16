class IndexController < ApplicationController

  def initialize
    super
    @page = "dashboard"
  end

  def index
    # return render plain: session.id
    @domain = request.domain
    return render :template => 'index'
  end
end
