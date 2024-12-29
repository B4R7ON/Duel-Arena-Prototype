extends Node

@export var player : CharacterBody2D
@export var rival : CharacterBody2D

@export var scenes_array : Array[PackedScene]

@export var left_spawn_center : Marker2D
@export var right_spawn_center : Marker2D

@export var spawn_offset : Vector2
@export var cooldown : Timer


func spawn_weapon(scene : PackedScene, spawn_position : Vector2):
	var weapon = scene.instantiate()
	weapon.position = spawn_position + spawn_offset
	
	add_child(weapon)
	weapon.get_node("AnimationPlayer").play("spawn_animation")
	
	#get_tree().current_scene.call_deferred("add_child", weapon)
	#set_deferred("add_child", weapon)


func pick_weapon():
	var rand_weapon = scenes_array.pick_random()
	
	return rand_weapon


func spawn_new_weapon(user : CharacterBody2D):
	var rand_weapon = pick_weapon()
	var spawn_area
	
	if user == player:
		spawn_area = pick_best_area_for_user(user.position, rival.position)
	else:
		spawn_area = pick_best_area_for_user(user.position, player.position)
	
	var rand_point = spawn_area.random_point()
	
	spawn_weapon(rand_weapon, rand_point)
	spawn_area.shadow_animation(rand_point)
	
	cooldown.start()


func pick_best_area_for_user(user_position : Vector2, enemy_position : Vector2):
	if abs(left_spawn_center.position - user_position) <= abs(left_spawn_center.position - enemy_position):
		return right_spawn_center.get_parent()
	else:
		return left_spawn_center.get_parent()
