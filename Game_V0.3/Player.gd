extends KinematicBody2D

var jump = 350.0
var speed = 160.0
var dash_speed = 450
var gravity = 1100.0
var dash_multipier = 1
var dash_limit = 0.3
var time_since_jump = 0.4

var velocity = Vector2(0,0)
var last_direction = 0
var current_direction = 0
var double_jump = true

var timer = null
var dash_duration = 0.2
var is_in_dash = false
var dash_horizontal = 0
var dash_vertical = 0

var controller_deadzone = 0.2
onready var bullet = preload("res://Bullet.tscn")

func _ready():
	Input.connect("joy_connection_changed", self, "joy_con_changed")
	
func start_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(dash_duration)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	timer.start()
	is_in_dash = true
	
func on_timeout_complete():
	is_in_dash = false
func dash(horizontal, vertical):
	velocity.x = dash_speed*horizontal
	velocity.y = dash_speed*vertical
	move_and_slide(velocity, Vector2(0,-1))
	
	
func joy_con_changed(deviceid, isConnected):
	if isConnected:
		print("Joystick " + str(deviceid) + " connected")
		if not Input.is_joy_known(0):
			print("Recognized controller")
			print(Input.get_joy_name(0) + " device found")
	else:
		print("Controller disconnected")

func _process(delta):
	if is_in_dash:
		dash(dash_horizontal, dash_vertical)
	else:	
		if Input.is_action_just_pressed("ui_focus_next"):
			print("shoot")
			$"Gun Sprite/SFX".play(0)
			var new_bullet = bullet.instance()
			get_parent().add_child(new_bullet)
			if not $"Gun Sprite".flip_h:
				new_bullet.dir = 1
				new_bullet.position = $"Gun Sprite".global_position 
				new_bullet.position.x += 30 
			else:
				new_bullet.dir = -1
				new_bullet.position = $"Gun Sprite".global_position 
				new_bullet.position.x -= 30 
			get_parent().add_child(new_bullet)
		
		
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
			if double_jump and Input.is_action_just_pressed("ui_up"):
				double_jump = false
				velocity.y = -jump
			
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
		
	#	if Input.is_action_pressed("ui_select") and dash_limit > 0 and is_on_floor():
	#		dash_multipier = 2
	#		dash_limit -= delta
	#
	#	if Input.is_action_just_released("ui_select"):
	#		dash_multipier = 1
	#		dash_limit = 0.3
	
		if Input.is_action_just_pressed("ui_select"):
			if $"Gun Sprite".flip_h:
				dash_horizontal = -1
				dash_vertical = 0
				start_timer()
			else:
				dash_horizontal = 1
				dash_vertical = 0
				start_timer()
				
#		if Input.is_action_just_pressed("ui_select") and Input.is_action_pressed("ui_left"):
#			dash_horizontal = current_direction
#			dash_vertical = 0
#			start_timer()
#		if Input.is_action_just_pressed("ui_select") and Input.is_action_pressed("ui_right"):
#			dash_horizontal = 1
#			dash_vertical = 0
#			start_timer()
		if Input.is_action_just_pressed("ui_select") and Input.is_action_pressed("ui_up"):
			dash_horizontal = 0
			dash_vertical = -1
			start_timer()
		if Input.is_action_just_pressed("ui_select") and Input.is_action_pressed("ui_down"):
			dash_horizontal = 0
			dash_vertical = 1
			start_timer()
			
			
		if dash_limit <= 0:
			dash_multipier = 1
			
		velocity.x = speed * current_direction * dash_multipier
		move_and_slide(velocity, Vector2(0,-1))
	
func _on_Hurtbox_area_entered(area):
	queue_free()

	

	


	
