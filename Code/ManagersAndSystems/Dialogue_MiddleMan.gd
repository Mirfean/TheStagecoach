extends Node
class_name Dialogue_MiddleMan

var var_bool : Dictionary
var var_int : Dictionary
var var_string : Dictionary

# FOR ALL GAME
var Dvalues : Dictionary 

# TEMP FOR LOOP
var var_temp : Array

# TEMP FOR DIALOGUE
# locals...

func _ready() -> void:
	self.add_to_group("DialogueMM")
	Inventory_manager.dialogue_mm = self
	
func getRandom() -> int:
	return randi_range(0, 100)

func getRandomResult(value: int) -> bool:
	var random = randi_range(0, 100)
	return random <= value

func getValue(key: String):
	return Dvalues.get(key, null)

func setValue(key: String, value, send_to_save: bool = false):
	Dvalues[key] = value
	if send_to_save:
		Game_Manager.save.VALUES[key] = value
	
func get_bool(key: String):
	if not var_bool.has(key):
		var_bool.set(key, false)
	return var_bool.get(key)
	
func set_bool(key: String, value : bool):
	var_bool[key] = value

func get_int(key: String):
	if not var_int.has(key):
		var_int.get_or_add(key, 0)
	return var_int.get(key)
	
func set_int(key: String, value : int):
	var_int[key] = value

#OBSOLETE?
func increase_int(key: String, amount : int = 1):
	get_int(key)
	var_int[key] = var_int.get_or_add(key) + amount
	
func get_string(key: String):
	return var_string.get_or_add(key)
	
func set_string(key: String, value : String):
	var_string[key] = value
	
func add_temp(new: String):
	var_temp.append(new)
	
func remove_temp(rem: String):
	var_temp.erase(rem)

func clear_temp():
	var_temp.clear()
	var_temp.resize(100)
	
func get_temp(item: String, remove: bool = false) -> bool:
	if var_temp.any(func(number): return number == item):
		if remove:
			remove_temp(item)
		return true
	return false

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

func getPlayerRoom():
	return Game_Manager.player_char.get_current_room()

func end_game():
	Game_Manager.finish_game()
	
	
func getEnemyResponse(enemy_hp: int, player_hp: int, timer: int) -> String:
	## Wall pierwszy, później ground
	## Throw jeśli wyszedł właśnie ze stuna?
	## Suffocate jeśli gracz 2 lub mniej
	## Steal jeśli timer < 4
	## Jeśli 2 lub mniej to Charge
	if enemy_hp <= 2 and not get_temp("Enemy_Charge"):
		return "Charge"
	if get_temp("Enemy_Stunned") and not get_temp("Enemy_Throw"):
		return "Throw"
	if timer <= 4 and not get_temp("Enemy_Steal"):
		return "Steal"
	if player_hp <= 2 and not get_temp("Enemy_Suffocate"):
		return "Suffocate"
	if not get_temp("Enemy_Wall"):
		return "Wall"
	return "Ground"
