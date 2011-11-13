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