# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#


window.map = null
circle = null
window.start_point = null
# 单击地图的事件实现函数
click = (e)-> 
  # 先把值读给modal里的坐标
  $("#station_baidu_lat").val(e.point.lat)
  $("#station_baidu_lng").val(e.point.lng)

  point = new BMap.Point(e.point.lng, e.point.lat)
  marker = new BMap.Marker(point)
  map.addOverlay(marker)
  infoWindow = new BMap.InfoWindow """
    <button onclick='$("#myModal").modal();$("#select_pos_type_list").val("baidu_geo");change($("#select_pos_type_list"));' class='add_modal'>新建节点</button>

    <p>此处百度坐标：纬度#{e.point.lat}  经度#{e.point.lng} </p>
    
    <p><button onclick='window.start_point = "#{e.point.lat}-#{e.point.lng}";alert("已设置起点")'>设置此处为起点</button></p>
    """
  marker.openInfoWindow(infoWindow)
  infoWindow.enableCloseOnClick()
  infoWindow.addEventListener("close",(type,t,point) ->
    map.removeOverlay(marker)
  )
  false

# 建设右面的节点信息
build_list=(stations)->
  builder = ''
  for node in stations
    builder += "<li class='li_item' lat='#{node.lat}' lng='#{node.lng}'><a data-remote='true' href='/stations/#{node.id}'>#{node.name}</a></li>"
  $("#station_list").empty().append(builder).css("max_height",500)
  $(".li_item").click ()->
    lng = $(this).attr "lng"
    lat = $(this).attr "lat"
    point = new BMap.Point(lng,lat)
    window.map.removeOverlay(circle)
    circle = new BMap.Circle(point,50);
    window.map.addOverlay(circle)


# 将传进来的station参数显示在地图上以及新建右侧的节点信息
show_stations_data = (stations) -> 
  window.map.clearOverlays()
  if stations.length>100 
    point = window.map.getCenter()     
    label = new BMap.Label("地图间有#{stations.length}个点，超出限制，放大地图后可查看")
    label.setPosition(point)
    window.map.addOverlay(label)
  else
    build_list(stations)
    window.map.addOverlay(circle)
    for node in stations 
      do (node) ->
        point = new BMap.Point(node.lng,node.lat)
        marker = new BMap.Marker(point)
        label = new BMap.Label(node.name, {offset: new BMap.Size(20, 4)})
        marker.setLabel(label)
        
        contextMenu = new BMap.ContextMenu()
        contextMenu.addItem(new BMap.MenuItem("查看 #{node.name} 详情", () ->
          $.get("stations/#{node.id}",(data)->
            eval data # run the js code which ajax callback
          )

        , 200))

        contextMenu.addItem(new BMap.MenuItem("删除 #{node.name} 节点", () ->
          if confirm('确定要删除此节点？')
            $.post("stations/#{node.id}",{"_method":"delete"},()->alert("操作成功，移动地图获得最新数据"))

        , 200))

        contextMenu.addItem(new BMap.MenuItem("导航到此处",(point)->
          if(window.start_point ==null)
            alert("未设置起点，无法导航")
          else
            tmp = window.start_point.split "-"
            start = new BMap.Point(tmp[1], tmp[0])     
            end = "#{point.lat}-#{point.lng}"
            
            window.open("stations/geolocation?start=#{window.start_point}&end=#{end}")
            transit = new BMap.DrivingRoute(window.map,{renderOptions:{map: map, autoViewport: true}})

        ,200))
        window.map.addOverlay(marker)
        marker.addContextMenu(contextMenu)

load_points = ->
  bounds = window.map.getBounds()
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

  window.map = new BMap.Map("map")
  window.map.addControl(new BMap.NavigationControl())  
  window.map.addControl(new BMap.ScaleControl())  
  window.map.addControl(new BMap.OverviewMapControl()) 
  window.map.enableScrollWheelZoom()  
  window.map.addControl(new BMap.MapTypeControl())     
  window.map.centerAndZoom(new BMap.Point(106.539,29.548),13)
  window.map.addEventListener("moveend",load_points)
  window.map.addEventListener("zoomend",load_points)
  window.map.addEventListener("click", click)
  
  load_points()

  $("#name_search").autocomplete(
    source : $("#name_search").data('autocomplete-source'),
    minLength: 3,
    select: (event,ui ) ->
      $.getJSON('stations/search_by_name',{name:$('#name_search').val()},(obj)->
        window.map.setZoom(17)
        window.map.setCenter(new BMap.Point(obj.baidu_lng,obj.baidu_lat))
        node = obj
        point = new BMap.Point(node.baidu_lng,node.baidu_lat)
        circle = new BMap.Circle(point,50);
        window.map.addOverlay(circle)
      )
  )

  ac = new BMap.Autocomplete 
    input: "suggest_pos",
    location: "重庆市"
  ac.addEventListener("onconfirm",(e)->
    _value = e.item.value
    myValue = _value.province +  _value.city +  _value.district +  _value.street +  _value.business
    local = new BMap.LocalSearch(window.map,{
      onSearchComplete: ()->
        window.map.centerAndZoom(local.getResults().getPoi(0).point,17)
    })
    local.search myValue
  )

$(document).ready(ready)
