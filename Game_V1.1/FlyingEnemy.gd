extends KinematicBody2D
var speed = 100.0
var gravity = 10.0

var velocity = Vector2(0,0)
var direction = 1

signal health_changed
export (int) var max_health = 200
var health
export (int) var damage
export (int) var detect_range = 400
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	$DetectRange/CollisionShape2D.shape.radius = detect_range
	emit_signal('health_changed', health * 100/max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	if is_on_wall():
		direction *= -1
		$Sprite.flip_h = not $Sprite.flip_h
	
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		velocity.y = 60*target_dir.y
		velocity.x = 60*target_dir.x
		move_and_slide(velocity, Vector2())
	else:			
		velocity.y = gravity*delta
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

func _on_DetectRange_body_entered(body):
	if body.name == "Player":
		target = body
	
func _on_DetectRange_body_exited(body):
	if body == target:
		target = null
