extends KinematicBody2D
var speed = 300
var gravity = 300
var _velocity = Vector2.ZERO
var jump = false
export var jump_power := 200.0
var double_jump = 0
var Health = 100
var shape_pos
func _ready():
		shape_pos = $hitboxpivot/swordhitbox/CollisionShape2D.position.x
	
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity,Vector2.UP)
	var _horizontal_direction =(
	Input.get_action_strength("p1_right")
	- Input.get_action_strength("p1_left")
	)
	#animation walk,run,idle
	if _velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = -shape_pos
	if _velocity.x > 0:
		$AnimatedSprite.flip_h = false
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = shape_pos
	if Input.is_action_pressed("p1_walk"):
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
			
	###### CCC MELEE ATACK CCC ######
		if Input.is_action_just_pressed("p1_melee"):
			$hitboxpivot/swordhitbox/CollisionShape2D.disabled = false
			yield (get_tree().create_timer(0.1),"timeout")
			$hitboxpivot/swordhitbox/CollisionShape2D.disabled = true
			
	
	if Input.is_action_just_pressed("p1_up") and is_on_floor():
		_velocity.y = -jump_power
		jump = true
		double_jump = 1
		yield (get_tree().create_timer(0.5),"timeout")
	if Input.is_action_just_released("p1_up") and _velocity.y < 0:
			_velocity.y/=2
	if double_jump == 1 and Input.is_action_just_pressed("p1_up"):
		_velocity.y = -jump_power
		double_jump = 0
	if jump == true:
		$AnimatedSprite.play("JumpInAir")
	if is_on_floor():
		jump = false
	if _velocity.y != 0:
		$AnimatedSprite.play("JumpInAir")
	
func _on_Hurtbox_area_entered(area):
	Health -=5
	print(Health)
	pass # Replace with function body.
