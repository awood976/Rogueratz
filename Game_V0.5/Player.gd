extends KinematicBody2D

export var jump = 350.0
export var speed = 160.0
export var dash_speed = 450
export var gravity = 1100.0
export var dash_multipier = 1
export var dash_limit = 0.3
export var time_since_jump = 0.4
var crosshair_speed = 0.00000000000000000000000000000000001

var velocity = Vector2(0,0)
var last_direction = 0
var current_direction = 0
var double_jump = true

var timer = null
var dash_duration = 0.2
var is_in_dash = false
var dash_horizontal = 0
var dash_vertical = 0

var can_shoot = true
export (float) var gun_cooldown

var controller_deadzone = 0.2
var gun
onready var bullet = preload("res://Bullet.tscn")
onready var shotgun = preload("res://Shotgun.tscn")
onready var sniper = preload("res://Sniper.tscn")
onready var machine_gun = preload("res://Machine_Gun.tscn")

var weapons = [shotgun, sniper, machine_gun]
var weapon_index = 0


func _ready():
	gun = machine_gun.instance()
	add_child(gun)
	gun.position.x += 25
	gun.position.y += 10
	
	$GunTimer.wait_time = gun_cooldown
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
	if Input.is_action_just_pressed("next_weapon"):
#		gun.terminate()
#		gun = shotgun.instance()
#		add_child(gun)
#		gun.position.x += 15
#		gun.position.y += 10
		gun.terminate()
		if weapon_index % weapons.size() == 2:
			gun = machine_gun.instance()
		if weapon_index % weapons.size() == 1:
			gun = sniper.instance()
		if  weapon_index % weapons.size() == 0:
			gun = shotgun.instance()
		add_child(gun)
		gun.position.x += 15
		gun.position.y += 10
		weapon_index += 1
		
#	if Input.is_action_just_pressed("previous_weapon"):
#		gun.terminate()
#		if weapon_index % weapons.size() == 2:
#			gun = machine_gun.instance()
#		if weapon_index % weapons.size() == 1:
#			gun = sniper.instance()
#		if  weapon_index % weapons.size() == 0:
#			gun = shotgun.instance()
#		print(weapon_index)
#		add_child(gun)
#		gun.position.x += 15
#		gun.position.y += 10
#		weapon_index -= 1
		
	set_sprite_direction();
	
	if is_in_dash:
		dash(dash_horizontal, dash_vertical)
	else:	
		if Input.is_action_just_pressed("shoot"):
			shoot()
		
#		if Input.is_action_just_pressed("shoot"):
#			$"Gun Sprite/Flame/Particles2D".emitting = true
#		else: 	
#			$"Gun Sprite/Flame/Particles2D".emitting = false

#		var rs_x_position = 0
#		var rs_x = Input.get_joy_axis(1, JOY_AXIS_2)
#		if abs(rs_x) > controller_deadzone:
#			if rs_x < 0:
#				print("left")
#				print(rs_x_position)
#				Input.warp_mouse_position(Vector2(position.x, position.y))
#			if rs_x > 0:
#				print("right")
#				print(rs_x_position)
#				rs_x_position += rs_x
#				Input.warp_mouse_position(Vector2(position.x + (rs_x_position), position.y))
#
		
		
		var xAxis = Input.get_joy_axis(1, JOY_AXIS_0)
		if abs(xAxis) > controller_deadzone:
			print("movement")
			if xAxis < 0:
				print(xAxis)
				current_direction = -1
				last_direction = -1
			if xAxis > 0:
				print(xAxis)
				current_direction = 1
				last_direction = 1
		elif Input.is_action_pressed("ui_left"):
			current_direction = -1
			last_direction = -1
			
		elif Input.is_action_pressed("ui_right"):
			current_direction = 1
			last_direction = 1
		else:
			current_direction = 0
		
		if is_on_floor():
			time_since_jump = 0.4
			double_jump = true
			
		if not is_on_floor():
			velocity.y += gravity*delta
			time_since_jump -= delta
			if double_jump and Input.is_action_just_pressed("ui_accept"):
				double_jump = false
				velocity.y = -jump
			
		else:
			velocity.y = 0
			
		if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
			velocity.y = -jump
		
	#	if Input.is_action_pressed("ui_select") and dash_limit > 0 and is_on_floor():
	#		dash_multipier = 2
	#		dash_limit -= delta
	#
	#	if Input.is_action_just_released("ui_select"):
	#		dash_multipier = 1
	#		dash_limit = 0.3
	
#		if Input.is_action_just_pressed("dash"):
#			if $"Sprite".flip_h:
#				dash_horizontal = -1
#				dash_vertical = 0
#				start_timer()
#			else:
#				dash_horizontal = 1
#				dash_vertical = 0
#				start_timer()
				
		if Input.is_action_just_pressed("dash") and Input.is_action_pressed("ui_left"):
			dash_horizontal = -1
			dash_vertical = 0
			start_timer()
		if Input.is_action_just_pressed("dash") and Input.is_action_pressed("ui_right"):
			dash_horizontal = 1
			dash_vertical = 0
			start_timer()
		if Input.is_action_just_pressed("dash") and Input.is_action_pressed("ui_up"):
			dash_horizontal = 0
			dash_vertical = -1
			start_timer()
		if Input.is_action_just_pressed("dash") and Input.is_action_pressed("ui_down"):
			dash_horizontal = 0
			dash_vertical = 1
			start_timer()
			
			
		if dash_limit <= 0:
			dash_multipier = 1
			
		velocity.x = speed * current_direction * dash_multipier
		move_and_slide(velocity, Vector2(0,-1))
	
func _on_Hurtbox_area_entered(area):
	get_tree().reload_current_scene()
	#queue_free()

func set_sprite_direction():
	if position.x > get_global_mouse_position().x:
		$Sprite.flip_h = true
	else: 
		$Sprite.flip_h = false
	pass

func shoot():
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		gun.shoot()

func _on_GunTimer_timeout():
	can_shoot = true
