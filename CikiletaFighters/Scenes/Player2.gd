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
const bullet_path = preload('bullet2.tscn')
var bullet_x
var direction : bool = true
var knockbacktime = 0
var duck : bool = false
func is_fallen():
	return $DeathlineChecker.is_colliding()
func is_on_wall():
	if $Wallchecker.is_colliding():
		gravity =200
		double_jump =1
	else:
		gravity =300
func _ready():
	shape_pos = $hitboxpivot/swordhitbox/CollisionShape2D.position.x
	bullet_x = $Node2D/Position2D.position.x
pass
func move(delta):
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity,Vector2.UP)
func _shoot():
	var bullet =  bullet_path.instance()
	yield(get_tree(), "idle_frame")
	get_parent().get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
func _physics_process(delta: float) -> void:
	if is_fallen():
		Health = 0
	is_on_wall()
	G.P2_velocity = _velocity
	G.p2_direction = direction
	G.p2_position = get_node(".").position
	if !duck:
		move(delta)
		
	var _horizontal_direction =(
	Input.get_action_strength("ui_right")
	- Input.get_action_strength("ui_left")
	)
	$HealthBar.value = Health
	#Animation,walk,run,idle
	if _velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$Node2D/Position2D.position.x = -bullet_x
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = -shape_pos
		$Wallchecker.rotation_degrees = 90
		direction = false
	if _velocity.x > 0:
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = shape_pos
		$AnimatedSprite.flip_h = false
		direction = true
		$Node2D/Position2D.position.x = bullet_x
		$Wallchecker.rotation_degrees = -90
	if Input.is_action_pressed("ui_walk"):
		speed = 100
	else:
		speed = 300
	_velocity.x = _horizontal_direction * speed
	if is_on_floor():
		if _velocity.x == 300 and !duck or _velocity.x == -300 and !duck:
			$AnimatedSprite.play("Run")
		elif _velocity.x == 100 and !duck or _velocity.x == -100 and !duck:
			$AnimatedSprite.play("Walk")
		else:
			$AnimatedSprite.play("Idle")
	if Input.is_action_just_pressed("p2_melee"):
			$hitboxpivot/swordhitbox/CollisionShape2D.disabled = false
			$Timer.start(0.1); yield($Timer, "timeout")
			$hitboxpivot/swordhitbox/CollisionShape2D.disabled = true
	# BULLET!
	if Input.is_action_just_pressed("p2_shoot"):
		_shoot()
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		_velocity.y = -jump_power
		jump = true
		double_jump = 1
		$Timer.start(1); yield($Timer, "timeout")
	if double_jump == 1 and Input.is_action_just_pressed("ui_up"):
		_velocity.y = -jump_power
		double_jump = 0
	if jump == true:
		$AnimatedSprite.play("JumpInAir")
	if is_on_floor():
		jump = false
	if _velocity.y != 0:
		$AnimatedSprite.play("JumpInAir")
		#Duck
		if is_on_floor():
			if Input.is_action_pressed("p2_duck"):
				$Hurtbox/CollisionShape2D.set_deferred("disabled",true)
				$DuckHurtBox/CollisionShape2D.set_deferred("disabled", false)
				duck = true
			if Input.is_action_just_released("p2_duck"):
				$Hurtbox/CollisionShape2D.set_deferred("disabled",false)
				$DuckHurtBox/CollisionShape2D.set_deferred("disabled", true)
				duck = false

func _on_Hurtbox_area_entered(_area):
	yield(get_tree(), "idle_frame")
	Health -=10
	if G.p1_position.x > G.p2_position.x:
		_velocity.x = 0
		get_node(".").position.x -= 20
	else:
		_velocity.x = 0
		get_node(".").position.x += 20
	
