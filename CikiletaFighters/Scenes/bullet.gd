class_name Projectile
extends Node2D

export var speed:= 1000.0
export var lifetime:= 3.0

var direction:= Vector2.ZERO

onready var timer:= $Timer
onready var hitbox_b:= $sprite_b/hitbox_b
onready var sprite_b:= $sprite_b
onready var impact_detectorb:= $sprite_b/impactDetector_b

func _ready():
	set_as_toplevel(true)
	
