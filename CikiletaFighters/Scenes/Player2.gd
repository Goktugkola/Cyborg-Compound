extends KinematicBody2D

var gravity = 300
var _velocity = Vector2.ZERO
var jump = false
export var jump_power := 200.0
var double_jump = 0
export var Health = 100
var shape_pos
const bullet_path = preload('bullet2.tscn')
var bullet_x
var direction : bool = true
var knockbacktime = 0
var duck: bool = false
var combo = 0
const dash_speed =400
const dash_duration = 0.4
onready var dash = $Dash
var is_attacking: bool = false
var jump_dash: bool = false
func melee():
		###### CCC MELEE ATACK CCC ######
	if Input.is_action_just_pressed("p2_melee") and !duck:
		is_attacking = true
		combo += 1
		$hitboxpivot/swordhitbox/CollisionShape2D.disabled = false
		$Timer.start(0.1); yield($Timer, "timeout")
		$hitboxpivot/swordhitbox/CollisionShape2D.disabled = true
		if combo == 1:
			$AnimatedSprite.play("punch1")

		elif combo == 2:
			$AnimatedSprite.play("punch2")

		elif combo == 3:
			$AnimatedSprite.play("uppercut")
			combo = 0
func is_fallen():
	return $Deathlinechecker.is_colliding()
func is_on_wall():
	if $Wallchecker.is_colliding():
		gravity =300
		double_jump =1
	else:
		gravity =400
func _shoot():
	var bullet =  bullet_path.instance()
	get_parent().get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
func _ready():
		shape_pos = $hitboxpivot/swordhitbox/CollisionShape2D.position.x
		bullet_x = $Node2D/Position2D.position.x
		
func move(delta):
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity,Vector2.UP)

pass
func _physics_process(delta: float) -> void:
	var speed = dash_speed if dash._is_dashing() else 300
	if is_fallen():
		Health = 0
	is_on_wall()
	G.P2_velocity = _velocity
	G.p2_direction = direction
	G.p2_position = get_node(".").position
	if !duck:
		move(delta)
		melee()
	var _horizontal_direction =(
	Input.get_action_strength("ui_right")
	- Input.get_action_strength("ui_left")
	)
	_velocity.x = _horizontal_direction * speed
	$HealthBar.value = Health
	#animation walk,run,idle
	if _velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$Node2D/Position2D.position.x = -bullet_x
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = -shape_pos
		direction = false
		$Wallchecker.rotation_degrees = 90
	if _velocity.x > 0:
		$AnimatedSprite.flip_h = false
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = shape_pos
		$Node2D/Position2D.position.x = bullet_x
		direction = true
		$Wallchecker.rotation_degrees = -90
	if Input.is_action_pressed("ui_walk"):
		speed = 100
	else:
		speed = 300
	
	if is_on_floor():
		if _velocity.x == 300 and !duck or _velocity.x == -300 and !duck:
			$AnimatedSprite.play("Run")
		elif _velocity.x == 100 and !duck or _velocity.x == -100 and !duck:
			$AnimatedSprite.play("Walk")
		elif !dash._is_dashing() and !duck and !is_attacking:
			$AnimatedSprite.play("Idle")
			

	# BULLET!
	if Input.is_action_just_pressed("p2_shoot"):
		_shoot()
		#jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		_velocity.y = -jump_power
		jump = true
		double_jump = 1
		$AnimatedSprite.play("Jump")
		$Timer.start(1); yield($Timer, "timeout")
	if Input.is_action_just_released("ui_up") and _velocity.y < 0:
			_velocity.y/=2
	if double_jump == 1 and Input.is_action_just_pressed("ui_up"):
		$AnimatedSprite.play("JumpInAir")
		_velocity.y = -jump_power
		double_jump = 0
	if is_on_floor():
		jump = false
	if _velocity.y != 0 and jump_dash == false:
		$AnimatedSprite.play("JumpInAir")

	#####Duck#####
	if is_on_floor():
		if Input.is_action_pressed("p2_duck"):
			$AnimatedSprite.play("Duck")
			$Hurtbox/CollisionShape2D.set_deferred("disabled",true)
			$DuckHurtBox/CollisionShape2D.set_deferred("disabled", false)
			duck = true
		if Input.is_action_just_released("p2_duck"):
			$AnimatedSprite.play("standing_up")
			$Hurtbox/CollisionShape2D.set_deferred("disabled",false)
			$DuckHurtBox/CollisionShape2D.set_deferred("disabled", true)
			duck = false
	_Dodge()

func _on_Hurtbox_area_entered(_area):
	yield(get_tree(), "idle_frame")
	Health -=10
	knockback()
func knockback():
		if G.p1_position.x > G.p2_position.x:
			_velocity.x = 0
			get_node(".").position.x -= 20
		else:
			_velocity.x = 0
			get_node(".").position.x += 20

func _Dodge()->void:
	if Input.is_action_just_pressed("p2_dodge") and dash.can_dash and !dash._is_dashing() and is_on_floor():
		$AnimatedSprite.play("Dodge")
		dash.start_dash(dash_duration)
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		$Timer.start(0.2); yield($Timer, "timeout")
		$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
	elif Input.is_action_just_pressed("p2_dodge") and dash.can_dash and !dash._is_dashing():
		jump_dash = true
		dash.start_dash(dash_duration)
		$AnimatedSprite.play("AirDodge")
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		$Timer.start(0.2); yield($Timer, "timeout")
		$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
		jump_dash = false



func _on_AnimatedSprite_animation_finished():
	if !duck and is_on_floor():
		is_attacking = false
		$AnimatedSprite.play("Idle")
	if jump_dash == false and !is_on_floor():
		$AnimatedSprite.play("JumpInAir")
	pass # Replace with function body.
