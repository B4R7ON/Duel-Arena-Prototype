extends Area2D

signal pick

@export var this_hand : String
@export var rival : CharacterBody2D

var weapon = null
var weight = 0
var can_attack = true


func reset():
	weapon = null
	weight = 0


func holding(equipped_weapon):
	if equipped_weapon != null:
		equipped_weapon.position = to_global(self.get_node("Offset").position)
		equipped_weapon.rotation_degrees = $Offset.global_rotation_degrees + 90
		if can_attack:
			equipped_weapon.get_node("Weapon/Sprite2D").self_modulate = Color.WHITE
		else:
			equipped_weapon.get_node("Weapon/Sprite2D").self_modulate = Color.RED


func pick_weapon(hand : String):
	if hand == this_hand:
		if weapon == null:
			if get_overlapping_areas().size() > 0:
				var new_weapon = get_overlapping_areas()[0].get_node("..")
				if new_weapon.equipped == false:
					weapon = new_weapon
					weapon.get_node("AnimationPlayer").play("pick")
					weapon.get_node("Weapon").position = Vector2.ZERO # Para eliminar el desfase de spawn
					weapon.get_node("Weapon").rotation = 0 # Para eliminar el desfase de spawn
					weapon.get_node("Weapon/PickUpHitBox").set_deferred("disabled", true)
					weapon.equipped = true
					weapon.user = rival
					weapon.hand = self
					weapon.get_node("PickUpNoiseSFX").play()
					weight += weapon.weight
					
					can_attack = false
					$WeaponCooldown.set_wait_time(weapon.cooldown/2)
					$WeaponCooldown.start()
					$WeaponCooldown.set_wait_time(weapon.cooldown)
					
					pick.emit()
					
		if hand == "left_hand":
			rival.left_weapon = weapon
		if hand == "right_hand":
			rival.right_weapon = weapon


func weapon_attack(weapon : Node2D, animation : String):
	if RoundsManager.the_game_is_over == false:
		if can_attack and weapon.durability > 0:
			weapon.get_node("AnimationPlayer").play(animation)
			weapon.get_node("AnimationPlayer").speed_scale = weapon.speed
			can_attack = false
			
			$WeaponCooldown.start()


func _on_weapon_cooldown_timeout():
	can_attack = true
	#print(str(self.name) +  " Timer: " + str($WeaponCooldown.get_wait_time()))
