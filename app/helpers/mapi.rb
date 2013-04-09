module Mapi
	def mapi_coordinate(coordinate)
		output = mapi_begin
		output += "var map = new Mapi.Map({div:'map'});\n" +
		"var pos = new Mapi.Loc(#{coordinate.latitude}, #{coordinate.longitude});" +
		"map.setCenter(pos, 16);\n" +
		"var marker = new Mapi.Marker(pos);\n" +
		"map.addMarker(marker);\n"
		output += mapi_end
	end

	private

	def mapi_begin
		"<div id='map' style='width:800px; height:450px;'> </div>" +
		"<script type='text/javascript'>" +
		"Mapi.Load({dir:'/assets/mapi/'}, function() {\n"
	end
	
	def mapi_end
		"});</script>"
	end
end
