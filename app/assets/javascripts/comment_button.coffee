$(document).on "page:change", ->
	$('#comment_button').click ->
		$('#comment_button').hide()
		$('#show_comment').hide()
		$('#comment_time').hide()
		$('#new_comment').show()
		
	$('#comment_submit').click ->
		$('#comment_button').show()
		$('#show_comment').show()
		$('#comment_time').show()
		$('#new_comment').hide()
		
	# $('#comment_cancel').click ->
	# 	$$('#comment_button').show()
	# 	$('#show_comment').show()
	# 	$('#comment_time').show()
	# 	$('#new_comment').hide()