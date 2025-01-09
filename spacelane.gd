extends Sprite2D

# stars being connected by this spacelane
var s0:Sprite2D
var s1:Sprite2D
var color = Color(Color.WHITE,0.25)
var mouse_is_hover = false
const MOUSE_HOVER_DISTANCE_THRESHOLD:float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	#var draw_color = color if mouse_is_hover else Color(color,0.25)
	if not mouse_is_hover:
		draw_line( s0.position * 2, s1.position * 2, color, 0.25, true ) # not sure why the "* 2"
	else:
		draw_line( s0.position * 2, s1.position * 2, color, 5, true ) # not sure why the "* 2"

func check_hover( mouse_pos:Vector2 ) -> bool:
	var line_dir = s1.global_position - s0.global_position
	var to_point = mouse_pos - s0.global_position
	var projection_length = to_point.dot( line_dir )
	var closest_point = s0.global_position + (line_dir.normalized() * projection_length)
	var distance = mouse_pos.distance_to( closest_point )
	return (distance <= MOUSE_HOVER_DISTANCE_THRESHOLD)
	
