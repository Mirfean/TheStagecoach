extends Node
class_name Dialogue_MiddleMan

# FOR ALL THE GAME
var Dvalues : Dictionary 

# TEMP FOR LOOP
var var_temp : Array

# TEMP FOR DIALOGUE
# locals...

func _ready() -> void:
	self.add_to_group("DialogueMM")
	Inventory_manager.dialogue_mm = self

#region Random
func getRandom() -> int:
	return randi_range(0, 100)

func getRandomResult(value: int, range: int) -> bool:
	var random = randi_range(0, 100)
	return random <= value
#endregion

#region DVALUE
func getValue(key: String):
	return Dvalues.get(key, null)

func setValue(key: String, value, send_to_save: bool = false):
	Dvalues[key] = value
	if send_to_save:
		Game_Manager.save.VALUES[key] = value
	
func get_dvalue(key: String):
	if not Dvalues.has(key):
		Dvalues.get_or_add(key, 0)
	return Dvalues.get(key)
	
func set_dvalue(key: String, value):
	Dvalues[key] = value

func increase_dvalue(key: String, amount : int = 1):
	get_dvalue(key)
	Dvalues[key] = Dvalues.get_or_add(key) + amount
#endregion

#region VAR_TEMP
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
#endregion

func check_inventory(item_name : String, remove : bool = false, amount : int = 1) -> bool:
	return Inventory_manager.check_eq_for(item_name, remove, amount)

func receive_item(item_name : String, amount : int = 1):
	Inventory_manager.add_item_to_inventory(item_name, amount)

func to_player(order: String):
	Game_Manager.player_char.make_player(order)

#region events
func send_event_started(dialogue_id: String):
	EventBus.emit_signal("dialogue_started", dialogue_id)

func send_event_finished(dialogue_id: String):
	EventBus.emit_signal("dialogue_finished", dialogue_id)
	
func send_event_choice(dialogue_id: String, choice_id: String):
	EventBus.emit_signal("dialogue_choice", dialogue_id, choice_id)
#endregion

#OBSOLETE?
func getPlayerRoom():
	return Game_Manager.player_char.get_current_room()

#region GAME_CHANGES
func end_game():
	Game_Manager.finish_game()
	
func reset_loop():
	Game_Manager.reset_current_scene()
	
func black_screen(status: bool):
	print_debug("TO DO")
#endregion

#region DIALOGUE_SPECIFIC
func getEnemyResponse(enemy_hp: int, player_hp: int, timer: int) -> String:
	## Jeśli 3 lub mniej ma hp to Charge
	## Throw jeśli wyszedł właśnie ze stuna?
	## Suffocate jeśli gracz 2 lub mniej
	## Steal jeśli timer < 4
	## 
	if enemy_hp <= 3 and not get_temp("Enemy_Charge"):
		return "Charge"
	if get_temp("Enemy_Stunned") and not get_temp("Enemy_Throw"):
		return "Throw"
	if timer <= 4 and not get_temp("Enemy_Steal") and (check_inventory("Molotov cocktail") or check_inventory("Molotov cocktail (sock version)") or check_inventory("Makeshift Spear") or check_inventory("Knife") or (check_inventory("Dissapointment as a weapon") and getValue("Died_BadGun")) or check_inventory("Service gun")):
		return "Steal"
	if not get_temp("Enemy_Suffocate"):
		return "Suffocate"
	if not get_temp("Enemy_Weapon"):
		return "Weapon"
	if not get_temp("Enemy_Throw"): 
		return "Throw"
	return "Charge"
#endregion
	
