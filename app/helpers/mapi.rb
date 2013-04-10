module Mapi
  def mapi_coordinate(coordinate)
    output = mapi_begin
    output += "var pos = new Mapi.Loc(#{coordinate.latitude}, #{coordinate.longitude});" +
    "map.setCenter(pos, 16);\n" +
    "var marker = new Mapi.Marker(pos);\n" +
    "map.addMarker(marker);\n"
    output += mapi_end
  end

  def mapi_track(coordinates)
    output = mapi_begin
    output += "var coords = new Array();"
    i = 0;
    coordinates.each {|c|
      output += "coords[#{i+=1}] = new Mapi.Loc(#{c.latitude}, #{c.longitude});\n"
    }
    output += "var route = new Mapi.Route({points: coords});"
    output += "route.show()"
    output += mapi_end
  end

  private

  def mapi_begin
    "<div id='map' style='width:800px; height:450px;'> </div>" +
    "<script type='text/javascript'>" +
    "Mapi.Load({dir:'/assets/mapi/'}, function() {\n" +
    "var map = new Mapi.Map({div:'map'});\n"
  end
	
  def mapi_end
    "});</script>"
  end
end
