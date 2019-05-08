extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_healthbar(value):
	$HealthBar/Tween.interpolate_property($HealthBar, 'value', $HealthBar.value, value, 0.2, Tween.TRANS_LINEAR,Tween. EASE_IN_OUT)	
	$HealthBar/Tween.start()
	
