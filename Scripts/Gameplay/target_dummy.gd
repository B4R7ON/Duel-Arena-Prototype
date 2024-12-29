extends Area2D

@export var maxHP = 1
@export var HP = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if HP < 1:
		HP = maxHP
		print("FULL HP BABY")


func receibeDamage(damage):
	HP -= damage


func _on_area_entered(area):
	receibeDamage(area.get_node("..").damage)
	print("OUCH!!")
	

