extends KinematicBody2D
var speed = 300
var gravity = 300
var _velocity := Vector2.ZERO
var jump = false
export var fall_gravity_scale := 150.00
export var jump_power := 200.0
var double_jump = 0
export var Health = 100
var shape_pos
func _ready():
	shape_pos = $hitboxpivot/swordhitbox/CollisionShape2D.position.x
pass
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity,Vector2.UP)
	var _horizontal_direction =(
	Input.get_action_strength("ui_right")
	- Input.get_action_strength("ui_left")
	)
	$HealthBar.value = Health
	if _velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = -shape_pos
	if _velocity.x > 0:
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = shape_pos
		$AnimatedSprite.flip_h = false
	if Input.is_action_pressed("ui_walk"):
		speed = 100
	else:
		speed = 300
	_velocity.x = _horizontal_direction * speed
	if is_on_floor():
		if _velocity.x == 300 or _velocity.x == -300:
			$AnimatedSprite.play("Run")
		elif _velocity.x == 100 or _velocity.x == -100:
			$AnimatedSprite.play("Walk")
		else:
			$AnimatedSprite.play("Idle")
	if Input.is_action_just_pressed("p2_melee"):
			$hitboxpivot/swordhitbox/CollisionShape2D.disabled = false
			yield (get_tree().create_timer(0.1),"timeout")
			$hitboxpivot/swordhitbox/CollisionShape2D.disabled = true

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		_velocity.y = -jump_power
		jump = true
		double_jump = 1
		yield (get_tree().create_timer(1),"timeout")
	if double_jump == 1 and Input.is_action_just_pressed("ui_up"):
		_velocity.y = -jump_power
		double_jump = 0
	if jump == true:
		$AnimatedSprite.play("JumpInAir")
	if is_on_floor():
		jump = false
		
func _on_Hurtbox_area_entered(_area):
	Health -=10
	print(Health)
	
