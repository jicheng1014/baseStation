class WelcomeController < ApplicationController
  def index
    @stations = Station.all.limit(50)
  end
end
