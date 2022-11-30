extends Node2D

var dash_delay = 0.3
onready var DurationTimer = $DurationTimer
var can_dash = true

func start_dash(duration):
	DurationTimer.wait_time = duration
	DurationTimer.start()


func _is_dashing():
	return !DurationTimer.is_stopped()


func end_dash():
	can_dash = false
	yield(get_tree().create_timer(dash_delay),"timeout")
	can_dash = true



func _on_DurationTimer_timeout() -> void:
	end_dash()

