# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

ready = -> 
  #c.style.height = p.clientHeight - a.clientHeight - b.clientHeight +"px";
  h1_height = $("#welcome_h1").outerHeight(true);
  parent = $("#map_div").parent()
  $("#map_div").height(parent.height()  - h1_height)

  map = new BMap.Map("map")
  map.addControl(new BMap.NavigationControl())  
  map.addControl(new BMap.ScaleControl())  
  map.addControl(new BMap.OverviewMapControl()) 
  map.enableScrollWheelZoom()  
  map.addControl(new BMap.MapTypeControl())     
  map.centerAndZoom("重庆",13)



$(document).ready(ready)
$(document).on('page:load', ready)
