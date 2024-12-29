extends Node

@export var start_timer : Timer
@export var rounds_to_win : int
@export var fight_text : String

func _ready():
	LivesSystem.hud = self
	RoundsManager.hud = self
	RoundsManager.rounds_to_win = self.rounds_to_win
	load_hearts()
	load_rounds()


func _process(delta):
	$StartCountdown.modulate.a = clamp($StartCountdown.modulate.a, 0, 1)
	$HPLabel.modulate.a = clamp($HPLabel.modulate.a, 0, 1)
	$RoundsLabel.modulate.a = clamp($RoundsLabel.modulate.a, 0, 1)
	
	if start_timer.time_left > 0:
		$StartCountdown.text = str(ceil(start_timer.time_left))
	else:
		if not RoundsManager.moving_to_next_round and not RoundsManager.the_game_is_over:
			$StartCountdown.text = fight_text
			$StartCountdown.modulate.a -= delta * 0.75
			$HPLabel.modulate.a -= delta * 0.5
			$RoundsLabel.modulate.a -= delta * 0.5
	
	if PauseManager.game_paused:
		$StartCountdown.hide()
	else:
		$StartCountdown.show()


func load_hearts():
	$PlayerHearts/FullHearts.size.x = LivesSystem.player_lives * 20
	$PlayerHearts/EmptyHearts.size.x = LivesSystem.player_max_lives * 20
	
	$RivalHearts/FullHearts.size.x = LivesSystem.rival_lives * 20
	$RivalHearts/EmptyHearts.size.x = LivesSystem.rival_max_lives * 20


func load_rounds():
	$PlayerRounds/RoundWon.size.x = RoundsManager.player_rounds_won * 19
	$PlayerRounds/RoundToWin.size.x  = rounds_to_win * 19
	
	$PlayerRounds/RoundWon.size.x = clamp($PlayerRounds/RoundWon.size.x, $PlayerRounds/RoundWon.size.x, rounds_to_win * 19)
	
	$RivalRounds/RoundWon.size.x = RoundsManager.rival_rounds_won * 19
	$RivalRounds/RoundToWin.size.x  = rounds_to_win * 19
	
	$RivalRounds/RoundWon.size.x = clamp($RivalRounds/RoundWon.size.x, $RivalRounds/RoundWon.size.x, rounds_to_win * 19)
