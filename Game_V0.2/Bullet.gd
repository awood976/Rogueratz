extends KinematicBody2D

const speed = 400
var dir
var velocity = Vector2(0,0)

func _process(delta):
	move()
	if is_on_wall():
		queue_free()
	if out_of_bound():
		queue_free()
	
func move():
	velocity.x = speed*dir
	move_and_slide(velocity, Vector2(0,-1))
func out_of_bound():
	return self.position.x > get_viewport().size.x || self.position.x < 0
	
	