// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function setDropDown(field, data, method) {
	field.options.length = 0;
	alert("e: " + e)
	data.each(function(e) {
		field.options.add(method(e));
	});
}

Event.observe($('document_matter_attributes_legal_attributes_date_of_closure'), 'blur', function(evt) {
	alert(evt);
})