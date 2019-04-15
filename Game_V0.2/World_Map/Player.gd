extends KinematicBody2D

var jump = 450.0
var speed = 160.0
var gravity = 1100.0
var dash_multipier = 1
var dash_limit = 0.3
var time_since_jump = 0.4

var velocity = Vector2(0,0)
var last_direction = 0
var current_direction = 0
var double_jump = true

var controller_deadzone = 0.2
onready var bullet = preload("res://Bullet.tscn")

func _ready():
	Input.connect("joy_connection_changed", self, "joy_con_changed")
	pass
	
	
func joy_con_changed(deviceid, isConnected):
	if isConnected:
		print("Joystick " + str(deviceid) + " connected")
		if not Input.is_joy_known(0):
			print("Recognized controller")
			print(Input.get_joy_name(0) + " device found")
	else:
		print("Controller disconnected")

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		print("shoot")
		$"Gun Sprite/SFX".play(0)
		var new_bullet = bullet.instance()
		if not $"Gun Sprite".flip_h:
			new_bullet.dir = 1
			new_bullet.position = $"Gun Sprite".position 
			new_bullet.position.x += 30 
		else:
			new_bullet.dir = -1
			new_bullet.position = $"Gun Sprite".position 
			new_bullet.position.x -= 30 
		add_child(new_bullet)
		new_bullet.move()
	
	
	
	if Input.get_connected_joypads().size() > 0:
		var xAxis = Input.get_joy_axis(0, JOY_AXIS_0)
		if abs(xAxis) > controller_deadzone:
			print("movement")
			if xAxis < 0:
				print("right")
				$Sprite.flip_h = true
				current_direction = -1
				last_direction = -1
			if xAxis > 0:
				print("left")
				$Sprite.flip_h = false
				current_direction = 1
				last_direction = 1
	
	if is_on_floor():
		time_since_jump = 0.4
		double_jump = true
		
	if not is_on_floor():
		velocity.y += gravity*delta
		time_since_jump -= delta
		if double_jump and time_since_jump < 0 and Input.is_action_just_pressed("ui_up"):
			double_jump = false
			velocity.y += -jump*1.5
		
	else:
		velocity.y = 0
		
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = -jump
		
	if Input.is_action_pressed("ui_left"):
		if not $"Gun Sprite".flip_h:
			$"Gun Sprite".position.x -= 35 
		$"Gun Sprite".flip_h = true
		$Sprite.flip_h = true
		current_direction = -1
		last_direction = -1
		
	elif Input.is_action_pressed("ui_right"):
		if $"Gun Sprite".flip_h:
			$"Gun Sprite".position.x += 35 
		$"Gun Sprite".flip_h = false
		$Sprite.flip_h = false
		current_direction = 1
		last_direction = 1
	else:
		current_direction = 0
	
	if Input.is_action_pressed("ui_select") and dash_limit > 0 and is_on_floor():
		dash_multipier = 2
		dash_limit -= delta
		
	if Input.is_action_just_released("ui_select"):
		dash_multipier = 1
		dash_limit = 0.3
		
	if dash_limit <= 0:
		dash_multipier = 1
		
	velocity.x = speed * current_direction * dash_multipier
	move_and_slide(velocity, Vector2(0,-1))
	
func _on_Hurtbox_area_entered(area):
	queue_free()

	

	


	
