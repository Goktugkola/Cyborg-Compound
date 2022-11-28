extends Control

var is_paused = false setget set_is_paused
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		self.is_paused = !is_paused
func set_is_paused(_value):
	is_paused = _value
	get_tree().paused = is_paused
	visible = is_paused
