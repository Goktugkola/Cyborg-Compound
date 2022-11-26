class_name Projectile
extends Node2D

export var speed:= 1000.0
export var lifetime:= 3.0

var velocity:= Vector2()

onready var timer:= $Timer
onready var impact_detectorb:= $sprite_b/impactDetector_b

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed , 0)
	self.translate(velocity * delta)
