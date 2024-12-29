extends Node

var main : Node2D
var hit_stop_on = false

#func _ready():
	#main = get_node("/root/Main")
	##print(get_node("/root").get_children())


func hit_stop(time : float, swing : AudioStreamPlayer):
	Engine.time_scale = 0
	hit_stop_on = true
	swing.stop()
	main.get_node("MusicSFX").play_sword_impact_SFX()
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1
	hit_stop_on = false
