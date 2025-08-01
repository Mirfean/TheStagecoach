extends Node
class_name InventoryManager

@export var game_manager : GameManager
@export var dialogue_mm : Dialogue_MiddleMan

@export var user_inv : user_inventory
@export var chest_ui : chest_storage
@export var crafting_ui : crafting_menu
@export var player_char: player

var current_chest : chest
var pickable_item_prefab = load("res://Scenes/pickable_item.tscn")
var spawn_item_father : Node2D

signal Close_Chest
signal Craft_Items_Change

func _ready() -> void:
	self.add_to_group("InventoryManager")
	
func set_chest_ui(cs: chest_storage):
	chest_ui = cs
	chest_ui.chest_closing.connect(close_current_chest)
	chest_ui.disactivate()
	
func open_new_chest(new_chest : chest):
	if current_chest != null:
		return
	current_chest = new_chest
	chest_ui.activate()
	user_inv.activate()
	chest_ui.spawn_new_items(current_chest.Items, current_chest.first_time)
	
func close_current_chest():
	var new_items = chest_ui.inventory.serialize()
	for x in new_items:
		print(x)
	Close_Chest.emit()
	current_chest.update_chest(new_items)
	current_chest.first_time = false
	chest_ui.disactivate()
	user_inv.disactivate()
	current_chest = null

# ADDING ITEMS
####################################################################
func add_item_to_inventory(item_name : String, amount : int = 1):
	var new_item = user_inv.main_kieszen.create_item(item_name)
	if not new_item:
		return false	
	var stack_remaining = user_inv.spawn_new_item_inventory(new_item.get_proto_id(), amount)
	if stack_remaining > 0:
		spawn_item_on_ground(item_name, stack_remaining)
	return true
	
func add_item_from_ground(item : pickable_item) -> bool:
	return add_item_to_inventory(item.item_id_name, item.item_amount)
	
func add_InventoryItem_to_main(item : InventoryItem) -> bool:
	return add_item_to_inventory(item.get_proto_id(), item.get_stack_size())
####################################################################

func spawn_item_on_ground(item_name : String, amount : int) -> bool:
	print_debug("Put down ", item_name)
	var item_info = user_inv.main_kieszen.create_item(item_name)
	if item_info == null:
		return false
	if not spawn_item_father:
		spawn_item_father = get_tree().get_first_node_in_group("SpawnItemHolder")
	var new_item = pickable_item_prefab.instantiate()
	spawn_item_father.add_child(new_item)
	new_item.global_position = player_char.global_position
	print("item spot ", new_item.global_position)
	new_item.set_values(item_info)
	new_item.item_amount = amount
	return true

func get_property_from_protoset(object_ID: String, property : String):
	return user_inv.main_kieszen.get_prototree().get_prototype(object_ID).get_property(property)

func check_eq_for(item : String, remove : bool = false, amount : int = 1) -> bool:
	var inv_item = user_inv.find_item_amount(item, amount)
	if inv_item:
		if remove:
			user_inv.remove_item_amount(item, amount)
		return true
	else:
		return false
		
func open_crafting():
	user_inv.activate()
	crafting_ui.activate()

func closeInvUI():
	user_inv.disactivate()
	if crafting_ui.visible == true:
		crafting_ui.disactivate()
	if chest_ui.visible == true:
		close_current_chest()
