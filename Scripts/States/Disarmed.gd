extends State
class_name Disarmed

@export var rival : CharacterBody2D
@export var pivot : Node2D
@export var animated_head : AnimatedSprite2D
@export var animated_body : AnimatedSprite2D

var weapons_dictionary : Dictionary = {}
var closest_weapon : Node2D
var weapon_direction

var player
var smooth_player_position : Vector2
var player_direction : Vector2


func _ready():
	player = rival.player


func Physics_Update(delta : float):
	if closest_weapon:
		if Engine.time_scale > 0:
			look_at_weapon()
			if rival.velocity != Vector2.ZERO:
				play_animations("walk")
			else:
				play_animations("idle")
		rival.move()
	else:
		if Engine.time_scale > 0:
			look_at_player()
			play_animations("idle")
		rival.move(0)


func Update(delta: float):
	if not RoundsManager.moving_to_next_round:
		find_all_weapons()
		find_closest_weapon()
	
	for i in weapons_dictionary:
		if is_instance_valid(i) == false:
			weapons_dictionary.erase(i)
	
	# Siempre equipa primero la mano IZQUIERDA y luego la DERECHA por el orden de las lineas
	rival.get_node("Pivot/LeftHand").pick_weapon("left_hand")
	rival.get_node("Pivot/RightHand").pick_weapon("right_hand")
	
	if rival.left_weapon and rival.right_weapon: # AMBAS armas equipadas
		Transitioned.emit(self, "Chase")
		pass
	
	if rival.left_weapon and not rival.right_weapon:
		if is_instance_valid(closest_weapon):
			var area_pos = closest_weapon.to_global(closest_weapon.get_node("Weapon").position)
			if player.position.distance_to(rival.position) < area_pos.distance_to(rival.position):
				Transitioned.emit(self, "Chase")
				pass
		else:
			Transitioned.emit(self, "Chase")


func find_all_weapons():
	for child in get_node("../../../Weapons").get_children():
		if child is Weapon:
			if child.equipped == false:
				weapons_dictionary[child] = child.position.distance_to(rival.position)
			else:
				weapons_dictionary.erase(child)


func find_closest_weapon():
	for weapon in weapons_dictionary:
		if weapons_dictionary.get(weapon) == weapons_dictionary.values().min():
			if is_instance_valid(weapon):
				closest_weapon = weapon
	if is_instance_valid(closest_weapon):
		if closest_weapon.equipped:
			closest_weapon = null


func look_at_weapon():
	if is_instance_valid(closest_weapon):
		pivot.look_at(closest_weapon.to_global(closest_weapon.get_node("Weapon").position))
		weapon_direction = closest_weapon.to_global(closest_weapon.get_node("Weapon").position) - rival.position


func look_at_player():
	smooth_player_position = lerp(smooth_player_position, player.position, 0.05)
	pivot.look_at(smooth_player_position)
	player_direction = smooth_player_position - rival.position


func play_animations(name : String):
	if name == "walk":
		if weapon_direction:
			if weapon_direction.y > 0 and (abs(weapon_direction.y) > abs(weapon_direction.x)):
				animated_head.play("look_down")
				animated_body.play("walk_down")
			else:
				if weapon_direction.x >= 0:
					if weapon_direction.y >= 0:
						animated_head.play("look_right_bottom")
						animated_body.play("walk_right_bottom")
					else:
						animated_head.play("look_right")
						animated_body.play("walk_right")
				else:
					if weapon_direction.y >= 0:
						animated_head.play("look_left_bottom")
						animated_body.play("walk_left_bottom")
					else:
						animated_head.play("look_left")
						animated_body.play("walk_left")
	elif name == "idle":
		if player_direction.y > 0 and (abs(player_direction.y) > abs(player_direction.x)):
			animated_head.play("look_down")
			animated_body.play("look_down")
		else:
			if player_direction.x >= 0:
				if player_direction.y >= 0:
					animated_head.play("look_right_bottom")
					animated_body.play("look_right_bottom")
				else:
					animated_head.play("look_right")
					animated_body.play("look_right")
			else:
				if player_direction.y >= 0:
					animated_head.play("look_left_bottom")
					animated_body.play("look_left_bottom")
				else:
					animated_head.play("look_left")
					animated_body.play("look_left")
