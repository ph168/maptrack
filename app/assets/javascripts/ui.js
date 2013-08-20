$(handleRemote = function() {
	$("a[data-remote]").data('type', 'html')
	.on("ajax:success", function(e, data, status, xhr) {
		if ($(e.target).data('target') == undefined) {
			$.facebox(data);
			handleRemote();
		} else {
			var target = $($(e.target).data('target'));
			target.fadeOut(function() {
				target.html(data).fadeIn(handleRemote);
			});
		}
	})
	.on("ajax:error", function(e, xhr, status, error) {
		showError(error);
	});

	$("form[data-remote]")
	.on("ajax:success", function(e, data, status, xhr) {
		var target = $("#" + $.parseHTML(data)[0].id);
		target.fadeOut(function() {
			target.replaceWith(data).fadeIn(handleRemote);
		});
	})
	.on("ajax:error", function(e, xhr, status, error) {
		showError(error);
	});
});


function showMessage(text, type = "notice") {
	var sel = null;
	if (type == "error")
		sel = "#error";
	else
		sel = "#notice";
	if (text != "") {
		$(sel).text(text);
		$(sel).fadeIn();
		setTimeout(function() {
			$(sel).fadeOut(function() {
				$(sel).text("");
			});
		}, 4000);
	} else {
		$(sel).hide();
	}
}

function showError(text) {
	showMessage(text, "error");
}

$(function() {
	showMessage("");
	showError("");
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
