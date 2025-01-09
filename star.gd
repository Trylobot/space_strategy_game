extends Sprite2D

var idx = 0
var size = 1.000
var brightness = 1
var distance_to_star = {}
var stars_by_distance = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#position = Vector2.ZERO
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	draw_circle( position, size, Color.WHITE, false )
	pass
