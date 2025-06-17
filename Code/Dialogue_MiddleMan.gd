extends Node
class_name Dialogue_MiddleMan

var inv_mag : InventoryManager
var game_mag : GameManager

var var_bool : Dictionary
var var_int : Dictionary
var var_string : Dictionary

func _ready() -> void:
	self.add_to_group("DialogueMM")
	inv_mag = Inventory_manager
	game_mag = Game_Manager
	Inventory_manager.dialogue_mm = self
	
func get_bool(key: String):
	return var_bool.get_or_add(key)
	
func set_bool(key: String, value : bool):
	var_bool[key] = value

func get_int(key: String):
	return var_int.get_or_add(key)
	
func set_int(key: String, value : int):
	var_int[key] = value
	
func get_string(key: String):
	return var_string.get_or_add(key)
	
func set_string(key: String, value : String):
	var_string[key] = value

func check_inventory(item_name : String, amount : int = 1, remove : bool = false) -> bool:
	print("siema")
	return inv_mag.check_eq_for(item_name, amount, remove)
