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

var stars = []
var star_lanes = []

func _ready():
	randomize() # Seed the random number generator
	generate_stars()
	#update()

func _draw():
	for s in star_lanes:
		draw_line(stars[s.s0].position, stars[s.s1].position, STARLANE_COLOR, 0.25, true)
	for star in stars:
		draw_circle(star.position, star.size, STAR_COLOR, false)
	
	#draw_string(default_font, Vector2.ZERO, "0,0", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)
	#draw_string(default_font, Vector2(-0.5 * MAP_WIDTH, -0.5 * MAP_HEIGHT), ",0", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)

func generate_stars():
	# generate star systems
	for i in range(STAR_COUNT):
		var pos = Vector2(randi() % MAP_WIDTH - (0.5 * MAP_WIDTH), randi() % MAP_HEIGHT - (0.5 * MAP_HEIGHT))
		var s = randf() * 11 + 3  # Random size between 3 and 12
		var br = randf() * 0.5 + 0.5  # Random brightness between 0.5 and 1
		stars.append({
			"idx": i,
			"position": pos, 
			"size": s, 
			"brightness": br,
			"distance_to_star": {}, # distance to all other stars by star index
			"stars_by_distance": [], # list of stars by distance to this star, ascending
		})
	# generate star lanes to connect the stars
	for i in range(STAR_COUNT):
		for j in range(STAR_COUNT):
			stars[i].distance_to_star[j] = stars[i].position.distance_to(stars[j].position)
	for i in range(STAR_COUNT):
		#stars[i].stars_by_distance = []
		for j in range(STAR_COUNT):
			stars[i].stars_by_distance.append({
				"star_idx": j,
				"dist": stars[j].distance_to_star[i]
			})
			stars[i].stars_by_distance.sort_custom(compare_star_distance)
	for i in range(STARLANE_COUNT):
		var s0_idx = randi() % STAR_COUNT
		star_lanes.append({
			"s0": s0_idx,
			"s1": stars[s0_idx].stars_by_distance[1].star_idx, # first star is always self with distance 0, closest neighbor should be position 1
		})

func compare_star_distance(s0, s1):
	return (s1.dist - s0.dist) > 0
