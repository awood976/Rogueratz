extends Area2D

const speed = 200
var target
var velocity = Vector2()
var dir

#var explode_velocity = Vector2()

export (int) var damage

func ready():
	target = get_global_mouse_position()
	velocity = (target - position).normalized()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed

func _process(delta):

	global_position += velocity * delta
	#move(delta)
	if out_of_bound():
		explode()

func out_of_bound():
	return global_position.x > get_viewport().size.x || global_position.x < 0

func explode():
#	explode_velocity = Vector2()
	$Sprite.hide()
	$FlameEffect.show()
	$FlameEffect.play("default")

func _on_FlameEffect_animation_finished():
	queue_free()

func _on_Flame_body_entered(body):
	explode()
	if body.name == "Enemy" or body.name == "FlyingEnemy" :
		body.take_damage(damage)		
