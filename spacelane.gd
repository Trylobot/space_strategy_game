extends Sprite2D

var s0:Vector2
var s1:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	draw_line( s0, s1, Color.WHITE, 0.25, true )
	pass
