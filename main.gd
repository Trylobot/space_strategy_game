extends Node2D

# Constants to define the star map properties
const STAR_COUNT = 40
const STARLANE_COUNT = 120
const STAR_COLOR = Color(1, 1, 1) # White stars
const STARLANE_COLOR = Color(0.5,0.5,0.5) # Grey lanes
const MAP_WIDTH = 1024
const MAP_HEIGHT = 768

const FACTION_COUNT = 2
const FACTION_COLORS = [Color( 1, 0.8, 0.8 ), Color( 0.8, 0.8, 1 )]

var default_font = ThemeDB.fallback_font
var default_font_size = ThemeDB.fallback_font_size

var star_scene = load("res://star.tscn")
var spacelane_scene = load("res://spacelane.tscn")
var faction_scene = load("res://faction.tscn")
var unit_scene = load("res://unit.tscn")

func _ready():
	randomize() # Seed the random number generator
	generate_stars()
	add_factions()
	spawn_starting_units()
	pass

func _draw():
	for spacelane in $Spacelanes.get_children():
		spacelane._draw()
	for star in $Starmap.get_children():
		star._draw()
	for faction in $Factions.get_children():
		for unit in faction.get_units():
			unit._draw()
	pass

func generate_stars():
	for i in range(STAR_COUNT):
		var star = star_scene.instantiate()
		star.global_position = Vector2( randi() % MAP_WIDTH - (0.5 * MAP_WIDTH), randi() % MAP_HEIGHT - (0.5 * MAP_HEIGHT) )
		star.size = randf() * 11 + 3  # Random size between 3 and 12
		star.brightness = randf() * 0.5 + 0.5  # Random brightness between 0.5 and 1
		star.distance_to_star = {} # distance to all other stars by star index
		star.stars_by_distance = [] # list of stars by distance to this star, ascending
		$Starmap.add_child(star)

	for i in range(STAR_COUNT):
		for j in range(STAR_COUNT):
			$Starmap.get_child(i).distance_to_star[j] = $Starmap.get_child(i).global_position.distance_to( $Starmap.get_child(j).global_position )
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
		for s in [[1,3],[2,6],[3,9]]:
			var spacelane = create_spacelane(s0_idx,s[0],s[1])
			$Spacelanes.add_child(spacelane) #offset,min_size
	pass
	
func compare_star_distance(s0, s1):
	return (s1.dist - s0.dist) > 0

func create_spacelane(s0_idx,offset,min_size):
	var spacelane = spacelane_scene.instantiate()
	spacelane.s0 = $Starmap.get_child(s0_idx).position
	spacelane.s1 = $Starmap.get_child($Starmap.get_child(s0_idx).stars_by_distance[offset].star_idx).position
	return spacelane

func add_factions():
	for i in range(FACTION_COUNT):
		var faction = faction_scene.instantiate()
		faction.name = "Faction %s" % i
		faction.color = FACTION_COLORS[i]
		$Factions.add_child( faction )
	pass
	
func spawn_starting_units():
	for faction in $Factions.get_children():
		faction.spawn_starting_units( $Starmap )
	pass
	
