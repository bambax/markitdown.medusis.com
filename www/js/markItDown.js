(function() {
	var	jQueryVersion = "1.3.2";
	if (window.jQuery === undefined || window.jQuery.fn.jquery < jQueryVersion) {
		var	done = false,
			script = document.createElement("script");
		script.src = "http://ajax.googleapis.com/ajax/libs/jquery/" + jQueryVersion + "/jquery.min.js";
		script.onload = script.onreadystatechange = function() {
			if (!done && (!this.readyState || this.readyState == "loaded" || this.readyState == "complete")) {
				done = true;
				init();
				}
			};
		document.getElementsByTagName("head")[0].appendChild(script);
		}
	else {
		init();
		}
	function init() {
		(window.markItDownBookmarklet = function() {
			function getSelText() {
				var s = '';
				if (window.getSelection) {
					s = window.getSelection();
					}
				else if (document.getSelection) {
					s = document.getSelection();
					}
				else if (document.selection) {
					s = document.selection.createRange().text;
					}
				return s;
			}
			// your JavaScript code goes here!
			alert("hello");
			})();
		}
	})();