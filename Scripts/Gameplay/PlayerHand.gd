extends Area2D

@export var input : String
var player
var weapon = null
var weight = 0
var can_attack = true


func _ready():
	player = get_node("../..")


func reset():
	weapon = null
	weight = 0


func _process(delta):
	if weapon:
		weapon.position = to_global(self.get_node("Offset").position)
		weapon.rotation_degrees = self.get_node("..").rotation_degrees + 90
		if can_attack:
			weapon.get_node("Weapon/Sprite2D").self_modulate = Color.WHITE
		else:
			weapon.get_node("Weapon/Sprite2D").self_modulate = Color.RED


func _input(event):
	if weapon:
		if RoundsManager.the_game_is_over == false:
			if can_attack and weapon.durability > 0:
				accion()
	
	equipar()
	soltar()


func equipar():
	if Input.is_action_just_pressed(input):
		if get_overlapping_areas().size() > 0:
			var new_weapon = get_overlapping_areas()[0].get_node("..")
			if new_weapon.equipped == false:
				if weapon == null: # Equipa un weapon del suelo
					weapon = new_weapon
					weapon.get_node("AnimationPlayer").play("pick")
					weapon.get_node("Weapon").position = Vector2.ZERO # Para eliminar el desfase de spawn
					weapon.get_node("Weapon").rotation = 0 # Para eliminar el desfase de spawn
					weapon.get_node("Weapon/PickUpHitBox").set_deferred("disabled", true)
					weapon.equipped = true
					weapon.user = player
					weapon.hand = self
					weapon.get_node("AttackRange/Range").set_deferred("disabled", true)
					weapon.get_node("PickUpNoiseSFX").play()
					weight += weapon.weight
					
					can_attack = false
					$WeaponCooldown.set_wait_time(weapon.cooldown/2)
					$WeaponCooldown.start()
					$WeaponCooldown.set_wait_time(weapon.cooldown)
					
					
				#else: # Intercambia weapon actual por weapon del suelo
					#weapon.equipped = false # Suelta weapon actual
					#weapon.user = null
					#weapon.get_node("AnimationPlayer").stop()
					#weapon.get_node("AttackRange/Range").set_deferred("disabled", false)
					#weight -= weapon.weight
					#
					#weapon = new_weapon # Obtiene nueva weapon del suelo
					#weapon.equipped = true
					#weapon.user = player
					#weapon.get_node("AttackRange/Range").set_deferred("disabled", true)
					#$WeaponCooldown.set_wait_time(weapon.cooldown)
					
				#weight += weapon.weight


func soltar():
	if Input.is_action_just_pressed("drop_item"):
		if weapon:
			weapon.get_node("AnimationPlayer").stop()
			weapon.get_node("Weapon/Sprite2D").self_modulate = Color.WHITE
			weapon.get_node("Weapon/PickUpHitBox").set_deferred("disabled", false)
			weapon.equipped = false
			weapon.user = null
			weapon.hand = null
			weapon.get_node("AttackRange/Range").set_deferred("disabled", false)
			weapon.get_node("DropNoiseSFX").play()
			weight -= weapon.weight
			weapon = null


func accion():
	if Input.is_action_just_pressed(input):
		weapon.get_node("AnimationPlayer").speed_scale = weapon.speed
		can_attack = false
		
		$WeaponCooldown.start()
		
		if input == "left_hand":
			weapon.get_node("AnimationPlayer").play("action_animation_left")
		else:
			weapon.get_node("AnimationPlayer").play("action_animation_right")


func _on_weapon_cooldown_timeout():
	can_attack = true
