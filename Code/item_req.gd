extends Node2D
class_name item_req

# Value : type
@export var requirements: Dictionary
@export var item: Interactable_object
@export var remove_if_req_not: bool = false

func _ready() -> void:
	var can_spawn = true
	for req in requirements:
		if Game_Manager.read_save_data(requirements[req]):
			print_debug("Found in save")
		else:
			if DMM.getValue(req):
				print_debug("SIEMA")
			else:
				print_debug("Also not found in dialogues data")
				can_spawn = false
				break
		if not can_spawn:
			if remove_if_req_not:
				queue_free()
			else:
				hide_item()

func show_item():
	item.visible = true
	item.disabled = false
	
func hide_item():
	item.visible = false
	item.disabled = true
