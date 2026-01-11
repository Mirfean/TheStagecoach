extends State
class_name PlayerDialogue

@export var my_player : player
	
	
func Enter():
	my_player.speed = 0
	if not DialogueManager.dialogue_ended.is_connected(end_dialogue):
		DialogueManager.dialogue_ended.connect(end_dialogue)
	print("Dialogue")
	my_player.EndLoopTimer.paused = true
#func Exit():
	#DialogueManager.dialogue_ended.disconnect(end_dialogue)
	
func end_dialogue(DR: DialogueResource):
	print("Dialogue end")
	my_player.EndLoopTimer.paused = false
	Transitioned.emit(self, "Default")

#func _exit_tree() -> void:
#	DialogueManager.dialogue_ended.disconnect(end_dialogue)
