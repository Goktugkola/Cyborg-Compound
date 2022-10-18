extends KinematicBody2D
var speed = 300
var gravity = 300
var _velocity := Vector2.ZERO
var jump = false
export var fall_gravity_scale := 150.00
export var jump_power := 200.0
var double_jump = 0


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity,Vector2.UP)
	var _horizontal_direction =(
	Input.get_action_strength("ui_right")
	- Input.get_action_strength("ui_left")
	)
	
	if Input.is_action_just_pressed("ui_left"):
		$AnimatedSprite.flip_h = true
	if Input.is_action_just_pressed("ui_right"):
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

	if Input.is_action_just_released("ui_up") and is_on_floor():
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
	
