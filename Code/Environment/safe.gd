extends Interactable_object
class_name Safe_interact

@onready var ui: ui_new_handler

@export var closed_sprite: Texture2D
@export var opened_sprite: Texture2D

@export var items_inside: Dictionary[int, Interactable_object]

@onready var spot_1: Node2D = $Spot1
@onready var spot_2: Node2D = $Spot2

func _ready() -> void:
	super._ready()

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
	if items_inside.has(code.to_int()):
		var item = items_inside[code.to_int()]
		setup_item(item)
		return true
	else:
		return false
	
func setup_item(item: Interactable_object):
	item.global_position = spot_2.global_position
	item.visible = true

func open_door():
	active_sprite.texture = opened_sprite
	off_highlight()
	disabled = true
