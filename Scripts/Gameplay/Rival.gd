extends CharacterBody2D

@export var hp : float
@export var speed : float
@export var attacking_speed : float
var actual_speed
var weight = 0

@export var player : CharacterBody2D
var smooth_player_position : Vector2

@export var left_weapon : Node2D
@export var right_weapon : Node2D

var move_velocity : Vector2
var knock_velocity : Vector2
@export var friction : float

# RESET VARIABLES
var reset_position : Vector2
var reset_hp : float


func _ready():
	LivesSystem.rival_lives = hp
	LivesSystem.rival_max_lives = hp
	
	RoundsManager.rival = self
	reset_position = position
	reset_hp = hp


func reset():
	$DeathParticles.emitting = false
	
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	knock_velocity = Vector2.ZERO
	position = reset_position
	hp = reset_hp
	weight = 0
	left_weapon = null
	right_weapon = null
	await get_tree().create_timer(1).timeout
	$CollisionShape2D.set_deferred("disabled", false)
	# NOTA: Los Timers y CollisionShapes son para 
	# evitar un bug de los knockbacks al pasar de ronda


func _process(delta):
	if left_weapon:
		#left_weapon.equipped = true
		$Pivot/LeftHand.holding(left_weapon)
	
	if right_weapon:
		#right_weapon.equipped = true
		$Pivot/RightHand.holding(right_weapon)


func move(delta=1):
	var rotation = Vector2.RIGHT.rotated($Pivot.rotation)
	
	if not $Pivot/LeftHand.can_attack or not $Pivot/RightHand.can_attack:
		actual_speed = attacking_speed
	else:
		actual_speed = speed
	
	actual_speed = clamp(actual_speed, 0, 300)
	weight = clamp(weight, 0, 200)
	
	move_velocity = rotation * (actual_speed - weight) * delta
	knock_velocity = apply_friction(knock_velocity, friction)

	if knock_velocity != Vector2.ZERO:
		move_velocity = Vector2.ZERO

	velocity = move_velocity + knock_velocity
	move_and_slide()


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


func apply_friction(knockback, friction_amount):
	if knockback.length_squared() > friction_amount**2:
		knockback -= knockback.normalized() * friction_amount
	else:
		knockback = Vector2.ZERO
	return knockback


#func _on_hand_pick():
	#weight = $Pivot/LeftHand.weight + $Pivot/RightHand.weight
	##print(weight)


func weight_change():
	weight = $Pivot/LeftHand.weight + $Pivot/RightHand.weight
	#print("RIVAL WEIGHT: ", weight)
