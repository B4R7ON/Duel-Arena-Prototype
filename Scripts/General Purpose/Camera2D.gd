extends Camera2D

var rng = RandomNumberGenerator.new()
var shake : float


func _process(delta):
	fade_shake(delta)
	offset = Vector2(rng.randf_range(shake, -shake), rng.randf_range(shake, -shake))


func apply_shake(strength):
	shake = strength


func fade_shake(delta):
	if shake > 0:
		shake = lerp(shake, 0.0, 30 * delta)
