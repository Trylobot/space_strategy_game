extends Node2D

const STARTING_UNITS = ["colony_ship"]

@onready var unit_scene = load("res://unit.tscn")


#var name = "Example Faction"
var color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_starting_units( starmap, unit_on_pressed_handler ):
	for unit_type in STARTING_UNITS:
		var unit = unit_scene.instantiate()
		var star_idx = randi() % starmap.get_children().size()
		unit.unit_type = unit_type
		unit.position = starmap.get_child( star_idx ).position
		unit.unit_pressed.connect(unit_on_pressed_handler)
		$Units.add_child( unit )
	pass
	
func get_units() -> Array[Node]:
	return $Units.get_children()
