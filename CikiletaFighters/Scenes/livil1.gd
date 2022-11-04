extends Node2D
var once : bool = true
var p1wonstatus = 1
var p2wonstatus = 1
var t = Timer. new()
func _ready():
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	pass # Replace with function body.

func _physics_process(_delta):
	if($Player1/HealthBar.value <= 0 && once == true):
		$Livil1Ui/WhoWin.add_text("PLAYER 2 WON")
		once = false
		p1wonstatus = p1wonstatus + 1
		$Livil1Ui/p1winstatus.clear()
		$Livil1Ui/p1winstatus.add_text("P1 Win Count : ")
		t.start()
		yield (t,"timeout")

	elif($Player2/HealthBar.value <= 0 && once == true):
		$Livil1Ui/WhoWin.add_text("PLAYER 1 WON")
		once = false
		p2wonstatus = p2wonstatus + 1
		$Livil1Ui/p2winstatus.clear()
		$Livil1Ui/p2winstatus.add_text("P2 Win Count : ")
		t.start()
		yield(t,"timeout")
	if($Player1/HealthBar.value <= 0 || $Player2/HealthBar.value <= 0):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
