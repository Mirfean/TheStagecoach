extends Interactable_object
class_name interact_door

var door : Door

func _ready() -> void:
	if not door:
		door = get_parent()

func Interact():
	if door.opened:
		door.close_door()
	else:
		door.open_door()

func _on_body_entered(body: Node2D):
	super._on_body_entered(body)
	print("Siema drzwi")

func _on_body_exited(body: Node2D):
	super._on_body_exited(body)
