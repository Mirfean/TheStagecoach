extends Node
class_name Dialogue_MiddleMan

var var_bool : Dictionary
var var_int : Dictionary
var var_string : Dictionary

func _ready() -> void:
	self.add_to_group("DialogueMM")
	Inventory_manager.dialogue_mm = self
	
func get_bool(key: String):
	if not var_bool.has(key):
		var_bool.set(key, false)
	return var_bool.get(key)
	
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

func check_inventory(item_name : String, remove : bool = false, amount : int = 1) -> bool:
	return Inventory_manager.check_eq_for(item_name, remove, amount)

func receive_item(item_name : String, amount : int = 1):
	Inventory_manager.add_item_to_inventory(item_name, amount)

func to_player(order: String):
	Game_Manager.player_char.make_player(order)
	
func send_event_started(dialogue_id: String):
	EventBus.emit_signal("dialogue_started", dialogue_id)

func send_event_finished(dialogue_id: String):
	EventBus.emit_signal("dialogue_finished", dialogue_id)
	
func send_event_choice(dialogue_id: String, choice_id: String):
	EventBus.emit_signal("dialogue_choice", dialogue_id, choice_id)

func end_game():
	Game_Manager.finish_game()
