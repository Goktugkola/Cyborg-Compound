extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_QUIT_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_PLAY_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/livil10.tscn")
	pass # Replace with function body.


func _on_OPTIONS_pressed():
	
	pass # Replace with function body.
