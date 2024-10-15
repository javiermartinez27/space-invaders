extends Area2D

const PlayerBullet = preload("res://scenes_and_scripts/player_bullet.gd")
const EnemyBullet = preload("res://scenes_and_scripts/enemy_bullet.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area is PlayerBullet or area is EnemyBullet:
		queue_free()
