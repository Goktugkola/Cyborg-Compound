extends Node2D

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if Input.is_action_just_pressed("reset"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/livil10.tscn")


