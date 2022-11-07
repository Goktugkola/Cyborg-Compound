extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	$Livil1Ui/HealthBar1.value = $livil1playground/Player1/HealthBar.value
	$Livil1Ui/HealthBar2.value = $livil1playground/Player2/HealthBar.value
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
