extends Node

@export var flow_events: Array[FlowEvent]

func _ready():
	EventBus.door_opened.connect(_on_door_opened)
	EventBus.item_picked.connect(_on_item_picked)
	EventBus.item_inserted.connect(_on_item_inserted)
	EventBus.dialogue_started.connect(_on_dialogue_started)
	EventBus.dialogue_choice.connect(_on_dialogue_choice)
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	EventBus.chest_opened.connect(_on_chest_opened)
	EventBus.area_entered.connect(_on_area_entered)
	EventBus.teleport.connect(_teleport)
	EventBus.timeout.connect(_timeout)


func _on_door_opened(door_id):
	print("Door " + door_id + " opened")
	_process_event(FlowEvent.triggers.door, door_id)

func _on_item_picked(item_id):
	print("Item picked up " + item_id)
	_process_event(FlowEvent.triggers.item_pick, item_id)

func _on_area_entered(area_id):
	print("Entered area " + area_id)
	_process_event(FlowEvent.triggers.area_entered, area_id)

func _on_item_inserted(item_id, container_id):
	print("Item " + item_id + " inserted into " + container_id)
	_process_event(FlowEvent.triggers.item_insert, item_id)

func _on_dialogue_started(dialoguer_id):
	print("Dialogue started with " + dialoguer_id)
	_process_event(FlowEvent.triggers.dialogue_started, dialoguer_id)

func _on_dialogue_finished(dialoguer_id):
	print("Dialogue started with " + dialoguer_id)
	_process_event(FlowEvent.triggers.dialogue_finished, dialoguer_id)

func _on_dialogue_choice(dialogue_id, choice_id):
	print("Dialogue " + dialogue_id + " with choice " + choice_id)
	_process_event(FlowEvent.triggers.dialogue_choice, dialogue_id+"+"+choice_id)

func _on_chest_opened(chest_id):
	print("Chest opened " + chest_id)
	_process_event(FlowEvent.triggers.chest_open, chest_id)
	
func _teleport(teleport_id):
	print("Teleport from " + teleport_id)
	_process_event(FlowEvent.triggers.teleport, teleport_id)

func _timeout(timeout_id):
	print("Timeout from " + timeout_id)
	_process_event(FlowEvent.triggers.timeout, timeout_id)

func _process_event(type, id):
	for event in flow_events:
		if event.trigger_type == type and event.trigger_id == id:
			print("Processing flow event for " + id)
			execute_actions(event.actions)

func execute_actions(actions):
	for action in actions:
		await get_tree().process_frame
		var parts = action.split(":")
		var action_name = parts[0]
		var target_name = ""
		if parts.size() > 1:
			target_name = parts[1]
		match action_name:
			"play_sound":
				play_sound(target_name)
			"Interact":
				Interact(target_name)
			"BlackScreen":
				BlackScreen()
			"BlackScreenForTeleport":
				BlackScreenForTeleport()
			"print_debug":
				print_debug(target_name)
			"change_next_loop":
				change_next_loop(target_name)
			"next_loop":
				next_loop_with_change(target_name)
			"set_current_room":
				set_current_room(target_name)
			"timeout":
				timeout(target_name)
			"open_door":
				Open_Door()

func get_from_registry(target_id: String):
	var item = Game_Manager.registry.get(target_id)
	if item == null:
		print_debug("No such thing in registry as " + target_id)
		return null
	return item
	
func play_sound(target_name):
	var target = get_from_registry(target_name)
	if target:
		target.play_sound()

func Interact(target_name):
	var target = get_from_registry(target_name)
	if target:
		target.Interact()
		
func BlackScreen():
	var target = get_from_registry("StartLoop")
	if target:
		target.BlackScreenOnOff()

func BlackScreenForTeleport():
	var target = get_from_registry("StartLoop")
	if target:
		target.BlackForMoment()
		
		
func Open_Door():
	print_debug("Otwieranie drzwi zaimplementować")

func print_debug(message: String):
	if OS.is_debug_build():
		print("[GameFlowController]: " + message)

func change_next_loop(loop: String):
	Game_Manager.next_loop = loop

func next_loop():
	Game_Manager.move_to_next_loop()
	
func next_loop_with_change(loop: String):
	Game_Manager.move_to_next_loop(loop)

func set_current_room(target_room: String):
	Game_Manager.change_current_room(target_room)
	
func timeout(name):
	print_debug("timeout " + name)

func _exit_tree():
	EventBus.door_opened.disconnect(_on_door_opened)
	EventBus.item_picked.disconnect(_on_item_picked)
	EventBus.item_inserted.disconnect(_on_item_inserted)
	EventBus.dialogue_started.disconnect(_on_dialogue_started)
	EventBus.dialogue_choice.disconnect(_on_dialogue_choice)
	EventBus.dialogue_finished.disconnect(_on_dialogue_finished)
	EventBus.chest_opened.disconnect(_on_chest_opened)
	EventBus.area_entered.disconnect(_on_area_entered)
