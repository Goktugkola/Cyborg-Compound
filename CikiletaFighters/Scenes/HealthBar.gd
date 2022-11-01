extends Control
onready var update_tween = $UpdateTween
onready var health_bar = $HealthBar
onready var health_under = $HealthUnder
onready var health_over = $HealthOver
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2
export (Color) var Healty_color = Color.green
export (Color) var Caution_color = Color.yellow
export (Color) var Danger_color = Color.red

func on_health_updated(health, amount):
	#health_bar.value = health
	health_over.value = health
	update_tween.interpolate_property(health_under, "value", health_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	_assign_color(health)
func _assign_color(health):
	if health < health_over.max_value * danger_zone:
		health_over.tint_progress = Danger_color
	elif health < health_over.max_value * caution_zone:
		health_over.tint_progress = Caution_color
	else:
		health_over.tint_progress = Healty_color
func on_max_health_updated(max_health):
	health_over.max_value = max_health
	health_under.max_value = max_health
