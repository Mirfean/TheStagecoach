extends State
class_name PlayerDefault

@export var my_player : player

var speed := 80
var interact := true

func Enter():
	my_player.speed = speed
	my_player.can_interact = interact
	if not DialogueManager.dialogue_started.is_connected(start_dialogue):
		DialogueManager.dialogue_started.connect(start_dialogue)
	print_debug(DialogueManager.dialogue_started.get_connections())
	print("dialoz ", DialogueManager)

#func Exit():
	#DialogueManager.dialogue_started.disconnect(start_dialogue)

func InputState(event : InputEvent):
	if event.is_action_pressed("Aim"):
		Transitioned.emit(self, "Aim")
	
func start_dialogue(DR: DialogueResource):
	Transitioned.emit(self, "Dialogue")

#func _exit_tree() -> void:
#	DialogueManager.dialogue_started.disconnect(start_dialogue)
