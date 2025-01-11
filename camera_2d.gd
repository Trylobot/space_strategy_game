extends Camera2D

var dragging = false
var drag_start = Vector2.ZERO
var start_position = Vector2.ZERO
var zoom_speed = 0.1
var min_zoom = 0.1
var max_zoom = 5.0

var tween


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
				drag_start = get_viewport().get_mouse_position()
				start_position = position
			else:
				dragging = false
				
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_at_point(1 + zoom_speed, event.position)
			#
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_at_point(1 - zoom_speed, event.position)
			
	elif event is InputEventMouseMotion and dragging:
		var viewport_size = Vector2(get_viewport().size)
		var mouse_pos = get_viewport().get_mouse_position()
		var relative_motion = (drag_start - mouse_pos) / viewport_size
		position = start_position + relative_motion * (viewport_size * zoom)

func zoom_at_point(zoom_factor: float, point: Vector2):
	tween = get_tree().create_tween()
	tween.tween_property( self, "zoom", zoom * zoom_factor, 0.5 )
	
	
	#zoom = zoom * zoom_factor
	#var new_zoom = zoom * zoom_factor
	#new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	#new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	#
	#var mouse_pos = point - position
	#position += mouse_pos - (mouse_pos * zoom_factor)
	#zoom = new_zoom
	pass
