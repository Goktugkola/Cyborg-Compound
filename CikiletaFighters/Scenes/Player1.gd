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
var duck: bool = false
var combo = 0
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
	if is_fallen():
		Health = 0
	is_on_wall()
	G.P1_velocity = _velocity
	G.p1_direction = direction
	G.p1_position = get_node(".").position
	if !duck:
		move(delta)
	
	var _horizontal_direction =(
	Input.get_action_strength("p1_right")
	- Input.get_action_strength("p1_left")
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
	if Input.is_action_pressed("p1_walk"):
		speed = 100
	else:
		speed = 300
	
	if is_on_floor():
		if _velocity.x == 300 and !duck or _velocity.x == -300 and !duck:
			$AnimatedSprite.play("Run")
		elif _velocity.x == 100 and !duck or _velocity.x == -100 and !duck:
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
		$AnimatedSprite.play("Jump")
		$Timer.start(1); yield($Timer, "timeout")
	if Input.is_action_just_released("p1_up") and _velocity.y < 0:
			_velocity.y/=2
	if double_jump == 1 and Input.is_action_just_pressed("p1_up"):
		$AnimatedSprite.play("JumpInAir")
		_velocity.y = -jump_power
		double_jump = 0
	if is_on_floor():
		jump = false
	if _velocity.y != 0:
		$AnimatedSprite.play("JumpInAir")

	#####Duck#####
	if is_on_floor():
		if Input.is_action_pressed("p1_duck"):
			$Hurtbox/CollisionShape2D.set_deferred("disabled",true)
			$DuckHurtBox/CollisionShape2D.set_deferred("disabled", false)
			duck = true
		if Input.is_action_just_released("p1_duck"):
			$Hurtbox/CollisionShape2D.set_deferred("disabled",false)
			$DuckHurtBox/CollisionShape2D.set_deferred("disabled", true)
			duck = false

func _on_Hurtbox_area_entered(_area):
	yield(get_tree(), "idle_frame")
	Health -=10
	if G.p1_position.x < G.p2_position.x:
		_velocity.x = 0
		get_node(".").position.x -= 20
	else:
		_velocity.x = 0
		get_node(".").position.x += 20

