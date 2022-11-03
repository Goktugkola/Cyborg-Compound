extends Node2D

func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	$Camera2D.transform.xform($Player1.position.x)
	if($Player1/HealthBar.value <= 0 || $Player2/HealthBar.value <= 0):
		get_tree().reload_current_scene()
