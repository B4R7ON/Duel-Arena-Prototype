extends Node2D


func _process(delta):
	if $Player/MouseControls.modulate.a > 0:
		$Player/MovementControls.hide()
		$Player/MovementControls.modulate.a = 0
	else:
		$Player/MovementControls.show()
	
	if $Player.velocity != Vector2.ZERO:
		if Engine.time_scale == 1:
			$MusicSFX.play_foot_steps_SFX()
	
	if Input.is_action_just_pressed("pause"):
		PauseManager.pause()
