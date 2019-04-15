extends Node2D


const DIRECTION = {
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1),
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0)
}

var shoot_dir = DIRECTION.RIGHT

onready var bullet = preload("res://Bullets/Bullet.tscn")
var bullet_reload = 0.0
var reload_time = 0.5

func _input(event):
	if Input.is_action_pressed("ui_up"):
		shoot_dir = DIRECTION.UP

	elif Input.is_action_pressed("ui_down"):
		shoot_dir = DIRECTION.DOWN

	elif Input.is_action_pressed("ui_left"):
		shoot_dir = DIRECTION.LEFT

	elif Input.is_action_pressed("ui_right"):
		shoot_dir = DIRECTION.RIGHT
		
	elif Input.is_key_pressed(KEY_SPACE):
		fire()
	
func _process(delta):
	bullet_reload -= delta
		
func fire():
	if bullet_reload <= 0.0:
		var new_bullet = bullet.instance()
		new_bullet.position = get_node("Gun").position
		new_bullet.dir = shoot_dir
		add_child(new_bullet)
		bullet_reload = reload_time
		
		
	