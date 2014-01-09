json.array!(@stations) do |station|
  json.extract! station, :id, :name, :lat, :lng, :description, :markup
  json.url station_url(station, format: :json)
end
