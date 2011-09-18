// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function setDropDown(field, data, method) {
	field.options.length = 0;
	alert("e: " + e)
	data.each(function(e) {
		field.options.add(method(e));
	});
}

function autocomplete(source, url) {
	$(source).autocomplete({
		source: url,
		minLength: 2,
		select: function( event, ui ) {
			alert(this)
		}
	});
}
