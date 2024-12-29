extends Node2D

@export var shadow_offset : Vector2


func random_point():
	var x = randf_range($TopLeft.position.x, $BottomRight.position.x)
	var y = randf_range($TopLeft.position.y, $BottomRight.position.y)
	
	var point = Vector2(x, y)
	
	return point


func shadow_animation(point : Vector2):
	$RoundShadow.position = point + shadow_offset
	$RoundShadow/AnimationPlayer.play("shadow")
