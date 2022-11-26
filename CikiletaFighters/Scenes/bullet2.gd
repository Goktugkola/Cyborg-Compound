class_name Projectile2
extends Node2D
var once : bool = true
export var speed:= 1000.0
export var lifetime:= 3.0

var velocity:= Vector2()

onready var timer:= $Timer
onready var impact_detectorb:= $sprite_b/impactDetector_b

func _physics_process(delta: float) -> void:
	
	if G.p2_direction == true and once:
		velocity = Vector2(speed , 0)
		once = false
	if G.p2_direction == false and once:
		velocity = Vector2(-speed, 0)
		once = false
	self.translate(velocity * delta)
