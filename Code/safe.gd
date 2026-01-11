extends Interactable_object
class_name Safe_interact

@onready var ui: ui_new_handler

@export var closed_sprite: Texture2D
@export var opened_sprite: Texture2D

@export var items_inside: Array[Interactable_object]

@onready var spot_1: Node2D = $Spot1
@onready var spot_2: Node2D = $Spot2


func _ready() -> void:
	super._ready()
	for item in get_children().filter(is_interactable):
		items_inside.append(item)

func is_interactable(element: Node) -> bool:
	if element is Interactable_object:
		return true
	return false

func Interact():
	if super.Interact():
		return
	if ui == null:
		ui = get_tree().get_first_node_in_group("UI")
	ui.open_input(self)
	
func _on_body_entered(body: Node2D):
	if body.is_in_group("player") and not disabled:
		body.set_new_closest(self)
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not disabled:
		body.remove_this_closest(self)

func verify_code(code: String) -> bool:
	var itemID = code.to_int()
	match itemID:
		7359:
			items_inside[0].visible = true
			items_inside[0].global_position = spot_1.global_position
			return true
		5364:
			print_debug("1")
			return true
		
	return false
	
	
func open_door():
	active_sprite.texture = opened_sprite
	off_highlight()
	disabled = true
