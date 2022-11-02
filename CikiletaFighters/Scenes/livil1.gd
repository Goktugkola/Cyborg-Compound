extends Node2D

func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	if($Player1/HealthBar.value == 0):
		get_tree().reload_current_scene()
