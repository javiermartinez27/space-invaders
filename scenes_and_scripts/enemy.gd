extends Area2D

@export var seconds_per_movement = 1

var playable_screen_size
var seconds_passed_since_last_movement
var direction = "right"
var enemy_width
var should_move_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	playable_screen_size = get_viewport_rect().size - Vector2(50,50)
	seconds_passed_since_last_movement = 0
	enemy_width = $Sprite2D.texture.get_width() * $Sprite2D.scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seconds_passed_since_last_movement += delta
	if seconds_passed_since_last_movement >= seconds_per_movement:
		seconds_passed_since_last_movement = 0
		if direction == "right":
			position.x += (enemy_width + 10) 
		else:
			position.x -= (enemy_width + 10) 
		if should_move_down:
			position.y += 50
			should_move_down = false
			
	if position.x + (enemy_width / 2) > playable_screen_size.x and direction == "right":
		direction = "left"
		should_move_down = true
	elif position.x - (enemy_width / 2) < 0 + 50 and direction == "left":
		direction = "right"
		should_move_down = true
