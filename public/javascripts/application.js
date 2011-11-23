//= require jquery
//= require jquery_ujs
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

$(document).ready(function() {
    $('input.date-field').live('blur', function() {
        $input = $(this)
        $.get('/application/check_date', {'test': $input.val()})
            .success(function(data, state) {
                $input.parent().find('.date-check').detach()
                $input.after("<strong class=\"date-check\" style=\"color:black;\"> "+data+"</strong>")
            })
            .error(function(data, state) {
                $input.parent().find('.date-check').detach()
                $input.after("<strong class=\"date-check\" style=\"color:red;\"> "+data+"</strong>")
            })
    })
})