extends Node2D

var is_paused = false setget set_is_paused
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		self.is_paused = !is_paused
func set_is_paused(_value):
	is_paused = _value
	get_tree().paused = is_paused
	visible = is_paused


func _on_Button_pressed():
	self.is_paused = false
	visible = is_paused
	pass # Replace with function body.


func _on_Button2_pressed():
	get_tree().quit()
	pass # Replace with function body.
