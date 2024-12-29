extends Node2D
class_name Weapon

signal broke

@export var damage : float
@export var speed = 1.0
@export var cooldown = 0.0
@export var weight = 0
@export var durability = 5

var knockback = Vector2.ZERO
var knockback_direction : Vector2
@export var knockback_strength : float

var user : CharacterBody2D
var equipped = false
var hand : Area2D
var player_in_range = null

#RESET VARIABLES
var reset_position : Vector2
var reset_rotation : float

func _ready():
	$Weapon/BladeHitBox.set_deferred("disabled", true) # NO HABILITADO
	reset_position = position
	reset_rotation = rotation


func lose_durability(amount):
	durability -= amount
	
	if durability <= 0:
		await get_tree().create_timer(0.001).timeout
		# ^Este timer da tiempo a RoundsManager para evitar llamar dos veces a spawn_new_weapon()
		if not RoundsManager.moving_to_next_round:
			get_node("..").spawn_new_weapon(user)
		$Weapon/Sprite2D.hide()
		$BrokenParticles.emitting = true
		hand.weight -= weight
		user.weight_change()
		hand.weapon = null
		
		await get_tree().create_timer($BrokenParticles.lifetime).timeout
		
		queue_free()


func deal_damage(body : CharacterBody2D):
	body.hp -= damage
	LivesSystem.lose_life(damage, body)
	
	clamp(damage, 0.5, 2.0)
	
	damage = damage/2
	if damage < 1.0:
		damage = 0.5


func apply_knockback(body : CharacterBody2D, strength):
	knockback_direction.x = body.position.x - user.position.x
	knockback_direction.y = body.position.y - user.position.y
	
	body.knock_velocity = knockback_direction * strength


func _on_weapon_body_entered(body): # Arma golpea al jugador/rival
	var explosive_particles = body.get_node("ExplosiveParticles")
	var death_particles = body.get_node("DeathParticles")
	
	if equipped and $Weapon/PickUpHitBox.disabled and body != user:
		deal_damage(body)
		
		if body.hp > 0:
			apply_knockback(body, knockback_strength)
			body.hit_flash()
			explosive_particles.color = Color.WHITE
			explosive_particles.direction = -knockback_direction
		else:
			apply_knockback(body, knockback_strength * 6)
			explosive_particles.color = Color.RED
			explosive_particles.direction = knockback_direction
		
		explosive_particles.emitting = true
		get_node("../../Camera2D").apply_shake(40)
		$Weapon/BladeHitBox.set_deferred("disabled", true)
		
		lose_durability(1.0)


func _on_weapon_area_entered(area): # Arma golpea a otra arma
	var weapon = area.get_node("..")
	if equipped:
		if area.name == "Weapon" and weapon.equipped and weapon.user != self.user:
			$SwingNoiseSFX.stop()
			HitStopManager.hit_stop(0.25, $SwingNoiseSFX)
			await get_tree().create_timer(0.05).timeout
			
			apply_knockback(weapon.user, knockback_strength/1.5)
			$Weapon/BladeHitBox.set_deferred("disabled", true)
			
			lose_durability(2.0)


func _on_attack_range_body_entered(body): # Solo para RIVAL
	if body.name == "Player":
		player_in_range = body
func _on_attack_range_body_exited(body): # Solo para RIVAL
	if body.name == "Player":
		player_in_range = null
