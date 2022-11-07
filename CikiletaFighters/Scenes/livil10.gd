extends Node2D
var once : bool = true


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	$Livil1Ui/HealthBar1.value = $livil1playground/Player1/HealthBar.value
	$Livil1Ui/HealthBar2.value = $livil1playground/Player2/HealthBar.value
	if($livil1playground/Player1/HealthBar.value <= 0 && once == true):
		$Livil1Ui/WhoWin.add_text("PLAYER 2 WON")
		once = false
		G.p1wonstatus = G.p1wonstatus + 1
		$Livil1Ui/p1winstatus.clear()
		$Livil1Ui/p1winstatus.add_text("P1 Win Count : ")

	elif($livil1playground/Player2/HealthBar.value <= 0 && once == true):
		$Livil1Ui/WhoWin.add_text("PLAYER 1 WON")
		once = false
		G.p2wonstatus = G.p2wonstatus + 1
		$Livil1Ui/p2winstatus.clear()
		$Livil1Ui/p2winstatus.add_text("P2 Win Count : ")
	if Input.is_action_just_pressed("reset"):
		G.x = G.x + 1
		print(G.x)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
