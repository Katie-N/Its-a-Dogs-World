extends CharacterBody2D

@export var max_speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var last_direction := Vector2(1,0)

func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * max_speed
	move_and_slide()

	if direction.length() > 0:
		last_direction = direction

func _process(delta):
	#	Make the dog get bigger as it walks down and smaller as it walks up
	var min_scale = 0.5
	var max_scale = 1.0
	var far_distance = 100.0
	var near_distance = 300.0

	var distance = (position.y - far_distance) / near_distance
	scale.x = lerp(min_scale, max_scale, distance)
	scale.y = lerp(min_scale, max_scale, distance)
