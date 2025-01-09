extends Node2D

const STARTING_UNITS = ["colony_ship"]

@onready var unit_scene = load("res://unit.tscn")


#var name = "Example Faction"
var color = Color(1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_starting_units( starmap ):
	for unit_type in STARTING_UNITS:
		var unit = unit_scene.instantiate()
		unit.unit_type = unit_type
		var star_idx = randi() % starmap.get_children().size()
		unit.global_position = starmap.get_child( star_idx ).global_position
		$Units.add_child( unit )
	pass
	
func get_units() -> Array[Node]:
	return $Units.get_children()
