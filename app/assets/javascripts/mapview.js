var MapView = function(varName) {

	map = new OpenLayers.Map ({
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
	map.addLayer(layerMapnik);

	layerMarkers = new OpenLayers.Layer.Markers("Current position");
	map.addLayer(layerMarkers);

	this.setMapContainer = function(id) {
		map.render(id);
	}

	this.updateSize = function() {
		map.updateSize();
	}

	trackList = null;
	trackList_liClass = null;

	this.setMenuContainer = function(id, ulClass, liClass) {
		var menuContainer = $("#"+id);

		trackList = $(document.createElement("ul"));
		trackList.addClass(ulClass);
		menuContainer.append(trackList);
		trackList_liClass = liClass;
	}

	tracks = new Array();
	liveViewTrack = null;
	colors = ["red", "blue", "green", "orange", "purple", "yellow"];
	nextColorIdx = 0;

	this.addTrack = function(gpxURL, name) {

		var duplicate = false;
		$.each(tracks, function(key, track) {
			if (gpxURL == track.protocol.url) {
				duplicate = true;
				return false;
			}
		});
		if (duplicate)
			return;

		var refreshStrategy = new OpenLayers.Strategy.Refresh({
			interval: 2000,
			force: true
		});

		var color = colors[(nextColorIdx++) % colors.length];

		var lgpx = new OpenLayers.Layer.Vector(name, {
			strategies: [
				new OpenLayers.Strategy.Fixed(),
				refreshStrategy],
			protocol: new OpenLayers.Protocol.HTTP({
				url: gpxURL,
				format: new OpenLayers.Format.GPX()
			}),
			style: {strokeColor: color, strokeWidth: 5, strokeOpacity: 0.5},
			projection: new OpenLayers.Projection("EPSG:4326")
		});

		tracks.push(lgpx);
		map.addLayer(lgpx);
		if (liveViewTrack == null)
			setLiveView(lgpx);
		updateTrackList();
	}

	this.removeTrack = function(gpxURL) {
		$.each(tracks, function(key, track) {
			if (gpxURL == track.protocol.url) {
				tracks.splice(key, 1);
				map.removeLayer(track);
				if (track == liveViewTrack)
					setLiveView(tracks[0]);
				return false;
			}
		});
		updateTrackList();
	}

	this.liveViewFor = function(gpxURL) {
		var changed = false;
		$.each(tracks, function(key, track) {
			if (gpxURL == track.protocol.url) {
				setLiveView(track);
				changed = true;
				return false;
			}
		});
		if (!changed) {
			setLiveView(null);
		}
		updateTrackList();
	}

	doLiveView = function(f) {
		var components = f.feature.geometry.components;
		map.setCenter(components[components.length - 1].getBounds().getCenterLonLat(), map.getZoom());
	}

	function setLiveView(track) {
		if (liveViewTrack != null) {
			liveViewTrack.events.unregister("featureadded", liveViewTrack, doLiveView);
		}
		if (track == null) {
			liveViewTrack = null;
		} else {
			track.events.register("featureadded", track, doLiveView);
			liveViewTrack = track;
		}
	}

	function updateTrackList() {
		trackList.text("");
		$.each(tracks, function(key, track) {
			var li = $(document.createElement("li"));
			li.addClass(trackList_liClass + " background-" + track.style.strokeColor);
			if (track == liveViewTrack) {
				li.append(
					$(document.createElement("span"))
					.addClass("icon icon-magnet")
					.attr("title", "Live view active, click to disable.")
					.attr("onClick", varName + ".liveViewFor(null)")
					.css("cursor", "pointer")
				);
			} else {
				li.append(
					$(document.createElement("span"))
					.addClass("icon icon-stop")
					.attr("title", "Live view not active, click to enable.")
					.attr("onClick", varName + ".liveViewFor('" + track.protocol.url + "')")
					.css("cursor", "pointer")
				);
			}
			li.append(
				$(document.createElement("span"))
				.text(track.name)
			);
			li.append(
				$(document.createElement("span"))
				.addClass("icon icon-remove")
				.attr("onClick", varName + ".removeTrack('" + track.protocol.url + "')")
				.css("cursor", "pointer")
			);
			trackList.append(li);
		});
	}

}
