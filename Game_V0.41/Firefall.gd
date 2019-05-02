extends Node2D

var mouse_position
func _ready():
	pass # Replace with function body.

func _process(delta):
	mouse_position = get_local_mouse_position()
	rotation += mouse_position.angle()