extends Node2D

# Constants to define the star map properties
const STAR_COUNT = 40
const STARLANE_COUNT = 120
const STAR_COLOR = Color(1, 1, 1) # White stars
const STARLANE_COLOR = Color(0.5,0.5,0.5) # Grey lanes
const MAP_WIDTH = 1024
const MAP_HEIGHT = 768

var default_font = ThemeDB.fallback_font
var default_font_size = ThemeDB.fallback_font_size

@onready var star_scene = load("res://star.tscn")
@onready var spacelane_scene = load("res://spacelane.tscn")

#var stars = []
#var star_lanes = []

func _ready():
	randomize() # Seed the random number generator
	generate_stars()
	#update()
	pass

func _draw():
	for star in $Starmap.get_children():
		draw_circle( star.position, star.size, STAR_COLOR, false )
	for spacelane in $Spacelanes.get_children():
		draw_line( $Starmap.get_child(spacelane.s0).position, $Starmap.get_child(spacelane.s1).position, STARLANE_COLOR, 0.25, true )
	#draw_string(default_font, Vector2.ZERO, "0,0", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)
	#draw_string(default_font, Vector2(-0.5 * MAP_WIDTH, -0.5 * MAP_HEIGHT), ",0", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)
	pass

func generate_stars():
	for i in range(STAR_COUNT):
		var star = star_scene.instantiate()
		star.position = Vector2( randi() % MAP_WIDTH - (0.5 * MAP_WIDTH), randi() % MAP_HEIGHT - (0.5 * MAP_HEIGHT) )
		star.size = randf() * 11 + 3  # Random size between 3 and 12
		star.brightness = randf() * 0.5 + 0.5  # Random brightness between 0.5 and 1
		star.distance_to_star = {} # distance to all other stars by star index
		star.stars_by_distance = [] # list of stars by distance to this star, ascending
		$Starmap.add_child(star)

	for i in range(STAR_COUNT):
		for j in range(STAR_COUNT):
			$Starmap.get_child(i).distance_to_star[j] = $Starmap.get_child(i).position.distance_to( $Starmap.get_child(j).position )
	for i in range(STAR_COUNT):
		for j in range(STAR_COUNT):
			$Starmap.get_child(i).stars_by_distance.append({
				"star_idx": j,
				"dist": $Starmap.get_child(j).distance_to_star[i]
			})
			$Starmap.get_child(i).stars_by_distance.sort_custom(compare_star_distance)
	for i in range(STARLANE_COUNT):
		var s0_idx = randi() % STAR_COUNT
		var s0 = $Starmap.get_child(s0_idx)
		# first star is always self with distance 0, closest neighbor should be position 1, etc
		var spacelane
		if s0.size >= 3:
			spacelane = spacelane_scene.instantiate()
			spacelane.s0 = s0_idx
			spacelane.s1 = $Starmap.get_child(s0_idx).stars_by_distance[1].star_idx 
			$Spacelanes.add_child(spacelane)
		if s0.size >= 6:
			spacelane = spacelane_scene.instantiate()
			spacelane.s0 = s0_idx
			spacelane.s1 = $Starmap.get_child(s0_idx).stars_by_distance[2].star_idx
			$Spacelanes.add_child(spacelane)
		if s0.size >= 9:
			spacelane = spacelane_scene.instantiate()
			spacelane.s0 = s0_idx
			spacelane.s1 = $Starmap.get_child(s0_idx).stars_by_distance[3].star_idx
			$Spacelanes.add_child(spacelane)
	pass
	
func compare_star_distance(s0, s1):
	return (s1.dist - s0.dist) > 0
