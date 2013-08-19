$(handleRemoteLinks = function() {
	$("a[data-remote]").data('type', 'html')
	.on("ajax:success", function(e, data, status, xhr) {
		$.facebox(data);
		handleRemoteLinks();
	})
	.on("ajax:error", function(e, xhr, status, error) {
		$.facebox(xhr.responseText);
	});
});


var mainClassDefault = "size2of3";
var mainClassSmall = "size1of3";
var resizerClassDefault = "icon-chevron-left";
var resizerClassSmall = "icon-chevron-right";

$(function() {
	$("#main").addClass(mainClassDefault);
	$("#resizer").addClass(resizerClassDefault);
});

function resize() {
	var main = $("#main");
	var resizer = $("#resizer");
	var duration = 300;
	if(main.hasClass(mainClassDefault)) {
		main.toggleClass(mainClassSmall, duration).toggleClass(mainClassDefault, duration);
		resizer.toggleClass(resizerClassSmall, duration).toggleClass(resizerClassDefault, duration);
	} else {
		main.toggleClass(mainClassDefault, duration).toggleClass(mainClassSmall, duration);
		resizer.toggleClass(resizerClassDefault, duration).toggleClass(resizerClassSmall, duration);
	}
	setTimeout(function() {
		mapView.updateSize()
	}, duration);
}
