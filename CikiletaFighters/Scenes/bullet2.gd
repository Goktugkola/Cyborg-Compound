class_name Projectile2
extends Node2D
var once : bool = true
export var speed:= 1000.0
export var lifetime:= 1.0

var velocity:= Vector2()

onready var timer:= $Timer
onready var hitbox:= $hitbox_b
onready var sprite:= $sprite_b
onready var impact_detectorb:= $sprite_b/impactDetector_b

func _ready():
	set_as_toplevel(true)
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "queue_free")
	timer.start(lifetime)
	
# warning-ignore:return_value_discarded
	impact_detectorb.connect("body_entered",self, "_on_impact")

func _physics_process(delta: float) -> void:
	if G.p2_direction == true and once:
		velocity = Vector2(speed , 0)
		once = false
	if G.p2_direction == false and once:
		velocity = Vector2(-speed, 0)
		$sprite_b.flip_h = true
		once = false
	self.translate(velocity * delta)

func _on_impact(_body: Node) -> void:
	queue_free()



func _on_impactDetector_b_area_entered(area):
	queue_free()
