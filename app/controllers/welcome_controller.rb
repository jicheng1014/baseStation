class WelcomeController < ApplicationController
  def index
    @stations = Station.all.limit(50).map { |e| {id:e.id,name:e.name,lat:e.baidu_lat,lng:e.baidu_lng } }

     
  end
end
