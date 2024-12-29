extends Node

@export var initial_state : State
var current_state : State
var states : Dictionary = {}


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
	print("Current State: ", current_state.name.to_upper())


func _process(delta):
	if current_state:
		current_state.Update(delta)
		#print(current_state)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)


func on_child_transition(calling_state, new_state_name):
	if calling_state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	
	if new_state == null:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	
	#print("Estado anterior: " + calling_state.name.to_upper())
	#print("Estado actual: " + current_state.name.to_upper())
