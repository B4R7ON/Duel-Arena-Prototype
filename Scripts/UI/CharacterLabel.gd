extends Label

var main

func _ready():
	main = get_node("../..")


func _process(delta):
	modulate.a = clamp(modulate.a, 0, 1)
	
	if main.can_fight:
		modulate.a -= delta * 0.5
