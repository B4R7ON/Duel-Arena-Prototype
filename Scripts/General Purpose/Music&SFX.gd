extends Node


func play_sword_impact_SFX():
	$SwordImpactSFX.play()


func play_foot_steps_SFX():
	if not $FootStepsSFX.playing:
		$FootStepsSFX.play()


func play_background_music():
	if not $BackgroundMusic.playing:
		$BackgroundMusic.play()


func _on_background_music_finished():
	$BackgroundMusic.play()
