# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

new_modal= ()->
  $('#myModal').modal(keyboard: false)
 
loadPointToModal = (point) ->
  $('#station_name').val()

map = null
click = (e)-> 
  # 先把值读给modal里的坐标
  $("#station_lat").val(e.point.lat)
  $("#station_lng").val(e.point.lng)

  point = new BMap.Point(e.point.lng, e.point.lat)
  marker = new BMap.Marker(point)
  map.addOverlay(marker)
  infoWindow = new BMap.InfoWindow("<button onclick='$(\"#myModal\").modal()' class='add_modal'>新建节点</button>")
  marker.openInfoWindow(infoWindow)
  infoWindow.enableCloseOnClick()
  infoWindow.addEventListener("close",(type,t,point) ->
    map.removeOverlay(marker)
  )
  false


build_list=(stations)->
  builder = ''
  for node in stations
    builder += "<li><a data-remote='true' href='/stations/#{node.id}'>#{node.name}</a></li>"
  $("#station_list").empty().append(builder).css("max_height",500)


show_stations_data = (stations) -> 
  map.clearOverlays()
  if stations.length>150 
    point = map.getCenter()     
    label = new BMap.Label("地图间有#{stations.length}个点，超出限制，放大地图后可查看")
    label.setPosition(point)
    map.addOverlay(label)
  else
    build_list(stations)
    for node in stations 
      point = new BMap.Point(node.lng,node.lat)
      marker = new BMap.Marker(point)
      label = new BMap.Label(node.name, {offset: new BMap.Size(20, 4)})

      marker.setLabel(label)
      map.addOverlay(marker)


load_points = ->
  bounds = map.getBounds()
  min_lat = [bounds.getSouthWest().lat]
  min_lng = [bounds.getSouthWest().lng]

  max_lat = [bounds.getNorthEast().lat]
  max_lng = [bounds.getNorthEast().lng]
  
  $.getJSON("/stations",{min_lat,min_lng,max_lat,max_lng},(stations)->
    show_stations_data(stations)
  )


ready = -> 
  # calculate the height of this page
  h1_height = $("#welcome_h1").outerHeight(true);
  parent = $("#map_div").parent()
  $("#map_div").height(parent.height()  - h1_height)

  map = new BMap.Map("map")
  map.addControl(new BMap.NavigationControl())  
  map.addControl(new BMap.ScaleControl())  
  map.addControl(new BMap.OverviewMapControl()) 
  map.enableScrollWheelZoom()  
  map.addControl(new BMap.MapTypeControl())     
  map.centerAndZoom(new BMap.Point(106.539,29.548),13)
  map.addEventListener("moveend",load_points)
  map.addEventListener("zoomend",load_points)
  map.addEventListener("click", click);
  load_points()
 
  

$(document).ready(ready)
