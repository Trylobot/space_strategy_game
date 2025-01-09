extends Sprite2D

var s0:Node2D
var s1:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	draw_line( s0.position * 2, s1.position * 2, Color.WHITE, 0.25, true ) # not sure why the "* 2"
	pass
