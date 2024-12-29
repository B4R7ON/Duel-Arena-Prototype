extends Node

var hud

var player_max_lives : float
var player_lives : float

var rival_max_lives : float
var rival_lives : float


func lose_life(damage : float, body : CharacterBody2D):
	if body.name == "Player":
		player_lives -= damage
		if player_lives <= 0:
			RoundsManager.round_won("Rival")
			body.get_node("DeathScreamSFX").play()
		else:
			body.get_node("LoseLifeScreamSFX").play()
	
	if body.name == "Rival":
		rival_lives -= damage
		if rival_lives <= 0:
			RoundsManager.round_won("Player")
			body.get_node("DeathScreamSFX").play()
		else:
			body.get_node("LoseLifeScreamSFX").play()
	
	hud.load_hearts()
