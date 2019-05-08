extends KinematicBody2D

export var jump = 350.0
export var speed = 160.0
export var dash_speed = 450
export var gravity = 1100.0
export var dash_multipier = 1
export var dash_limit = 0.3
export var time_since_jump = 0.4

var velocity = Vector2(0,0)
var last_direction = 0
var current_direction = 0
var double_jump = true
var has_dashed = false

var timer = null
var dash_duration = 0.2
var is_in_dash = false
var dash_horizontal = 0
var dash_vertical = 0

var controller_deadzone = 0.2
var gun
var controller_id = 0
var controller_connected = false
var can_shoot = true
var gun_cooldown = 0.3

onready var bullet = preload("res://Bullet.tscn")
onready var shotgun = preload("res://Shotgun.tscn")
onready var sniper = preload("res://Sniper.tscn")
onready var machine_gun = preload("res://Machine_Gun.tscn")
onready var flamegun = preload("res://Firefall.tscn")

var weapons = [shotgun, sniper, machine_gun, flamegun]
var weapon_index = 0

signal health_changed
export (int) var max_health
var health


func _ready():
	health = max_health
	emit_signal('health_changed', health * 100/max_health)
	
	gun = machine_gun.instance()
	add_child(gun)
	gun.position.x += 15
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
		controller_connected = true
		controller_id = deviceid
		print("Joystick " + str(deviceid) + " connected")
	else:
		controller_connected = false
		print("Controller disconnected")

func _process(delta):
	set_sprite_direction();
	
	if Input.is_action_just_pressed("next_weapon"):
		switch_weapon(1)
	if Input.is_action_just_pressed("previous_weapon"):
		switch_weapon(-1)
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if controller_connected:
		var rs_position = Vector2(0,0)
		var rs_x = Input.get_joy_axis(controller_id, JOY_AXIS_2)
		var rs_y = Input.get_joy_axis(controller_id, JOY_AXIS_3)
	
		if abs(rs_x) > controller_deadzone:
			rs_position.x = rs_x*get_viewport().size.x/1.0*delta
		if abs(rs_y) > controller_deadzone:
			rs_position.y = rs_y*get_viewport().size.y/1.0*delta
		Input.warp_mouse_position(get_viewport().get_mouse_position()+rs_position)	
	
	if is_in_dash:
		dash(dash_horizontal, dash_vertical)
	else:			
		var xAxis = Input.get_joy_axis(0, JOY_AXIS_0)
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
			has_dashed = false
			
		if not is_on_floor():
			has_dashed = false
			velocity.y += gravity*delta
			time_since_jump -= delta
			if double_jump and Input.is_action_just_pressed("ui_accept"):
				double_jump = false
				velocity.y = -jump
			
		else:
			velocity.y = 0
			
		if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
			velocity.y = -jump
		
				
		if Input.is_action_just_pressed("dash") and Input.is_action_pressed("ui_left"):
			has_dashed = true
			dash_horizontal = -1
			dash_vertical = 0
			start_timer()
		if Input.is_action_just_pressed("dash") and Input.is_action_pressed("ui_right"):
			has_dashed = true
			dash_horizontal = 1
			dash_vertical = 0
			start_timer()
		if Input.is_action_just_pressed("dash") and Input.is_action_pressed("ui_up"):
			has_dashed = true
			dash_horizontal = 0
			dash_vertical = -1
			start_timer()
		if Input.is_action_just_pressed("dash") and Input.is_action_pressed("ui_down"):
			has_dashed = true
			dash_horizontal = 0
			dash_vertical = 1
			start_timer()
			
			
		if dash_limit <= 0:
			dash_multipier = 1
		
		if Input.is_action_just_pressed("start"):
			print("menu")
			
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()
			
		velocity.x = speed * current_direction * dash_multipier
		move_and_slide(velocity, Vector2(0,-1))	

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
			
		
func take_damage(amount):
	health -= amount
	print("player: ", health)
	emit_signal('health_changed', health * 100/max_health)
	if health <= 0:
		get_tree().reload_current_scene()

func _on_GunTimer_timeout():
	can_shoot = true
	
func switch_weapon(val):
	gun.terminate()
	weapon_index += val
	if weapon_index > 4:
		weapon_index = 1
	if weapon_index < 0:
		weapon_index = 3
	if abs(weapon_index) % weapons.size() == 3:
		gun = flamegun.instance()
		gun_cooldown = 0.0
		$GunTimer.wait_time = gun_cooldown
	if abs(weapon_index) % weapons.size() == 2:
		gun = shotgun.instance()
		gun_cooldown = 1.0
		$GunTimer.wait_time = gun_cooldown
	if abs(weapon_index) % weapons.size() == 1:
		gun = sniper.instance()
		gun_cooldown = 3.0
		$GunTimer.wait_time = gun_cooldown
	if abs(weapon_index) % weapons.size() == 0:
		gun = machine_gun.instance()
		gun_cooldown = 0.3
		$GunTimer.wait_time = gun_cooldown
	add_child(gun)
	gun.position.x += 15
	gun.position.y += 10

