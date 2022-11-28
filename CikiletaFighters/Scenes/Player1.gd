extends KinematicBody2D
var speed = 300
var gravity = 300
var _velocity = Vector2.ZERO
var jump = false
export var jump_power := 200.0
var double_jump = 0
export var Health = 100
var shape_pos
const bullet_path = preload('bullet.tscn')
var bullet_x
var direction : bool = true
var knockbacktime = 0

func _shoot():
	var bullet =  bullet_path.instance()
	
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
func _ready():
		shape_pos = $hitboxpivot/swordhitbox/CollisionShape2D.position.x
		bullet_x = $Node2D/Position2D.position.x

pass
func _physics_process(delta: float) -> void:
	G.P1_velocity = _velocity
	G.p1_direction = direction
	G.p1_position = get_node(".").position
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity,Vector2.UP)
	var _horizontal_direction =(
	Input.get_action_strength("p1_right")
	- Input.get_action_strength("p1_left")
	)
	##Health Bar##
	$HealthBar.value = Health
	#animation walk,run,idle
	if _velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$Node2D/Position2D.position.x = -bullet_x
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = -shape_pos
		direction = false
	if _velocity.x > 0:
		$AnimatedSprite.flip_h = false
		$hitboxpivot/swordhitbox/CollisionShape2D.position.x = shape_pos
		$Node2D/Position2D.position.x = bullet_x
		direction = true
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
		$Timer.start(0.1); yield($Timer, "timeout")
		$hitboxpivot/swordhitbox/CollisionShape2D.disabled = true
	# BULLET!
	if Input.is_action_just_pressed("p1_shoot"):
		_shoot()
		#jump
	if Input.is_action_just_pressed("p1_up") and is_on_floor():
		_velocity.y = -jump_power
		jump = true
		double_jump = 1
		$Timer.start(1); yield($Timer, "timeout")
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

		#####Duck#####
	if Input.is_action_pressed("p1_duck"):
		$Hurtbox/CollisionShape2D.set_deferred("disabled",true)
		$DuckHurtBox/CollisionShape2D.set_deferred("disabled", false)
	if Input.is_action_just_released("p1_duck"):
			$Hurtbox/CollisionShape2D.set_deferred("disabled",false)
			$DuckHurtBox/CollisionShape2D.set_deferred("disabled", true)

func _on_Hurtbox_area_entered(_area):
	Health -=10
	if G.p1_position.x < G.p2_position.x:
		_velocity.x = 0
		get_node(".").position.x -= (1 / ( Health + 1 ) * 20 ) 
	else:
		_velocity.x = 0
		get_node(".").position.x += 20

