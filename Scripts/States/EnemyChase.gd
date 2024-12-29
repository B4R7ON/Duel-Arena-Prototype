extends State
class_name RivalChase

@export var rival : CharacterBody2D
@export var pivot : Node2D
@export var animated_head : AnimatedSprite2D
@export var animated_body : AnimatedSprite2D

var player : CharacterBody2D
var smooth_player_position : Vector2
var player_direction : Vector2

var left_weapon
var right_weapon


func Enter():
	player = rival.player
	
	#left_weapon = rival.left_weapon
	#right_weapon = rival.right_weapon


func Exit():
	play_animations("idle")


func Update(delta: float):
	play_animations("walk")
	
	left_weapon = rival.left_weapon
	right_weapon = rival.right_weapon
	
	if left_weapon != null:
		if left_weapon.player_in_range:
			Transitioned.emit(self, "Attack")
	if right_weapon != null:
		if right_weapon.player_in_range:
			Transitioned.emit(self, "Attack")
	
	if not left_weapon and not right_weapon:
		Transitioned.emit(self, "Disarmed")


func Physics_Update(delta: float):
	if Engine.time_scale > 0:
		look_at_player()
	rival.move()


func look_at_player():
	smooth_player_position = lerp(smooth_player_position, player.position, 0.05)
	pivot.look_at(smooth_player_position)
	
	player_direction = smooth_player_position - rival.position


func play_animations(name : String):
	if name == "idle":
		if player_direction.y > 0 and (abs(player_direction.y) > abs(player_direction.x)):
			animated_head.play("look_down")
		else:
			if player_direction.x >= 0:
				if player_direction.y >= 0:
					animated_head.play("look_right_bottom")
				else:
					animated_head.play("look_right")
			else:
				if player_direction.y >= 0:
					animated_head.play("look_left_bottom")
				else:
					animated_head.play("look_left")
	
	elif name == "walk":
		if player_direction.y > 0 and (abs(player_direction.y) > abs(player_direction.x)):
			animated_head.play("look_down")
			animated_body.play("walk_down")
		else:
			if player_direction.x >= 0:
				if player_direction.y >= 0:
					animated_head.play("look_right_bottom")
					animated_body.play("walk_right_bottom")
				else:
					animated_head.play("look_right")
					animated_body.play("walk_right")
			else:
				if player_direction.y >= 0:
					animated_head.play("look_left_bottom")
					animated_body.play("walk_left_bottom")
				else:
					animated_head.play("look_left")
					animated_body.play("walk_left")
		
