extends State
class_name RivalAttack

@export var rival : CharacterBody2D
var left_weapon
var right_weapon

var player_from_left_range
var player_from_right_range


func Enter():
	#left_weapon = rival.left_weapon
	#right_weapon = rival.right_weapon
	
	player_from_left_range = null
	player_from_right_range = null


func Update(delta: float):
	rival.move(0)
	
	left_weapon = rival.left_weapon
	right_weapon = rival.right_weapon
	
	if left_weapon != null:
		rival.get_node("Pivot/LeftHand").weapon_attack(left_weapon, "action_animation_left")
		player_from_left_range = left_weapon.player_in_range
	else:
		player_from_left_range = null
	
	if right_weapon != null:
		rival.get_node("Pivot/RightHand").weapon_attack(right_weapon, "action_animation_right")
		player_from_right_range = right_weapon.player_in_range
	else :
		player_from_right_range = null
	
	if player_from_left_range == null and player_from_right_range == null:
		Transitioned.emit(self, "Chase")
	
	# TRANSICION NUEVO ESTADO DESARMADO
	if (left_weapon == null) and (right_weapon == null):
		Transitioned.emit(self, "Disarmed")


func Exit():
	pass
	#if left_weapon:
		#left_weapon.get_node("AnimationPlayer").stop()
	#if right_weapon:
		#right_weapon.get_node("AnimationPlayer").stop()
