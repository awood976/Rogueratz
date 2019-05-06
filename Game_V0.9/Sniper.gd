extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bullet = preload("res://SniperBullet.tscn")
var mouse_position

func _ready():
	pass # Replace with function body.

func _process(delta):
	set_sprite_direction()
	mouse_position = get_local_mouse_position()
	rotation += mouse_position.angle()
	
func set_sprite_direction():
	if get_parent().global_position.x > get_global_mouse_position().x:
		if not flip_v:
			global_position.x -= 20
			global_position.y += 13 
		flip_v = true
	else: 
		if flip_v:
			global_position.x += 20
			global_position.y -= 13 
		flip_v = false

func shoot():
	var dir = Vector2(1, 0).rotated(global_rotation)
	var b = bullet.instance()
	get_parent().get_parent().add_child(b)
	b.start($Position2D.global_position, dir)


func terminate():
	queue_free()