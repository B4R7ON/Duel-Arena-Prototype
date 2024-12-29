extends Node2D

@export var weapons : Node
@export var start_spawn_left : Marker2D
@export var start_spawn_right : Marker2D

var can_fight = false

var player_speed
var player_attacking_speed

var rival_speed
var rival_attacking_speed

func _ready():
	RoundsManager.main = self
	HitStopManager.main = self
	
	player_speed = $Player.speed
	player_attacking_speed = $Player.attacking_speed
	
	rival_speed = $Rival.speed
	rival_attacking_speed = $Rival.attacking_speed
	
	$Player.speed = 0
	$Player.attacking_speed = 0
	
	$Rival.speed = 0
	$Rival.attacking_speed = 0
	
	spawn_start_weapons()


func _process(delta):
	if can_fight:
		$Player.speed = player_speed
		$Player.attacking_speed = player_attacking_speed
		
		$Rival.speed = rival_speed
		$Rival.attacking_speed = rival_attacking_speed
		
		$MusicSFX.play_background_music()
	else:
		$Player.attacking_speed = 0
		$Player.speed = 0
		
		$Rival.attacking_speed = 0
		$Rival.speed = 0
	
	if $Player.velocity != Vector2.ZERO or $Rival.velocity != Vector2.ZERO:
		if Engine.time_scale == 1:
			$MusicSFX.play_foot_steps_SFX()
	
	if Input.is_action_just_pressed("pause") and not RoundsManager.the_game_is_over:
		PauseManager.pause()
	
	$NoPauseMessage.position = get_global_mouse_position() - $NoPauseMessage.pivot_offset
	$NoPauseMessage.modulate.a = clamp($NoPauseMessage.modulate.a, 0, 1)
	
	if $NoPauseMessage.modulate.a > 0:
		$NoPauseMessage.modulate.a -= delta
	

func _on_start_timer_timeout():
	can_fight = true


func spawn_start_weapons():
	var rand_start_weapon = weapons.pick_weapon()
	
	weapons.spawn_weapon(rand_start_weapon, start_spawn_left.position)
	start_spawn_left.get_parent().shadow_animation(start_spawn_left.position)
	
	weapons.spawn_weapon(rand_start_weapon, start_spawn_right.position)
	start_spawn_right.get_parent().shadow_animation(start_spawn_right.position)
	
	$StartTimer.start()
	
	await get_tree().create_timer(2).timeout
	
	var center_weapon = weapons.pick_weapon()
	weapons.spawn_weapon(center_weapon, $MainCenter/Marker2D.position)
	$MainCenter/Marker2D.get_parent().shadow_animation($MainCenter/Marker2D.position)
