extends Node2D


var once : bool = true
func _ready():
	$Livil1Ui/p1winstatus.add_text(str(G.p1wonstatus))
	$Livil1Ui/p2winstatus.add_text(str(G.p2wonstatus))
	pass # Replace with function body.

func _process(_delta):
	$Livil1Ui/HealthBar1.value = $livil1playground/Player1/HealthBar.value
	$Livil1Ui/HealthBar2.value = $livil1playground/Player2/HealthBar.value
	if($livil1playground/Player1/HealthBar.value <= 0 && once == true):
		$Livil1Ui/WhoWin.add_text("PLAYER 2 WON")
		once = false
		$Timer.start(2); yield($Timer, "timeout")
		G.p1wonstatus += 1
		$Livil1Ui/p1winstatus.clear()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/livil10.tscn")
	if($livil1playground/Player2/HealthBar.value <= 0 && once == true):
		$Livil1Ui/WhoWin.add_text("PLAYER 1 WON")
		once = false
		$Timer.start(2); yield($Timer, "timeout")
		G.p2wonstatus += 1
		$Livil1Ui/p2winstatus.clear()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/livil10.tscn")
	if Input.is_action_just_pressed("reset"):
		G.x = G.x + 1
		print(G.x)
	print(G.p1_position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


