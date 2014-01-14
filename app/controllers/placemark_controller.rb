class PlacemarkController < ApplicationController
  def import
    doc= Nokogiri::XML(File.open("/home/atpking/Desktop/google.kml"))
    list = doc.css "Placemark"
    @stations = []

    list.each do |placemark|
      station = Station.new
      placemark.children.each do |item|
        if item.node_name == "name"
          station.name = item.content
        elsif item.node_name == "description"
          station.description = item.content
        elsif item.node_name == "Point"
          points = item.children[1].content.split ","
          station.lng = points[0]
          station.lat = points[1]
        end  
      end
      @stations.push(station)
    end


    if Station.count == 0
      @stations.each do |item|
        item.save
      end
    end
    redirect_to stations_path, notice:"ererf"
  end
end
