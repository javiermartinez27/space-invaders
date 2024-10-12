extends Area2D

@export var seconds_per_movement = 1.0
@export var enemy_separation = 120
@export var health = 1

const PlayerBullet = preload("res://scenes_and_scripts/player_bullet.gd")
const EnemyBullet = preload("res://scenes_and_scripts/enemy_bullet.tscn")
const Particles = preload("res://scenes_and_scripts/particles.tscn")  # Load the particles scene

var playable_screen_size
var seconds_passed_since_last_movement
var direction = "right"
var enemy_width
var enemy_height
var should_move_down = false
# Minimum and maximum interval (in seconds) between bullet spawns
var min_spawn_time = 0.5
var max_spawn_time = 3.0

# Timer to control random bullet spawning
var bullet_timer


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	playable_screen_size = get_viewport_rect().size - Vector2(50,50)
	seconds_passed_since_last_movement = 0
	enemy_width = $Sprite2D.texture.get_width() * $Sprite2D.scale.x
	enemy_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y
	
	#Bullet spawn logic
	randomize()  # Seed the random number generator
	bullet_timer = Timer.new()  # Create a new timer
	add_child(bullet_timer)  # Add the timer to the enemy node
	bullet_timer.connect("timeout", Callable(self, "_spawn_bullet"))  # Connect the timer to spawn bullets
	start_random_timer()  # Start the random timer when the scene is ready

# Function to randomly set the timer
func start_random_timer():
	var random_time = randf_range(min_spawn_time, max_spawn_time)  # Get a random time interval
	bullet_timer.start(random_time)
	
# Function to spawn a bullet
func _spawn_bullet():
	var bullet_instance = EnemyBullet.instantiate()  # Create a new bullet instance
	bullet_instance.position = Vector2(position.x, position.y + 20)
	get_tree().current_scene.add_child(bullet_instance)  # Add bullet to the scene

	start_random_timer()  # Restart the timer with a new random interval


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
	if area is PlayerBullet:
		health -= 1
		if health <= 0:
			queue_free()
			var particles_instance = Particles.instantiate() 
			particles_instance.position = position + Vector2(15,5)
			get_tree().current_scene.add_child(particles_instance)
