extends Control


func _ready():
	#print(get_tree().current_scene)
	#print(PauseManager.game_paused)
	#print(Engine.time_scale)
	pass


func _process(delta):
	if PauseManager.game_paused:
		modulate.a = 1
		for button in $VBoxContainer.get_children():
			button.set_deferred("disabled", false)
	else:
		modulate.a = 0
		for button in $VBoxContainer.get_children():
			button.set_deferred("disabled", true)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	PauseManager.pause()
	
	RoundsManager.player_rounds_won = 0
	RoundsManager.rival_rounds_won = 0
	RoundsManager.the_game_is_over = false


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
	PauseManager.pause()
	RoundsManager.the_game_is_over = false


func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	PauseManager.pause()
