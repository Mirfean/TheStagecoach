extends Interactable_object
class_name Dialoguer

const Balloon = preload("res://Scenes/balloon.tscn")

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"
@export var actor : Texture2D
@export var actor_size: Vector2 = Vector2.ONE
@export var no_collider: bool 

var balloon : Node

func _ready() -> void:
	if active_sprite:
		active_sprite.texture = actor
		active_sprite.scale = actor_size
	if not no_collider:
		collider = find_children("*", "CollisionShape2D", false).front()
	super._ready()
	
func Interact():
	if not balloon:
		balloon = Balloon.instantiate()
	Game_Manager.start_dialogue()
	DialogueManager._start_balloon(balloon, dialogue_resource, dialogue_start, [])

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)

func _on_body_exited(body: Node2D) -> void:
	super._on_body_exited(body)

func end_dialogue(DR: DialogueResource):
	Game_Manager.player_char.stateMachine.on_child_transition("Dialogue", "Default")
