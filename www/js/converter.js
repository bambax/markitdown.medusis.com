/*
Mark It Down
(c) Medusis, 2011-2013
 */

"use strict";

$(document).ready(function() {
	/*
	**************************** CONVERTER *********************************
	*/

	$("#convert_raz").live("click", function() {
		$("#converter_source, #converter_result").text("");
		});


	/*
	***************************** *UTILS ***********************************
	*/

	// remake of alert to prevent bizarre Saxon errors from jumping in front of the user
	var akay_alert = window.alert;
	window.alert = function(msg) {
		var	prefix = "";
		try {
			prefix = msg.substr(0, 12);
			}
		catch(e) {
			console.log(msg);
			return;
			}
		if (prefix === "_akay_force_") {
			akay_alert(msg.substr(12));
			}
		else {
			console.log("alert:", msg);
			}
		}

	});


