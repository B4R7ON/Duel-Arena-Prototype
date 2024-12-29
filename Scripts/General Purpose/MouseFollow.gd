extends Marker2D

var smooth_mouse_position : Vector2


func _process(delta):
	smooth_mouse_position = lerp(smooth_mouse_position, get_global_mouse_position(), 0.75)
	position = smooth_mouse_position
