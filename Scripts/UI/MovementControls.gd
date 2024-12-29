extends Node2D

var w_has_been_pressed = true
var a_has_been_pressed = true
var d_has_been_pressed = true
var s_has_been_pressed = true


func _ready():
	modulate.a = 0


func _process(delta):
	$W.play("default")
	$A.play("default")
	$D.play("default")
	$S.play("default")
	
	if Input.is_action_pressed("move_up"):
		$W.play("pressed")
		w_has_been_pressed = true
	if Input.is_action_pressed("move_left"):
		$A.play("pressed")
		a_has_been_pressed = true
	if Input.is_action_pressed("move_right"):
		$D.play("pressed")
		d_has_been_pressed = true
	if Input.is_action_pressed("move_down"):
		$S.play("pressed")
		s_has_been_pressed = true
	
	modulate.a = clamp(modulate.a, 0, 1)
	
	if w_has_been_pressed and a_has_been_pressed and d_has_been_pressed and s_has_been_pressed:
		modulate.a -= delta * 0.75
	if !w_has_been_pressed and !a_has_been_pressed and !d_has_been_pressed and !s_has_been_pressed:
		modulate.a += delta * 10
	
	if get_node("..").velocity == Vector2.ZERO:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		$Timer.stop()

func _on_timer_timeout():
	print("SIGNAL")
	w_has_been_pressed = false
	a_has_been_pressed = false
	d_has_been_pressed = false
	s_has_been_pressed = false
