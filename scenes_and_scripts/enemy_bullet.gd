extends Area2D
@export var speed = 600

const Player = preload("res://scenes_and_scripts/player.gd")

var maximum_position
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	maximum_position = get_viewport_rect().size.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	if position.y > maximum_position + 5:
		queue_free() # Removes bullet when off-screen
		
func _on_area_entered(area):
	if area.get_parent() is Player:
		queue_free()
