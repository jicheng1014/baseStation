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
  map.addEventListener("click", click);

  


  for node in idata 
    point = new BMap.Point(node.lng,node.lat)
    marker = new BMap.Marker(point)
    map.addOverlay(marker)

$(document).ready(ready)
