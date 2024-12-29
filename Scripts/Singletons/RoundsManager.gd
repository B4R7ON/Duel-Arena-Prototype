extends Node

var main
var hud
var player : CharacterBody2D
var rival : CharacterBody2D
var weapons_array : Array

var player_rounds_won = 0
var rival_rounds_won = 0

var rounds_to_win : int

var moving_to_next_round = false
var the_game_is_over = false


func _process(delta):
	print(weapons_array)


func round_won(winner : String):
	moving_to_next_round = true
	if winner == "Player":
		player_rounds_won += 1
		hud.get_node("StartCountdown").text = "Player Won"
		hud.get_node("StartCountdown").modulate.a = 1
	elif winner == "Rival":
		rival_rounds_won += 1
		hud.get_node("StartCountdown").text = "Rival Won"
		hud.get_node("StartCountdown").modulate.a = 1
	
	Engine.time_scale = 0.1
	await get_tree().create_timer(2, true, false, true).timeout # Slow Motion de victoria
	Engine.time_scale = 1
	
	if player_rounds_won == rounds_to_win or rival_rounds_won == rounds_to_win:
		hud.load_rounds()
		moving_to_next_round = false
		if winner == "Player":
			hud.get_node("StartCountdown").text = "Congratulations! YOU WIN"
			stop_movement()
			
			await get_tree().create_timer(3).timeout
			
			hud.get_node("PlayerHearts").modulate.a = 0
			hud.get_node("PlayerRounds").modulate.a = 0
			hud.get_node("RivalHearts").modulate.a = 0
			hud.get_node("RivalRounds").modulate.a = 0
			hud.get_node("StartCountdown").modulate.a = 0
			
			game_over()
		elif winner == "Rival":
			hud.get_node("StartCountdown").text = "You Lost"
			stop_movement()
			
			await get_tree().create_timer(3).timeout
			
			hud.get_node("PlayerHearts").modulate.a = 0
			hud.get_node("PlayerRounds").modulate.a = 0
			hud.get_node("RivalHearts").modulate.a = 0
			hud.get_node("RivalRounds").modulate.a = 0
			hud.get_node("StartCountdown").modulate.a = 0
			
			game_over()
	else:
		hud.load_rounds()
		reset()


func game_over():
	hud.get_node("GameOverMenu").activate()


func stop_movement():
	the_game_is_over = true
	
	player.get_node("Pivot/LeftHand").weight = 0
	player.get_node("Pivot/RightHand").weight = 0
	
	rival.get_node("Pivot/LeftHand").weight = 0
	rival.get_node("Pivot/RightHand").weight = 0
	
	player.weight_change()
	rival.weight_change()
	
	main.can_fight = false


func restart():
	hud.get_node("PlayerHearts").modulate.a = 1
	hud.get_node("PlayerRounds").modulate.a = 1
	hud.get_node("RivalHearts").modulate.a = 1
	hud.get_node("RivalRounds").modulate.a = 1
	hud.get_node("StartCountdown").modulate.a = 1
	
	player_rounds_won = 0
	rival_rounds_won = 0
	hud.load_rounds()
	reset()


func reset():
	main.can_fight = false
	main.get_node("StartTimer").start()
	weapons_array = main.get_node("Weapons").get_children()
	
	player.reset()
	player.get_node("Pivot/LeftHand").reset()
	player.get_node("Pivot/RightHand").reset()
	
	rival.reset()
	rival.get_node("Pivot/LeftHand").reset()
	rival.get_node("Pivot/RightHand").reset()
	
	await get_tree().create_timer(0.1).timeout
	
	rival.get_node("StateMachine/Disarmed").weapons_dictionary.clear()
	rival.get_node("StateMachine/Disarmed").closest_weapon = null
	
	for weapon in weapons_array:
		if is_instance_valid(weapon):
			weapon.queue_free()
	
	LivesSystem.player_lives = LivesSystem.player_max_lives
	LivesSystem.rival_lives = LivesSystem.rival_max_lives
	hud.load_hearts()
	
	moving_to_next_round = false
	the_game_is_over = false
	
	main.spawn_start_weapons()
