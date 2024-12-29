extends Node
var game_paused : bool


func _ready():
	#print(get_node("/root").get_children())
	
	game_paused = true
	Engine.time_scale = 0


func pause():
	if RoundsManager.moving_to_next_round: # El juego esta pasando a la siguiente ronda
		get_node("/root/Main/NoPauseMessage").modulate.a = 1
	else:
		if Engine.time_scale > 0: # El juego esta corriendo
			Engine.time_scale = 0 # Pausa el juego
			game_paused = true
		elif not HitStopManager.hit_stop_on: # No hay ningun HitStop activo. El juego esta pausado
			Engine.time_scale = 1 # Reanuda el juego
			game_paused = false
