extends Node
class_name StateMachine

@export var initialState : State

var currentState : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initialState:
		print(get_parent().name, " going ", initialState)
		initialState.Enter()
		currentState = initialState
	else:
		print("There is no initial state, trying to go Idle ", get_parent().name)
		initialState = states.get("idle")
		if initialState:
			print("oof, saved ", get_parent().name)
			initialState.Enter()
			currentState = initialState
		else:
			print("Sorry, I failed you ", get_parent().name)
			
	
func _process(delta: float) -> void:
	if currentState:
		currentState.Update(delta)

func _input(event: InputEvent) -> void:
	if currentState:
		currentState.InputState(event)

func _physics_process(delta: float) -> void:
	if currentState:
		currentState.PhysicsUpdate(delta)

func on_child_transition(state, newStateName):
	#print("Trying change", currentState, " to ", states.get(newStateName.to_lower()), " for ", get_parent().name)
	
	if state != currentState:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.Exit()
	
	newState.Enter()
	#print("Changing ", currentState, " to ", newState, " for ", get_parent().name)
	currentState = newState
	
	
