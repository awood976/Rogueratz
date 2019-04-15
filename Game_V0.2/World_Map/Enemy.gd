extends KinematicBody2D
var speed = 110.0
var gravity = 1000.0

var velocity = Vector2(0,0)
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
