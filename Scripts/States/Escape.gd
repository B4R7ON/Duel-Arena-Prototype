extends State
class_name Escape

@export var rival : CharacterBody2D
@export var pivot : Node2D

var player : CharacterBody2D
var smooth_player_position : Vector2
var player_direction : Vector2

var left_weapon
var right_weapon


func Enter():
	player = rival.player
	
	left_weapon = rival.left_weapon
	right_weapon = rival.right_weapon


func Exit():
	play_animations("idle")


func Update(delta: float):
	play_animations("walk")


func Physics_Update(delta: float):
	look_at_player()
	rival.move(-delta)


func look_at_player():
	smooth_player_position = lerp(smooth_player_position, player.position, 0.05)
	pivot.look_at(smooth_player_position)
	
	player_direction = smooth_player_position - rival.position


func play_animations(name : String):
	if name == "idle":
		if abs(player_direction.x) >= abs(player_direction.y):
			if player_direction.x >= 0:
				get_node("../../AnimatedSprite2D").play("idle_right")
			else:
				get_node("../../AnimatedSprite2D").play("idle_left")
		else:
			if player_direction.y >= 0:
				get_node("../../AnimatedSprite2D").play("idle_bottom")
			else:
				get_node("../../AnimatedSprite2D").play("idle_up")
	
	elif name == "walk":
		if abs(player_direction.x) >= abs(player_direction.y):
			if player_direction.x >= 0:
				get_node("../../AnimatedSprite2D").play("walk_right")
			else:
				get_node("../../AnimatedSprite2D").play("walk_left")
		else:
			if player_direction.y >= 0:
				get_node("../../AnimatedSprite2D").play("walk_bottom")
			else:
				get_node("../../AnimatedSprite2D").play("walk_up")

