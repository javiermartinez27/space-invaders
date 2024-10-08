extends CharacterBody2D

@export var speed = 500
@export var time_between_shots = 0.3

var Bullet = preload("res://scenes_and_scripts/bullet.tscn")

var screen_size
var time_since_last_shot = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = screen_size.x / 2
	position.y = screen_size.y - 40

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_movement(delta)
	check_shooting(delta)
		
func check_movement(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move-left"):
		velocity.x -= 1
	if Input.is_action_pressed("move-right"):
		velocity.x += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	var half_width = $Sprite2D.texture.get_width() * $Sprite2D.scale.x / 2
	var margin = 20  # Adjust this value as needed
	position.x = clamp(position.x, half_width + margin, screen_size.x - half_width - margin) # Prevent player from going off-screen 
	
func check_shooting(delta):
	time_since_last_shot += delta
	if time_since_last_shot > time_between_shots:
		if Input.is_action_pressed("shoot"):
			spawn_bullet(delta)
			time_since_last_shot = 0
			
		
func spawn_bullet(delta):
	var bullet_instance = Bullet.instantiate()
	bullet_instance.position = Vector2(position.x, position.y - 20)
	get_tree().current_scene.add_child(bullet_instance)

