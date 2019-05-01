extends KinematicBody2D

const speed = 400
var target
var velocity = Vector2()
var dir

export (float) var bullet_dur
export (int) var damage

func ready():
	target = get_global_mouse_position()
	velocity = (target - position).normalized()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed

func _process(delta):
#	print(velocity.x)
#	print(velocity.y)
#	position += velocity
#	print(position)

	position += velocity * delta
	#move(delta)
	if is_on_wall():
		queue_free()
	if out_of_bound():
		queue_free()

func out_of_bound():
	return self.position.x > get_viewport().size.x || self.position.x < 0
	
	

func _on_BulletTimer_timeout():
	queue_free()
	
