extends Area2D

@export var seconds_per_movement = 1
@export var enemy_separation = 120
@export var health = 1

const Bullet = preload("res://scenes_and_scripts/bullet.gd")
const Particles = preload("res://scenes_and_scripts/particles.tscn")  # Load the particles scene

var playable_screen_size
var seconds_passed_since_last_movement
var direction = "right"
var enemy_width
var enemy_height
var should_move_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	playable_screen_size = get_viewport_rect().size - Vector2(50,50)
	seconds_passed_since_last_movement = 0
	enemy_width = $Sprite2D.texture.get_width() * $Sprite2D.scale.x
	enemy_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seconds_passed_since_last_movement += delta
	if seconds_passed_since_last_movement >= seconds_per_movement:
		seconds_passed_since_last_movement = 0
		if should_move_down:
			position.y += enemy_height + 25
			should_move_down = false
		else:
			if direction == "right":
				position.x += 120
			else:
				position.x -= 120
		
			
	if position.x + (enemy_width / 2) + (enemy_width + 10) > playable_screen_size.x and direction == "right":
		direction = "left"
		should_move_down = true
	elif position.x - (enemy_width / 2) - (enemy_width + 10) < 0 and direction == "left":
		direction = "right"
		should_move_down = true

func _on_area_entered(area):
	if area is Bullet:
		health -= 1
		if health <= 0:
			queue_free()
			var particles_instance = Particles.instantiate() 
			particles_instance.position = position + Vector2(15,5)
			get_tree().current_scene.add_child(particles_instance)
