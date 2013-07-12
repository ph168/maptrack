var MapView = function() {

	this.map = new OpenLayers.Map ({
		controls:[
			new OpenLayers.Control.Navigation(),
			new OpenLayers.Control.PanZoomBar(),
			new OpenLayers.Control.Attribution()],
		maxExtent: new OpenLayers.Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34),
		maxResolution: 156543.0399,
		numZoomLevels: 19,
		zoom: 16,
		units: 'm',
		projection: new OpenLayers.Projection("EPSG:900913"),
		displayProjection: new OpenLayers.Projection("EPSG:4326")
	});

	layerMapnik = new OpenLayers.Layer.OSM.Mapnik("Mapnik");
	this.map.addLayer(layerMapnik);

	//layerCycleMap = new OpenLayers.Layer.OSM.CycleMap("CycleMap");
	//this.map.addLayer(layerCycleMap);

	layerMarkers = new OpenLayers.Layer.Markers("Current position");
	this.map.addLayer(layerMarkers);

	this.setContainer = function(div) {
		this.map.render(div);
	}

	this.addGPXLayer = function(gpxURL, name) {
		var refreshStrategy = new OpenLayers.Strategy.Refresh({
			interval: 2000,
			force: true
		});
		var lgpx = new OpenLayers.Layer.Vector(name, {
			strategies: [
				new OpenLayers.Strategy.Fixed(),
				refreshStrategy],
			protocol: new OpenLayers.Protocol.HTTP({
				url: gpxURL,
				format: new OpenLayers.Format.GPX()
			}),
			style: {strokeColor: "green", strokeWidth: 5, strokeOpacity: 0.5},
			projection: new OpenLayers.Projection("EPSG:4326")
		});

		// Live view
		/*lgpx.events.register("featureadded", lgpx, function(f) {
			var components = f.feature.geometry.components;
			this.map.setCenter(components[components.length - 1].getBounds().getCenterLonLat(), this.map.getZoom());
		});*/
		// Full view
		/*lgpx.events.register("changelayer", lgpx, function(f) {
			this.map.zoomToExtent(lgpx.getDataExtent());
		});*/

		this.map.addLayer(lgpx);
		//this.map.zoomToExtent(lgpx.getDataExtent());
	}
}
