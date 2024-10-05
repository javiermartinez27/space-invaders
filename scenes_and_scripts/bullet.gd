extends Area2D
@export var speed = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta
	if position.y < -5:
		queue_free() # Removes bullet when off-screen
