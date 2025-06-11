extends Interactable_object
class_name Dialoguer

const Balloon = preload("res://Scenes/balloon.tscn")

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"

var balloon : Node

func Interact():
	if not balloon:
		balloon = Balloon.instantiate()
	#get_tree().current_scene.add_child(balloon)
	#balloon.start(dialogue_resource, dialogue_start)
	DialogueManager._start_balloon(balloon, dialogue_resource, dialogue_start, [])

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)

func _on_body_exited(body: Node2D) -> void:
	super._on_body_exited(body)

func end_dialogue(DR: DialogueResource):
	Game_Manager.player_char.stateMachine.on_child_transition("Dialogue", "Default")
