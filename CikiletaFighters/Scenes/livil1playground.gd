extends Node2D
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().change_scene("res://Scenes/livil10.tscn")

	if($Player1/HealthBar.value <= 0 || $Player2/HealthBar.value <= 0):
		get_tree().change_scene("res://Scenes/livil10.tscn")