extends Node2D

@export var pick_weapon_text : String
@export var attack_text : String

var left_hand
var right_hand

func _ready():
	left_hand = get_node("../Pivot/LeftHand")
	right_hand = get_node("../Pivot/RightHand")
	
	$LeftClick.play("default")
	$RightClick.play("default")
	$SpaceBar.play("default")
	
	$LeftClick.modulate.a = 0
	$RightClick.modulate.a = 0
	$SpaceBar.modulate.a = 0
	$ClickLabel.modulate.a = 0
	$SpaceLabel.modulate.a = 0


func _process(delta):
	modulate.a = clamp(modulate.a, 0, 1)
	$LeftClick.modulate.a = clamp($LeftClick.modulate.a, 0, 1)
	$RightClick.modulate.a = clamp($RightClick.modulate.a, 0, 1)
	$SpaceBar.modulate.a = clamp($SpaceBar.modulate.a, 0, 1)
	$ClickLabel.modulate.a = clamp($ClickLabel.modulate.a, 0, 1)
	$SpaceLabel.modulate.a = clamp($SpaceLabel.modulate.a, 0, 1)
	
	if $Area2D.get_overlapping_areas() or (left_hand.weapon or right_hand.weapon):
		modulate.a += delta * 10
		$ClickLabel.modulate.a += delta * 10
		if left_hand.weapon and right_hand.weapon:
			$ClickLabel.text = attack_text
			$LeftClick.modulate.a += delta * 10
			$RightClick.modulate.a += delta * 10
			
			$SpaceLabel.text = "DROP WEAPONS"
			$SpaceLabel.modulate.a += delta * 10
			$SpaceBar.modulate.a += delta * 10
		elif left_hand.weapon:
			$ClickLabel.text = attack_text
			$LeftClick.modulate.a += delta * 10
			$RightClick.modulate.a -= delta * 10
			
			$SpaceLabel.text = "DROP WEAPONS"
			$SpaceLabel.modulate.a += delta * 10
			$SpaceBar.modulate.a += delta * 10
		elif right_hand.weapon:
			$ClickLabel.text = attack_text
			$LeftClick.modulate.a -= delta * 10
			$RightClick.modulate.a += delta * 10
			
			$SpaceLabel.text = "DROP WEAPONS"
			$SpaceLabel.modulate.a += delta * 10
			$SpaceBar.modulate.a += delta * 10
		else:
			$ClickLabel.text = pick_weapon_text
			$LeftClick.modulate.a += delta * 10
			$RightClick.modulate.a += delta * 10
			
			$SpaceLabel.modulate.a -= delta * 10
			$SpaceBar.modulate.a -= delta * 10
	else:
		modulate.a -= delta * 10
		$ClickLabel.modulate.a -= delta * 10
	
	#print(visible)
