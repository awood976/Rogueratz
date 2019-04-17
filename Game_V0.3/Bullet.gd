extends KinematicBody2D

const speed = 400
var target
var velocity = Vector2()
var dir
func ready():
	target = get_global_mouse_position()
	velocity = (target - position).normalized()

func _process(delta):
#	print(velocity.x)
#	print(velocity.y)
#	position += velocity
#	print(position)
	move(delta)
	if is_on_wall():
		queue_free()
	if out_of_bound():
		queue_free()
	
func move(delta):
	velocity.x = speed*dir
	position = position + velocity * delta
#	shoot(position)
#
	
func shoot():
#	self.global_position = start_position
#	var direction = (get_global_mouse_position() - start_position).normalize()
#	self.linear_velocity = direction * speed
	position += velocity
func out_of_bound():
	return self.position.x > get_viewport().size.x || self.position.x < 0
	
	