extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# warning-ignore:unused_argument
func _on_CheckButton_toggled(button_pressed):
	OS.set_window_fullscreen(!OS.window_fullscreen)
	pass # Replace with function body.
