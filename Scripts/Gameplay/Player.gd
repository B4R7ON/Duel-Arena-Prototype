extends CharacterBody2D

@export var hp : float
@export var speed : float
@export var attacking_speed : float
var actual_speed
var weight = 0

var smooth_mouse_position : Vector2
var mouse_direction : Vector2

var move_velocity : Vector2
var knock_velocity : Vector2
@export var friction : float

# RESET VARIABLES
var reset_position : Vector2
var reset_hp : float


func _ready():
	LivesSystem.player_max_lives = hp
	LivesSystem.player_lives = hp
	
	RoundsManager.player = self
	reset_position = position
	reset_hp = hp


func reset():
	weight = 0
	$DeathParticles.emitting = false
	
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	knock_velocity = Vector2.ZERO
	position = reset_position
	hp = reset_hp
	await get_tree().create_timer(1).timeout
	$CollisionShape2D.set_deferred("disabled", false)
	# NOTA: Los Timers y CollisionShapes son para 
	# evitar un bug de los knockbacks al pasar de ronda


func _process(delta):
	if Engine.time_scale > 0:
		animation_controller()


func _physics_process(delta):
	move()
	if Engine.time_scale > 0:
		look_at_mouse()


func _input(event):
	if Input.is_action_just_pressed("left_hand"):
		weight_change()
	if Input.is_action_just_pressed("right_hand"):
		weight_change()
	if Input.is_action_just_pressed("drop_item"):
		weight_change()


func move():
	velocity = Vector2.ZERO
	
	if not $Pivot/LeftHand.can_attack or not $Pivot/RightHand.can_attack:
		actual_speed = attacking_speed
	else:
		actual_speed = speed
	
	actual_speed = clamp(actual_speed, 0, 300)
	weight = clamp(weight, 0, 200)
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	move_velocity = velocity.normalized() * (actual_speed - weight)
	knock_velocity = apply_friction(knock_velocity, friction)
	
	if knock_velocity != Vector2.ZERO:
		move_velocity = Vector2.ZERO
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		if collision.get_collider().name == "Rival":
			bounce(collision.get_collider())
	
	velocity = move_velocity + knock_velocity
	move_and_slide()


func apply_friction(knockback, friction_amount):
	if knockback.length_squared() > friction_amount**2:
		knockback -= knockback.normalized() * friction_amount
	else:
		knockback = Vector2.ZERO
	return knockback


func bounce(body : CharacterBody2D):
	var direction = Vector2()
	direction.x = body.position.x - self.position.x
	direction.y = body.position.y - self.position.y
	
	knock_velocity = direction * -5
	body.knock_velocity = direction * 5


func look_at_mouse():
	smooth_mouse_position = lerp(smooth_mouse_position, get_global_mouse_position(), 0.75)
	$Pivot.look_at(smooth_mouse_position)
	
	mouse_direction = get_global_mouse_position() - position


func weight_change():
	weight = $Pivot/LeftHand.weight + $Pivot/RightHand.weight
	#print("PLAYER WEIGHT: ", weight)


func hit_flash():
	$AnimatedHead.self_modulate = Color(1, 1, 1, 0)
	$AnimatedBody.self_modulate = Color(1, 1, 1, 0)
	
	await get_tree().create_timer(0.1).timeout
	
	$AnimatedHead.self_modulate = Color(1, 1, 1, 1)
	$AnimatedBody.self_modulate = Color(1, 1, 1, 1)
	
	await get_tree().create_timer(0.1).timeout
	
	$AnimatedHead.self_modulate = Color(1, 1, 1, 0)
	$AnimatedBody.self_modulate = Color(1, 1, 1, 0)
	
	await get_tree().create_timer(0.1).timeout
	
	$AnimatedHead.self_modulate = Color(1, 1, 1, 1)
	$AnimatedBody.self_modulate = Color(1, 1, 1, 1)


func animation_controller():
	if mouse_direction.y > 0 and (abs(mouse_direction.y) > abs(mouse_direction.x)):
		$AnimatedHead.play("look_down")
	else:
		if mouse_direction.x >= 0:
			if mouse_direction.y >= 0:
				$AnimatedHead.play("look_right_bottom")
			else:
				$AnimatedHead.play("look_right")
		else:
			if mouse_direction.y >= 0:
				$AnimatedHead.play("look_left_bottom")
			else:
				$AnimatedHead.play("look_left")
	
	if velocity == Vector2.ZERO:
		if mouse_direction.y > 0 and (abs(mouse_direction.y) > abs(mouse_direction.x)):
			$AnimatedBody.play("look_down")
		else:
			if mouse_direction.x >= 0:
				if mouse_direction.y >= 0:
					$AnimatedBody.play("look_right_bottom")
				else:
					$AnimatedBody.play("look_right")
			else:
				if mouse_direction.y >= 0:
					$AnimatedBody.play("look_left_bottom")
				else:
					$AnimatedBody.play("look_left")
	else:
		if mouse_direction.y > 0 and (abs(mouse_direction.y) > abs(mouse_direction.x)):
			$AnimatedBody.play("walk_down")
		else:
			if mouse_direction.x >= 0:
				if mouse_direction.y >= 0:
					$AnimatedBody.play("walk_right_bottom")
				else:
					$AnimatedBody.play("walk_right")
			else:
				if mouse_direction.y >= 0:
					$AnimatedBody.play("walk_left_bottom")
				else:
					$AnimatedBody.play("walk_left2")
