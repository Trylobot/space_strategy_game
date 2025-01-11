extends Camera2D

var dragging = false
var drag_start = Vector2.ZERO
var start_position = Vector2.ZERO
var zoom_speed = 0.1
var min_zoom = 0.1
var max_zoom = 5.0
var tweening = false

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
	if not tweening:
		var tween = get_tree().create_tween()
		tweening = true
		tween.tween_property( self, "zoom", zoom * zoom_factor, 0.5 )
		tween.parallel().tween_property( self, "position", position - get_global_mouse_position(), 0.5 )
		tween.tween_callback(tween_callback)

func tween_callback():
	tweening = false
