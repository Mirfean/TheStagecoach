extends Node
class_name InventoryManager

@export var game_manager : GameManager

@export var user_inv : user_inventory
@export var chest_ui : chest_storage
@export var player_char: player

var crafting : crafting_menu
var current_chest : chest

signal Close_Chest
signal Craft_Items_Change
	
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

	
func add_item_from_ground(item_name : String) -> bool:
	print_debug("Pickup ", item_name)
	var new_item = user_inv.main_kieszen.create_and_add_item(item_name)
	print(new_item.get_title())
	for x in new_item.get_properties():
		print(x)
	if new_item != null:
		return true
	return false
	
func get_sprite_from_protoset(object_ID: String) -> String:
	return user_inv.main_kieszen.get_prototree().get_prototype(object_ID).get_property("image")
	#return user_inv.main_kieszen.get_property_from_prototree(object_name, "image")

	
func add_item_to_main() -> bool:
	print("add")
	return true
