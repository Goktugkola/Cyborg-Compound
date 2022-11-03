extends Node2D

func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	if($Player1/HealthBar.value <= 0):
		$RichTextLabel.add_text("PLAYER 2 WON")
		yield (get_tree().create_timer(10),"timeout")
	if($Player2/HealthBar.value <= 0):
		$RichTextLabel.add_text("PLAYER 1 WON")
		yield (get_tree().create_timer(10),"timeout")
	
	
	$Camera2D.transform.xform($Player1.position.x)
	if($Player1/HealthBar.value <= 0 || $Player2/HealthBar.value <= 0):
		get_tree().reload_current_scene()
