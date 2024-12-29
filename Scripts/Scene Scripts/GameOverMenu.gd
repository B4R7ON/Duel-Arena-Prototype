extends Control

@export var music : AudioStreamPlayer
var on_credits = false

func _ready():
	hide()
	for button in $VBoxContainer.get_children():
		button.set_deferred("disabled", true)


func _input(event):
	if Input.is_action_just_pressed("pause") and RoundsManager.the_game_is_over:
		if on_credits:
			_on_back_pressed()


func _on_play_again_pressed():
	RoundsManager.restart()
	deactivate()
	RoundsManager.the_game_is_over = false


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
	RoundsManager.the_game_is_over = false


func _on_quit_pressed():
	get_tree().quit()


func activate():
	show()
	for button in $VBoxContainer.get_children():
		button.set_deferred("disabled", false)


func deactivate():
	hide()
	for button in $VBoxContainer.get_children():
		button.set_deferred("disabled", true)


func _on_credits_pressed():
	on_credits = true
	for button in $VBoxContainer.get_children():
		button.hide()
		button.set_deferred("disabled", true)
	
	music.volume_db = -20
	$ThanksForPlayingLabel.hide()
	$Credits.show()
	$BackButton.show()


func _on_back_pressed():
	on_credits = false
	for button in $VBoxContainer.get_children():
		button.show()
		button.set_deferred("disabled", false)
	
	music.volume_db = -10
	$ThanksForPlayingLabel.show()
	$Credits.hide()
	$BackButton.hide()
