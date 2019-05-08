extends Node2D

export (bool) var display_health_text = true
onready var health_text = get_node("HealthText")
onready var health = get_node("Health")

var max_health
var current_health

func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func init(max_health, current_health):
	self.max_health = max_health
	self.current_health = current_health	
	update()

func set_health(value):
	current_health = clamp(value, 0, max_health)
	
	update()
	
func update():
	var percentage = current_health / max_health
	health.set_scale(Vector2(percentage, 1))
	
	var percentage_text = str(percentage * 100) + "%"
	health_text.set_text(percentage_text.pad_decimals(0))
	
func _process(delta):
	pass
