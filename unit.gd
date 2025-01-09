extends Sprite2D

#var faction
var unit_type:String

signal unit_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Hotspot.text = "Unit"
	$Hotspot.size = Vector2(20,20)
	$Hotspot.position = position
	$Hotspot.pressed.connect(self._pressed)
	pass

func _pressed():
	unit_pressed.emit( self )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Hotspot.position = position
	pass

func _draw() -> void:
	draw_rect(Rect2(position - Vector2(10,10), Vector2(20,20)), Color.RED, false) # center on position
	pass
