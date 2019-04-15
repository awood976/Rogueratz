extends Area2D

signal enemy_hit


const SPEED = 800
const WIDTH = 1024
const HEIGHT = 600

var dir


func _process(delta):
	move(delta)
	

func move(var delta):
	position += delta * SPEED * dir
	
func remove_bullet():
	if out_of_bound():
		queue_free()
		
func out_of_bound():
	if position.x < 0 or position.x > WIDTH - 40 or position.y < 0 or position.y > HEIGHT:
		return true
	return false
	
	
