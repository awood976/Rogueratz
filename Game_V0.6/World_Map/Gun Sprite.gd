extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mouse_position
func _ready():
	pass # Replace with function body.

func _process(delta):
	mouse_position = get_local_mouse_position()
	rotation += mouse_position.angle()