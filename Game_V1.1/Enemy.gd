extends KinematicBody2D
var speed = 120.0
var gravity = 1000.0

var velocity = Vector2(0,0)
var direction = 1

signal health_changed
export (int) var max_health
var health
export (int) var damage

# Called when the node enters the scene tree for the first time.
func _ready():	
	health = max_health
	emit_signal('health_changed', health * 100/max_health)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity*delta

	if is_on_wall():
		direction *= -1
		$Sprite.flip_h = not $Sprite.flip_h
	velocity.x = speed*direction

	move_and_slide(velocity, Vector2(0,-1))

func take_damage(amount):	
	health -= amount
	print("monster: ", health)
	emit_signal('health_changed', health * 100/max_health)
	if health <= 0:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.take_damage(damage)
		
